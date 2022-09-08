parser grammar SCParser;

options {
  tokenVocab=SCLexer;
}

root : topLevelStatement* EOF ;

topLevelStatement : classDef
                  | classExtension
                  | interpreterCode
                  ;

classDef : CLASSNAME superclass? CURLY_OPEN classVarDecl* methodDef* CURLY_CLOSE
         | CLASSNAME SQUARE_OPEN name? SQUARE_CLOSE superclass? CURLY_OPEN classVarDecl* methodDef* CURLY_CLOSE
         ;

superclass : COLON CLASSNAME ;

classVarDecl : CLASSVAR rwSlotDefList SEMICOLON
             | VAR rwSlotDefList SEMICOLON
             | CONST constDefList SEMICOLON
             ;

rwSlotDefList : rwSlotDef (COMMA rwSlotDef)* ;

rwSlotDef : rwSpec? name (EQUALS literal)? ;

rwSpec : LESS_THAN
       | GREATER_THAN
       | READ_WRITE
       ;

name : NAME
     | WHILE
     ;

literal : coreLiteral
        | listLiteral
        ;

coreLiteral : integer
            | floatingPoint
            | strings
            | symbol
            | CHARACTER
            ;

integer : integerNumber
        | MINUS integerNumber
        ;

integerNumber : INT
              | INT_HEX
              | INT_RADIX
              ;

floatingPoint : floatLiteral
              | floatLiteral PI
              | integer PI
              | PI
              | MINUS PI
              | accidental
              ;

floatLiteral : floatNumber
             | MINUS floatNumber
             ;

floatNumber : FLOAT
            | FLOAT_RADIX
            | FLOAT_SCI
            | INF
            ;

accidental : FLOAT_FLAT
           | FLOAT_FLAT_CENTS
           | FLOAT_SHARP
           | FLOAT_SHARP_CENTS
           ;

strings : STRING+ ;

symbol : SYMBOL_QUOTE
       | SYMBOL_SLASH
       ;

listLiteral : coreLiteral
            | innerListLiteral
            | innerDictLiteral
            | name
            ;

innerListLiteral : SQUARE_OPEN listLiterals? SQUARE_CLOSE
                 | CLASSNAME SQUARE_OPEN listLiterals? SQUARE_CLOSE
                 ;

listLiterals : listLiteral (COMMA listLiteral)* ;

innerDictLiteral : PAREN_OPEN dictLiterals? PAREN_CLOSE ;

dictLiterals : dictLiteral (COMMA dictLiteral)* ;

dictLiteral : listLiteral COLON listLiteral
            | KEYWORD listLiteral
            ;

constDefList : rSlotDef (COMMA rSlotDef)* ;

rSlotDef   : LESS_THAN? name
           | LESS_THAN? name EQUALS literal
           ;

methodDef : ASTERISK? methodDefName CURLY_OPEN argDecls? varDecls? primitive? body? CURLY_CLOSE ;

methodDefName : name
           | binop
           ;

argDecls : ARG varDefList SEMICOLON
         | ARG varDefList? ELLIPSES name SEMICOLON
         | PIPE pipeDefList PIPE
         | PIPE pipeDefList? ELLIPSES name PIPE
         ;

varDefList : varDef (COMMA varDef)* ;

varDef : name
       | name EQUALS expr
       | name PAREN_OPEN exprSeq PAREN_CLOSE
       ;

expr : literal
     | block
     | listComp
     | name
     | UNDERSCORE
     | PAREN_OPEN exprSeq PAREN_CLOSE
     | TILDE name
     | SQUARE_OPEN arrayElems SQUARE_CLOSE
     | PAREN_OPEN numericSeries PAREN_CLOSE
     | PAREN_OPEN COLON numericSeries PAREN_CLOSE
     | PAREN_OPEN dictLiterals? PAREN_CLOSE
     | expr SQUARE_OPEN argList SQUARE_CLOSE
     | expr SQUARE_OPEN argList SQUARE_CLOSE EQUALS expr
        // IndexSeries
     | expr SQUARE_OPEN argList DOT_DOT exprSeq? SQUARE_CLOSE
     | expr SQUARE_OPEN DOT_DOT exprSeq SQUARE_CLOSE
        // IndexSeriesAssign (expr)
     | expr SQUARE_OPEN argList DOT_DOT exprSeq? SQUARE_CLOSE EQUALS expr
     | expr SQUARE_OPEN DOT_DOT exprSeq SQUARE_CLOSE EQUALS expr
     | CLASSNAME
     | expr binopKey adverb? expr
     | name EQUALS expr
     | TILDE name EQUALS expr
     | expr DOT name EQUALS expr
     | name PAREN_OPEN argList keyArgList? PAREN_CLOSE EQUALS expr
     | HASH multiAssignVars EQUALS expr
     // messages
     | name block+
     | PAREN_OPEN binopKey PAREN_CLOSE block+
     | name PAREN_OPEN PAREN_CLOSE block+
     | name PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
     | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN PAREN_CLOSE block+
     | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
     | name PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
     | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
     | CLASSNAME SQUARE_OPEN arrayElems? SQUARE_CLOSE
     | CLASSNAME block+
     | CLASSNAME PAREN_OPEN PAREN_CLOSE block*
     | CLASSNAME PAREN_OPEN keyArgList COMMA? PAREN_CLOSE block*
     | CLASSNAME PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
     | CLASSNAME PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
     | expr DOT PAREN_OPEN PAREN_CLOSE block*
     | expr DOT PAREN_OPEN keyArgList? COMMA? PAREN_CLOSE block*
     | expr DOT name PAREN_OPEN keyArgList COMMA? PAREN_CLOSE block*
     | expr DOT PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
     | expr DOT PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
     | expr DOT name PAREN_OPEN PAREN_CLOSE block*
     | expr DOT name PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
     | expr DOT name PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
     | expr DOT name block*
     ;

block : HASH? CURLY_OPEN argDecls? varDecls? body? CURLY_CLOSE ;

body : returnExpr
     | exprSeq returnExpr?
     ;

returnExpr : CARET expr SEMICOLON? ;

exprSeq : expr (SEMICOLON expr)* SEMICOLON? ;

varDecls : (VAR varDefList SEMICOLON)+ ;

listComp : CURLY_OPEN COLON exprSeq COMMA qualifiers CURLY_CLOSE
         | CURLY_OPEN SEMICOLON exprSeq COMMA qualifiers CURLY_CLOSE
         ;

qualifiers : qualifier (COMMA qualifier)* ;

qualifier : name ARROW_LEFT exprSeq
          | name name ARROW_LEFT exprSeq
          | exprSeq
          | VAR name EQUALS exprSeq
          | COLON COLON exprSeq
          | COLON WHILE exprSeq
          ;

binopKey : binop
         | KEYWORD
         ;

binop : ARROW_LEFT
      | ASTERISK
      | EQUALS
      | GREATER_THAN
      | LESS_THAN
      | MINUS
      | PIPE
      | PLUS
      | READ_WRITE
      | BINOP
      ;

argList : exprSeq (COMMA exprSeq)* ;

keyArgList : keyArg (COMMA keyArg)* ;

keyArg : KEYWORD exprSeq ;

performArgList : (argList COMMA)? ASTERISK exprSeq ;

arrayElems : arrayElem (COMMA arrayElem)* ;

arrayElem : (exprSeq COLON)? exprSeq
          | KEYWORD exprSeq
          ;

numericSeries : exprSeq (COMMA exprSeq)? DOT_DOT exprSeq?
              | DOT_DOT exprSeq
              ;

adverb : DOT name
       | DOT integer
       | DOT PAREN_OPEN exprSeq PAREN_CLOSE
       ;

multiAssignVars : name (COMMA name)* (ELLIPSES name)? ;

pipeDefList : pipeDef (COMMA pipeDef)* ;

pipeDef : name EQUALS? literal?
        | name EQUALS? PAREN_OPEN exprSeq PAREN_CLOSE
        ;

primitive : PRIMITIVE SEMICOLON? ;

classExtension  : PLUS CLASSNAME CURLY_OPEN methodDef* CURLY_CLOSE
                ;

interpreterCode : PAREN_OPEN varDecls+ body PAREN_CLOSE
                | varDecls+ body
                | body
                ;
