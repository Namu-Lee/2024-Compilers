# Project 3: Semantic Analysis

- Introduction to Compilers  
  TA: Sanghyeon Lee (sanghyeon@snu.ac.kr)

- Released: November 12, 2024  
  **Due: December 4, 2024**

- Dept. of Electrical and Computer Engineering, Seoul National University

## Table of Contents

  - [Introduction](#introduction)
  - [Environment Setup](#environment-setup)
  - [List of Semantic Checks](#list-of-semantic-checks)
  - [Goal of the Project](#goal-of-the-project)
  - [Submission](#submission)
  - [Tips](#tips)
  - [Appendix](#appendix)

## Introduction

### Semantic analysis

In programming languages, the term "semantics" generally refers to the behavior of a program during execution. Semantic analysis is the process of validating the semantics of a program, after the lexer and parser have finished analyzing its structure.

Here are some examples of the static semantic checks performed by the semantic analyzer at compile-time.

  - Type checking

  - Keeping track of the declarations

  - Checking the scope of an object

### Building a semantic analyzer

Parser generators can automatically build a parser with only a few lines of grammar rules. Similarly to lexers, there is no need to build a parser from scratch. [GNU Bison](https://www.gnu.org/software/bison/) is a widely used open-source [LALR](https://en.wikipedia.org/wiki/LALR_parser) parser generator which is upward compatible with POSIX [yacc](https://en.wikipedia.org/wiki/Yacc) (Yet Another Compiler-Compiler), a standard parser generator on Unix. Throughout this course, we will utilize Bison to generate parsers for subC.

Unfortunately, there is no automatic semantic analyzer generator available. Automatic compilation of a language’s semantics is currently beyond the state of the art. One reason for this is that a program’s semantics are not fully determined at compile-time. For example, out-of-bound accesses for dynamic arrays only can be deteremined at run-time. Therefore, a semantic analyzer should be built using some heuristics.

In this project, we will implement semantic analysis using [GNU Bison](https://www.gnu.org/software/bison/), as a continuation of the previous project.

## Environment Setup

### Pull the repository

Attach to the container and pull the repository to set up the environment for this project.

``` bash
docker exec -it 2024-compilers bash
cd 2024-compilers
git pull
```

### How to build and test

Navigate to the `src` directory, and build the project using `make` command.

``` bash
cd ./src
make all
```

Once the build is completed, you can test it with the following command. If you do not specify the `[input_file]`, `stdin` will be used as the input stream.

``` bash
./subc [input_file]
```

## List of Semantic Checks

This section describes the semantic validations which should be implemented in this project and the corresponding error messages.

In subC, the scope of struct definitions is always considered global unlike the standard C. Also, redefining the structure type is not allowed. However, the scope of struct type objects still follows the standard.

### Undeclared variables and functions

  - If a variable or a function is used before its declaration:
    
    ``` bash
    input.c:10: error: use of undeclared identifier
    ```
    
    *Please assume that there are no implicitly declared functions, recursive functions or structs which contain themselves as a member.*

### Redeclarations

  - If a variable is redefined in the same scope:

  - Or, if a function or struct is redefined in the global scope:
    
    ``` bash
    input.c:10: error: redeclaration
    ```
    
    *Please assume that functions cannot be overloaded.*

### Type checking

  - Assignment operator (`=`)
    
    Please check the semantics. For example,
    
      - If the left-hand side of an assignment operation is not a variable:
        
        ``` bash
        input.c:10: error: lvalue is not assignable
        ```
    
      - If the types of the left-hand side and right-hand side are not the same:
        
        ``` bash
        input.c:10: error: incompatible types for assignment operation
        ```
        
        *Please assume that there are no assignments of a string constant to a pointer type.*  
        *e.g.* `char *s = "Hello World";`
    
      - If the right-hand side is `NULL` but the left-hand side is not a pointer type:
        
        ``` bash
        input.c:10: error: cannot assign 'NULL' to non-pointer type
        ```

  - Binary and logical operators (`+`, `-`, `*`, `/`, `%`, `&&`, `||`, `!`)
    
      - If either operand is not an `int` type:
        
        ``` bash
        input.c:10: error: invalid operands to binary expression
        ```

  - Unary operators (`-`, `++`, `--`)
    
      - If the operand of ‘unary `-`’ is not an `int` type:
    
      - Or, if the operand of ‘`++`, `--`’ is not an `int` or `char` type:
        
        ``` bash
        input.c:10: error: invalid argument type to unary expression
        ```

  - Relational operators (`>=`, `>`, `<=`, `<`)
    
      - If the operands are not both `int` or both `char` types:
        
        ``` bash
        input.c:10: error: types are not comparable in binary expression
        ```

  - Equality operators (`==`, `!=`)
    
      - If the operands are not both `int`, both `char`, both pointers of same types (including `struct*`):
        
        ``` bash
        input.c:10: error: types are not comparable in binary expression
        ```
        
        *Please assume that there are no operations between the pointer type and array type, or between the array type and array type. For example:*
        
        ``` objectivec
        int *a;
        int b[9];
        a = b;
        a == b;  
        ```

  - Indirection operator (unary `*`)
    
      - If the operand is not a pointer type:
        
        ``` bash
        input.c:10: error: indirection requires pointer operand
        ```

  - Address-of operator (unary `&`)
    
      - If the operand is not a variable:
        
        ``` bash
        input.c:10: error: cannot take the address of an rvalue
        ```

  - Member access operators (`.`, `->`)
    
      - If the left-hand side is not a struct type:
        
        ``` bash
        input.c:10: error: member reference base type is not a struct
        ```
    
      - If the left-hand side is not a struct pointer type:
        
        ``` bash
        input.c:10: error: member reference base type is not a struct pointer
        ```
    
      - If the struct does not have a specific member:
        
        ``` bash
        input.c:10: error: no such member in struct
        ```

  - Subscript operator (`[`, `]`)
    
      - If a subscript operator is used on non-array variable:
        
        ``` bash
        input.c:10: error: subscripted value is not an array
        ```

### Structure & structure pointer declarations

  - If an object of an undefined struct type is declared:
    
        input.c:10: error: incomplete type

### Function declarations

  - If the declared return type is different from the type of the return value in its definition:
    
        input.c:10: error: incompatible return types
    
    *Please assume that there are no non-void type functions without a return statement.  
    Also, functions returning struct types do not need to be type checked.*

  - If a non-function entity is called:
    
        input.c:10: error: not a function

  - If the function arguments differ from the parameters:
    
        input.c:10: error: incompatible arguments in function call

## Goal of the Project

You have to implement semantic analysis in addition to your existing parser. The parser should be able to detect semantic errors in the input program and print the error messages. Additionally, the parser should continue analyzing the program until it reaches the end of the program, even after encountering a semantic error.

Also, you need to implement a scoped symbol table to validate the semantics of a program. You may implement any type of scoped symbol table as long as it supports effective semantic analysis.

Complete the code in `subc.l`, `subc.y`, and `hash.c`. You may add or modify any files in the `src` directory as needed, but please make sure that the project can be built using `make all` command.

In the report, please briefly describe how you implemented the semantic analysis in two pages or less.

### Output format

Each time the parser encounters a semantic error, print the corresponding error message to stderr in the following format.

``` bash
<file_name>:<line_number>: error: <description>
```

  - Separate the messages with a **space**, right before and after `error:`.

  - Utilize `read_line()` function to get a line number.

  - You don’t have to consider the errors that occur across multiple lines.

  - If there are multiple errors in the same line, print the error from the earliest reduced production.

A demonstrative example of an input-output pair is given below.

**Disregarding the output rules will result in a penalty to your project score.**

#### I/O Example

Input code: `input.c`

``` numberLines objectivec
int main() {
  int a;
  a = 5;
  a = 'a';  /* Semantic error */
  return 0;
}
```

Output message:

``` bash
$ ./subc input.c
input.c:4: error: incompatible types for assignment operation
```

## Submission

  - Place your report somewhere in the project directory. The file name must be `report.pdf`.

  - Run `./submit.sh <student_number>` in the container. For example, `./submit.sh 1234-56789`. It will compress `src` directory and `report.pdf`.

  - Submit the compressed archive on [eTL](https://etl.snu.ac.kr).

  - Please make sure that the name of the archive is `project3_<student_number>.zip` and your student number is correct. **Incorrect student number may result in a penalty to your project score.**

  - For delayed submissions, there will be a 20% deduction in scores per day.

## Tips

  - It is highly recommended to utilize the [midrule actions](https://www.gnu.org/software/bison/manual/html_node/Mid_002dRule-Actions.html) of bison. You may need to perform some actions in the middle of the productions to analyze the semantics.

  - Midrule actions may introduce new conflicts in the grammar. It is possible to modify the grammar to resolve the conflicts. But, please ensure that the modified grammar **MUST** remain syntactically equivalent to the original. That is, the order of reductions must not be changed after the modification, so that the order of error messages remain unchanged when the multiple errors occur in a line. If you modified the grammar, please describe how you modified the grammar in the report.

  - The overall design in this project will be carried over to the next project, so please thoroughly review the lecture slides (ch. 7 & 8) and the subC grammar before starting this project.

## Appendix

[GNU Bison Manual](https://www.gnu.org/software/bison/manual/bison.html)