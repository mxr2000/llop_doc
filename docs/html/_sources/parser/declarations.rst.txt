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
------------

.. code-block:: 

    WHILE (self.salary > 0)
        self.salary = self.salary - 1

.. code-block:: antlr

    whileStatement: WHILE '(' expr ')' stmt
    ;