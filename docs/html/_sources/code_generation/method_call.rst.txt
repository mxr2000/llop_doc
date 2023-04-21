********************
Method Call
********************


Function Overloadding
---------------------

A function is alloed to be overloaded. Overloadded function must have differnt parameters.

Determine which overloadded function to run:
1. Determine name is equal or not
2. Determine types arguments can be upcasted ot not

.. code-block:: c++

    std::pair<int, FuncHeader *> Context::getClassMethodIndex(
            ::Type *classType, 
            const std::string &name, 
            const std::vector<GenValue *> &params
            ) {
        auto classDecl = program->Classes()[classType->toString()];
        auto methods = classDecl->Methods();
        auto iter = std::find_if(methods.begin(), methods.end(),
                             [this, &params, &name](FuncDecl *m) { return name == m->Header()->Name() && isFunctionType(params, m->Header()); });
        if (iter == methods.end()) {
            return std::make_pair(-1, nullptr);
        }
        return std::make_pair(iter - methods.begin(), (*iter)->Header());
    }


Class Method Call
---------------------

.. code-block:: cpp

    GenValue *FuncCallExpr::generateClassMethodCall(Context *ctx, std::vector<GenValue *> &genArgs) {
        GenValue *receiver = ctx->Receiver();
        if (receiver == nullptr) {
            receiver = ctx->Self(); // If there is no recevier, receiver is the self porinter
        }

        // find the index of the function in the virtual function table 
        auto pair = ctx->getClassMethodIndex(receiver->Type(), Name(), genArgs);
        if (pair.first != -1) {
            std::vector<Value *> args;

            // First add receiver pointer
            args.push_back(receiver->Value()); 

            // Add remaining arguments
            for (auto itr: genArgs) {
                args.push_back(itr->Value());
            }

            auto className = receiver->Type()->toString();
            auto tableType = ctx->getVtableType(className);

            // load the virtual function table from the receiver object
            Value *table = ctx->Builder().CreateLoad(PointerType::get(tableType, 0),
                                                 ctx->Builder().CreateStructGEP(ctx->getStructType(className), receiver->Value(), 0));
            // load virtual table of parent class
            if (receiver->isSuper()) {
                std::vector<Value *> indices;
                indices.push_back(ConstantInt::get(ctx->IntType, 0));
                indices.push_back(ConstantInt::get(ctx->IntType, 1));
                auto tp = ctx->Builder().CreateGEP(tableType, table, indices);
                table = ctx->Builder().CreateLoad(PointerType::get(tableType, 0), tp);
            }

            std::vector<Value *> indices;
            indices.push_back(ConstantInt::get(ctx->IntType, 0));
            indices.push_back(ConstantInt::get(ctx->IntType, pair.first + 2));
            
            // Load the function with the index
            Value *fp = ctx->Builder().CreateGEP(tableType, table, indices);
            Value *f = ctx->Builder().CreateLoad(ctx->IntPtrType, fp);

            auto result = ctx->Builder().CreateCall(ctx->headerToLlvmType(pair.second, true), f, args);
            return new GenValue(pair.second->ReturnType(), result);
        }
        return nullptr;
    }


Static Method Call
---------------------

.. code-block:: cpp

    GenValue *FuncCallExpr::generateStaticMethodCall(Context *ctx, std::vector<GenValue *> &genArgs) {
        // Find the exact function
        auto f = ctx->getStaticMethod(Name(), genArgs);
        if (f.first == nullptr) {
            return nullptr;
        }
        std::vector<Value *> args;
        args.reserve(genArgs.size());
        for (auto itr: genArgs) {
            args.push_back(itr->Value());
        }
        auto result = ctx->Builder().CreateCall(ctx->headerToLlvmType(f.second, false), f.first, args);
        return new GenValue(f.second->ReturnType(), result);
    }

Branches
---------

If Statement
^^^^^^^^^^^^

.. code-block:: cpp

    GenValue * IfStmt::codegen(Context *ctx) {
        auto conditionValue = condition->codegen(ctx);

        auto thenBlock = ctx->createBasicBlock("then");
        auto elseBlock = ctx->createBasicBlock("else");
        auto mergeBlock = ctx->createBasicBlock("merge");

        ctx->Builder().CreateCondBr(conditionValue->Value(), thenBlock, elseBlock);

        ctx->Builder().SetInsertPoint(thenBlock);
        thenStmt->codegen(ctx);
        ctx->Builder().CreateBr(mergeBlock);

        ctx->Builder().SetInsertPoint(elseBlock);
        if (elseStmt != nullptr) {
            elseStmt->codegen(ctx);
        }
        ctx->Builder().CreateBr(mergeBlock);

        ctx->Builder().SetInsertPoint(mergeBlock);
        return nullptr;
    }

While Statement
^^^^^^^^^^^^^^^

.. code-block:: cpp

    GenValue *WhileStmt::codegen(Context *ctx) {
        auto headerBlock = ctx->createBasicBlock("header");
        auto bodyBlock = ctx->createBasicBlock("body");
        auto exitBlock = ctx->createBasicBlock("exit");

        ctx->Builder().CreateBr(headerBlock);

        ctx->Builder().SetInsertPoint(headerBlock);
        auto conditionValue = condition->codegen(ctx);
        ctx->Builder().CreateCondBr(conditionValue->Value(), bodyBlock, exitBlock);

        ctx->Builder().SetInsertPoint(bodyBlock);
        body->codegen(ctx);
        ctx->Builder().CreateBr(exitBlock);

        ctx->Builder().SetInsertPoint(exitBlock);
        return nullptr;
    }