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

Idea here is that we want to seperate the static methods and fields from class ones, just like Scala.
We have not implemented static fields yet because of recursive dependencies.

.. code-block::

  STATIC Person
  BEGIN
    FUNC compare(p1: Person, p2: Person) -> Int
    BEGIN
        RETURN p1.getAge() - p2.getAge()
    END
  END

Interface Declaration
---------------------

