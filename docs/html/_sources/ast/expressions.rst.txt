**********************
Expressions
**********************

Binary Expression
--------------------
Used to compute ninary operations

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

Used to call static functions or access static variables(not inmplemented yet)

Example:

.. code-block:: 

    eat(b)

.. code-block:: antlr

    funCallExpr: IDENTIFIER argumentList
    ;


Type Coercion
-------------

Used to coerce one type to another

Example:

.. code-block:: 

    person.[Employee]

.. code-block:: antlr

    typeCoercionExpr: expr'.' '[' referenceType ']'
    ;


Access
------

Used to call a class method or access a field from an object

Example:

.. code-block:: 

    person.[Employee]

.. code-block:: antlr

    accessExpr: expr'.' '[' referenceType ']'
    ;


And
-----

Used to compute a binary and boolean operation

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

Create a new object 

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


Array Creation
--------------

Create a new array. The element type can be basic types, class or another array

.. code-block::

    NEW [Int](5)
    NEW [Person](8)
    NEW [[Int]](10 * 8)

.. code-block:: antlr

    newArrayExpr: NEW arrayType '(' expr ')'


Array Index
-----------

Index an array

.. code-block:: cpp

    arr[10]
    arr[2][3 * 5]

.. code-block:: antlr

    arrayIndexExpr: expr '[' expr ']'