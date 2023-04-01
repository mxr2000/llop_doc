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