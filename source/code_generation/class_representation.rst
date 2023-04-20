********************
Class Rep
********************


Struct
------

Each object is represented as a struct. The first field is a pointer to its virtual table, and the remains are its class fields

.. code-block:: llvm

    %struct_Person = type { ptr, i32, i32 }


Virtual Table
-------------

The first element of a virtual table is a pointer to the class identifier. This is used to determine type in runtime.
The second element is a pointer to the virtual table of this class's parent class, because we want to efficiently access parent class's method 
during runtime efficiently.
The remains are pointers to its actual function implementation. If a method is inherited from its parent's class, 
then the pointer of this method is the same with its parent's one, else it will be another one

.. code-block:: llvm

    @id_Object = internal constant i32 0
    @id_Person = internal constant i32 1
    @id_Employee = internal constant i32 2  

    @vtable_Object = internal constant [2 x ptr] [ptr @id_Object, ptr @vtable_Object]
    @vtable_Person = internal constant [5 x ptr] [ptr @id_Person, ptr @vtable_Object, ptr @Person_init_Int_Int, ptr @Person_getAge, ptr @Person_getSalary]
    @vtable_Employee = internal constant [8 x ptr] [ptr @id_Employee, ptr @vtable_Person, ptr @Employee_init_Int_Int_Int, ptr @Person_getAge, ptr @Employee_getSalary, ptr @Employee_consume, ptr @Employee_earn, ptr @Employee_eat]


Type Id
-------


