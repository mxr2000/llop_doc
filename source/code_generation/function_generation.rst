********************
Function Generation
********************

1. If the method is a static method, it must be created first, because during the generation of this method, it may call other static methods.
2. Else if the class is a class method, we must create this method
3. If the method is already generated, we just finish it.
4. We create the top-level function table and load arguments into the table
5. We generate the block statement
6. If the function returns void and the last statement is not a return, we will insert a return void
7. If the function returns another type and the last statement is not a return statemtn, we throw an error

.. code-block:: cpp

    GenValue * FuncDecl::codegen(Context *ctx) {

        // If this function has already been generated, return
        if (ctx->GeneratedFunctions.count(this) != 0) {
            ctx->setCurFunction(ctx->GeneratedFunctions[this]);
            return nullptr;
        }

        // Main function must have a return type of integer
        if (this->header->Name() == "main" && this->header->ReturnType()->toString() != "Int") {
            std::cout << "return type of main must be int!";
        }

        llvm::Function* function{};

        // If this is a static function, this funciton should be created before
        if (ctx->IsInStaticMethod()) {
            function = ctx->getStaticMethod(header);
            if (function == nullptr) {
                throw std::runtime_error("static method is not found");
            }
        } else {
            // This must be a class emthod that needs to be created first
            function = ctx->createCurFunction(header);
        }
        ctx->setCurFunction(function);
        ctx->pushSymbolTable();
        auto f = ctx->CurFunction();

        // If this is a class method, the first argument should be the receiver pointer
        if (!ctx->IsInStaticMethod()) {
            ctx->addValueToCurrentTable("self", new SelfGenValue(ctx->CurClass()->Type(), f->args().begin()));
        }
        auto entryBlock = ctx->createBasicBlock("entry");
        ctx->Builder().SetInsertPoint(entryBlock);

        // Load arguments into local veriables
        for (int i = 0; i < header->Params().size(); i++) {
            int index = ctx->IsInStaticMethod() ? i : (i + 1);
            auto alloc = ctx->Builder().CreateAlloca(ctx->IntPtrType);
            ctx->Builder().CreateStore(f->args().begin() + index, alloc);
            ctx->addValueToCurrentTable(header->Params()[i]->Name(),
                                    new GenValue(header->Params()[i]->Type(), alloc));
        }
        block->codegen(ctx);

        // A function must return if it does not have a void return type
        if (!isLastLineReturnStmt()) {
            if (header->ReturnType()->isVoid()) {
                ctx->Builder().CreateRetVoid();
            } else {
            //throw std::runtime_error("Last stmt is not return stmt");
            }
        }
        ctx->GeneratedFunctions.insert(std::make_pair(this, ctx->CurFunction()));
        ctx->popSymbolTable();
        return nullptr;
    }

    llvm::Function *Context::createCurFunction(FuncHeader *header) {
        if (IsInStaticMethod()) {
            throw std::runtime_error("Static method should not call this function");
        }
        return Function::Create(
                headerToLlvmType(header, !IsInStaticMethod()),
                Function::ExternalLinkage,
                getMethodSignature(curStatic == nullptr ? curClass->Name() : curStatic->Name(), header),
                TheModule);
    }