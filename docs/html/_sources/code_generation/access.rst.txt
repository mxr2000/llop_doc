********************
Access
********************

.. code-block:: cpp

    GenValue *AccessExpr::codegen(Context* ctx) {
        ctx->incrementAccessLevel();
        auto l = lhs->codegen(ctx);
        if (!l->Type()->isPointerType()) {
            throw std::runtime_error("Lhs is not a reference type");
        }
        ctx->decrementLevelAccess(); // decrement level access before first accessing rhs

        ctx->setReceiver(l); // set receiver before accessing rhs
        auto result = rhs->codegen(ctx);
        ctx->clearReceiver(); // clear receiver after accessing rhs
        return result;
    }

    GenValue * SelfExpr::codegen(Context *ctx) {
        return ctx->Self();
    }

    GenValue * SuperExpr::codegen(Context *ctx) {
        return ctx->Super();
    }

    GenValue * StaticAccessExpr::codegen(Context *ctx) {
        ctx->setStaticAccess(type);
        return expr->codegen(ctx);
    }