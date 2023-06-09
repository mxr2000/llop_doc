**********************
Statements
**********************

Variable Declaration
--------------------

Example:

.. code-block:: 

    VAR age: Int

.. code-block:: antlr

    variableDeclStatement: VAR IDENTIFIER ':' type
    ;


If Statement
------------

.. code-block:: 

    IF (self.salary > 1000) THEN
        self.salary = 1000
    ELSE
        self.salary = 500

.. code-block:: antlr

    ifStatement: IF '(' expr ')' THEN stmt (ELSE stmt)?
    ;

While Statement
---------------

.. code-block:: 

    WHILE (self.salary > 0)
        self.salary = self.salary - 1

.. code-block:: antlr

    whileStatement: WHILE '(' expr ')' stmt
    ;

Return Statement
----------------

.. code-block:: 

    RETURN p1.getAge() - p2.getAge()

.. code-block:: antlr

    returnStatement: RETURN expr
    ;


Output Statement
----------------

.. code-block:: 

    OUTPUT 1

.. code-block:: antlr

    outputStatement: OUTPUT expr
    ;


Assignment
----------

.. code-block:: 

    a = 10

.. code-block:: antlr

    assignStatement: expr '=' expr
    ;

Block Statement
---------------

.. code-block:: 

    BEGIN
        VAR a: Int
        a = 10
        OUTPUT a
    END

.. code-block:: antlr

    blockStatement: BEGIN (stmt)* END
    ;

