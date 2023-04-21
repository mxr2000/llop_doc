*********************
New Object Expression
*********************

To generate a new object, we need to do the following things:

1. Get the size of the struct 
2. Call the calloc function with the size
3. Set the first field of the struct to be the pointer to the virtual table
4. Call the init function with all generated arguments 

Example: NEW Person(10, 100)

.. code-block:: llvm

    %calloced = call ptr @calloc(i32 1, i32 16)
    %3 = getelementptr inbounds %struct_Person, ptr %calloced, i32 0, i32 0
    store ptr @vtable_Person, ptr %3, align 8
    %4 = load ptr, ptr getelementptr inbounds ([5 x ptr], ptr @vtable_Person, i32 0, i32 2), align 8
    %5 = call i32 %4(ptr %calloced, i32 10, i32 100)

.. code-block:: cpp

    uint64_t Context::getStructSize(const std::string &name) {
        auto classStruct = classStructs[name];
        return TheModule.getDataLayout().getStructLayout(classStruct)->getSizeInBytes();
    }

    GenValue *NewObjectExpr::codegen(Context *ctx) {
        // get the struct size according to the module's data layout
        auto sizeOfClass = ctx->getStructSize(type->Name());

        // call calloc function
        std::vector<Value *> callocArgs;
        callocArgs.push_back(ConstantInt::get(ctx->IntType, 1));
        callocArgs.push_back(ConstantInt::get(ctx->IntType, sizeOfClass));
        auto calloc = ctx->Builder().CreateCall(ctx->CallocFunction, callocArgs, "calloced");

        // set the object's vtable pointer
        auto structType = ctx->getStructType(type->Name());
        auto vtable = ctx->getVtable(type->Name());
        ctx->Builder().CreateStore(
            vtable,
            ctx->Builder().CreateStructGEP(structType, calloc, 0));

        // prepare the arguments of the init function
        std::vector<Value*> args;
        args.push_back(calloc);
        for (auto expr: arguments) {
            args.push_back(expr->codegen(ctx)->Value());
        }

        // load the init function from the vtable
        std::vector<Value *> indices;
        indices.push_back(ConstantInt::get(ctx->IntType, 0));
        indices.push_back(ConstantInt::get(ctx->IntType, 2)); // index for init function
        auto tableType = ctx->getVtableType(type->Name());
        Value *fp = ctx->Builder().CreateGEP(tableType, vtable, indices);
        Value *f = ctx->Builder().CreateLoad(ctx->IntPtrType, fp);

        // call init function
        ctx->Builder().CreateCall(ctx->headerToLlvmType(ctx->getMethodHeader(type, 2), true), f, args);
        return new GenValue(type, calloc);
    }
