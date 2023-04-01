**********************
Top Level Declarations
**********************

Class Declaration
-----------------

    A class declaration, with its super class and the interfaces it implements

.. code-block:: 

  CLASS Person (Object) []
  BEGIN
    VAR age: Int
    VAR salary: Int

    FUNC init(age: Int, salary: Int) -> Void
    BEGIN
        self.age = age
        self.salary = salary
    END

    FUNC getAge() -> Int
    BEGIN
        RETURN self.age
    END

    FUNC getSalary() -> Int
    BEGIN
        RETURN self.age
    END
  END


Method Declaration
------------------

  A method declaration includes its function signature and its body

.. code-block::

  FUNC getAge() -> Int
  BEGIN
    RETURN self.age
  END


Static Declaration
------------------

sss

Interface Declaration
---------------------

