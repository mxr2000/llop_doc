**********************
Expressions
**********************

Binary Expression
--------------------

Example:

.. code-block:: 

    a + b
    a - b

.. code-block:: antlr

    multiplicativeExpr: expr op=(MUL | DIV) expr
    ;
    additiveExpr: expr op=(ADD | SUB) expr
    ;


Is Expression
-------------

Example:

.. code-block:: 

    a is Person

.. code-block:: antlr

    isExpr: expr IS referenceType
    ;


Static Access
-------------

Example:

.. code-block:: 

    Person::compare

.. code-block:: antlr

    staticAccessExpr : referenceType '::' expr
    ;


Function Call
-------------

Example:

.. code-block:: 

    eat(b)

.. code-block:: antlr

    funCallExpr: IDENTIFIER argumentList
    ;


Type Coercion
-------------

Example:

.. code-block:: 

    person.[Employee]

.. code-block:: antlr

    typeCoercionExpr: expr'.' '[' referenceType ']'
    ;


Access
------

Example:

.. code-block:: 

    person.[Employee]

.. code-block:: antlr

    accessExpr: expr'.' '[' referenceType ']'
    ;


And
-----

Example:

.. code-block:: 

    a == 10 AND b == 9

.. code-block:: antlr

    andExpr: expr AND expr
    ;


Or
-----

Example:

.. code-block:: 

    a == 10 OR b == 9

.. code-block:: antlr

    orExpr: expr OR expr
    ;

Not
-----

Example:

.. code-block:: 

    NOT (a > b)

.. code-block:: antlr

    notExpr: NOT
    ;


Relational Expr
---------------

Example:

.. code-block:: 

    a >= 9

.. code-block:: antlr

    relationalExpr: expr op=(EQ | NE | GT | LT | LE |GE) expr
    ;


New Object
----------

.. code-block:: 

    NEW Person(10, 20)

.. code-block:: antlr

    newExpr: NEW referenceType argumentList
    ;


Number
----------

.. code-block:: 

    NEW Person(10, 20)

.. code-block:: antlr

    numExpr: NUMBER
    ;
    NUMBER : [0-9]+ 
    ;
