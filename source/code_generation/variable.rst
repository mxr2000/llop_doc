********************
Variable
********************

Whenever we meets a variable declaration, we create an allocation and stores it to current symbol table

The logic of loading a variable here is complecated:

1. If the receiver is null, we find if there is any local variable with the same name
2. If we cannot find one, this could only be a field of an object
3. If the receiver is self or it is null, we find if there is a field in this class with the same name
4. Else, we find the field on the receiver type's class struct
5. If we could not find one, throw an error
6. If the variable is the left value and its the top-level access, we return the pointer to the value rather than load the value

.. code-block:: cpp

    GenValue *VariableDeclStmt::codegen(Context *ctx) {
        auto value = ctx->Builder().CreateAlloca(ctx->IntPtrType);
        ctx->addValueToCurrentTable(Name(), new GenValue(type, value));
        return nullptr;
    }


    GenValue *getLoadedValue(Context *ctx, GenValue *variable) {
        auto type = variable->Type();
        auto value = variable->Value();
        Value *loaded{};

        if (type->isPointerType()) {
            loaded = ctx->Builder().CreateLoad(ctx->IntPtrType, value, "var");
        } else {
            loaded = ctx->Builder().CreateLoad(ctx->IntType, value, "var");
        }

        return new GenValue(type, loaded);
    }

    GenValue *VariableExpr::codegen(Context *ctx) {
        // load pointer when it is in left value and top level access
        bool loadPointer = ctx->LeftValueFlag() && ctx->TopLevelAccess();

        if (ctx->Receiver() == nullptr) {
            GenValue* variable = ctx->findVariable(Name());
            if (variable != nullptr) {
                // We found a local variable, return
                return loadPointer ? variable : getLoadedValue(ctx, variable);
            }
        }

        std::pair<int, ::Type*> field;
        GenValue* receiver{};

        // The receiver is null of self
        if (ctx->Receiver() == nullptr || ctx->Receiver()->isSelf()) {
            field = ctx->getFieldRuntime(Name());
            receiver = ctx->Self();
        } else {
            // The receiver is not null(an object)
            field = ctx->getFieldRuntime(Name(), ctx->Receiver()->Type());
            receiver = ctx->Receiver();
        }
        if (field.second == nullptr) {
            throw std::runtime_error("Field or variable: " + Name() + " cannot be found");
        }
        Value *address = ctx->Builder().CreateStructGEP(
                ctx->getStructType(receiver->Type()->toString()),
                receiver->Value(),
                field.first
        );
        auto* pointer = new GenValue(field.second, address);
        return loadPointer ? pointer : getLoadedValue(ctx, pointer);
    }