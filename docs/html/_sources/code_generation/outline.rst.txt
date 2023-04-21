********************
Outline
********************



.. code-block:: cpp

    Context::Context(Program *program) {
        // ... Create stuff

        generateVirtualTable();
        generateStructs();
        program->codegen(this);
        generateInterfaceOffsetTable();
    }

    GenValue *Program::codegen(Context *ctx) {
        // Generate the interface declaration first
        for (auto interfaceDecl: interfaceDecls) {
            interfaceDecl.second->codegen(ctx);
        }
        // We create function of each static method first(but not generate code),
        // because we could need to call static functionw when generating a static function
        for (auto staticDecl: staticDecls) {
            staticDecl.second->createFunctions(ctx);
        }
        // Generate each static functions
        for (auto staticDecl: staticDecls) {
            staticDecl.second->codegen(ctx);
        }
        // Generate each method of each class,
        // Each class will have a unique id
        int id = 0;
        for (auto classDecl: classDecls) {
            ctx->setClassIndex(classDecl.first, id);
            classDecl.second->codegen(ctx);
            ++id;
        }
        return nullptr;
    }

    GenValue *ClassDecl::codegen(Context* ctx) {
        ctx->setCurClass(this);

        // The first two elements of a virtual table is the class id and parent vtable
        int index = 2; 
        for (auto f: methods) {
            f->codegen(ctx);
            ctx->insertIntoVTableInitializer(Name(), index, ctx->CurFunction());
            ++index;
        }
        // We fill the vtable with the filled initializer list
        ctx->buildVTable(this);
        ctx->clearCurClass();
        return nullptr;
    }

    GenValue * StaticDecl::codegen(Context *ctx) {
        ctx->setCurStatic(this);
        for (auto f: methods) {
            f->codegen(ctx);
        }
        ctx->clearCurStatic();
        return nullptr;
    }

    void StaticDecl::createFunctions(Context *ctx) {
        for (auto f: methods) {
            ctx->createStaticFunction(Name(), f->Header());
        }
    }