********************
Boolean Expression
********************


And Expression
--------------

.. code-block:: cpp

    GenValue *AndExpr::codegen(Context* ctx) {
        auto leftBlock = ctx->createBasicBlock("left");
        auto rightBlock = ctx->createBasicBlock("right");
        auto mergeBlock = ctx->createBasicBlock("merge");

        ctx->Builder().CreateBr(leftBlock);

        ctx->Builder().SetInsertPoint(leftBlock);
        auto l = lhs->codegen(ctx);
        ctx->Builder().CreateCondBr(l->Value(), mergeBlock, rightBlock);

        ctx->Builder().SetInsertPoint(rightBlock);
        auto r = rhs->codegen(ctx);
        ctx->Builder().CreateBr(mergeBlock);

        ctx->Builder().SetInsertPoint(mergeBlock);
        auto phi = ctx->Builder().CreatePHI(ctx->IntType, 2);
        phi->addIncoming(l->Value(), leftBlock);
        phi->addIncoming(r->Value(), rightBlock);

        return new GenValue(new ValueType("Int"), phi);
    }

Or Expression
--------------    

.. code-block:: cpp
    
    GenValue *OrExpr::codegen(Context *ctx) {
        auto leftBlock = ctx->createBasicBlock("left");
        auto rightBlock = ctx->createBasicBlock("right");
        auto mergeBlock = ctx->createBasicBlock("merge");

        ctx->Builder().CreateBr(leftBlock);

        ctx->Builder().SetInsertPoint(leftBlock);
        auto l = lhs->codegen(ctx);
        ctx->Builder().CreateCondBr(l->Value(), leftBlock, mergeBlock);

        ctx->Builder().SetInsertPoint(rightBlock);
        auto r = rhs->codegen(ctx);
        ctx->Builder().CreateBr(mergeBlock);

        ctx->Builder().SetInsertPoint(mergeBlock);
        auto phi = ctx->Builder().CreatePHI(ctx->IntType, 2);
        phi->addIncoming(l->Value(), leftBlock);
        phi->addIncoming(r->Value(), rightBlock);

        return new GenValue(new ValueType("Int"), phi);
    }

Not Expression
--------------

.. code-block:: cpp

    GenValue *NotExpr::codegen(Context *ctx) {
        auto val = expr->codegen(ctx);
        auto result = ctx->Builder().CreateICmpEQ(val->Value(), ctx->ZeroInt);
        return new GenValue(val->Type(), result);
    }