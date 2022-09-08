parser grammar SCParser;

options {
  tokenVocab=SCLexer;
}

root : topLevelStatement* EOF ;

topLevelStatement : classDef
                  | classExtension
                  | interpreterCode
                  ;

classDef : CLASSNAME superclass? CURLY_OPEN classVarDecl* method* CURLY_CLOSE
         | CLASSNAME SQUARE_OPEN NAME? SQUARE_CLOSE superclass? CURLY_OPEN classVarDecl* method* CURLY_CLOSE
         ;

superclass : COLON CLASSNAME ;

classVarDecl : CLASSVAR rwSlotDefList SEMICOLON
             | VAR rwSlotDefList SEMICOLON
             | CONST constDefList SEMICOLON
             ;

rwSlotDefList : rwSlotDef (COMMA rwSlotDef)* ;

rwSlotDef : rwSpec? NAME (EQUALS literal)? ;

rwSpec : LESS_THAN
       | GREATER_THAN
       | READ_WRITE
       ;

literal : coreLiteral
        | listLiteral
        ;

coreLiteral : integer
            | float
            | strings
            | symbol
            ;

integer : INT
        | INT_HEX
        | INT_RADIX
        ;

float : floatLiteral
      | floatLiteral PI
      | integer PI
      | PI
      | MINUS PI
      ;

floatLiteral : FLOAT
             | FLOAT_RADIX
             | FLOAT_SCI
             ;

strings : STRING+ ;

symbol : SYMBOL_QUOTE
       | SYMBOL_SLASH
       ;

listLiteral : coreLiteral
            | innerListLiteral
            | innerDictLiteral
            | NAME
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

rSlotDef   : LESS_THAN? NAME
           | LESS_THAN? NAME EQUALS literal
           ;

method : ASTERISK? methodName CURLY_OPEN argDecls? varDecls? primitive? body? CURLY_CLOSE ;

methodName : NAME
           | BINOP
           ;

argDecls : ARG varDefList SEMICOLON
         | ARG varDefList? ELLIPSES NAME SEMICOLON
         | PIPE pipeDefList PIPE
         | PIPE pipeDefList? ELLIPSES NAME PIPE
         ;

varDefList : varDef (COMMA varDef)* ;

varDef : NAME
       | NAME EQUALS expr
       | NAME PAREN_OPEN exprSeq PAREN_CLOSE
       ;

expr : expr1
     | indexSeriesAssign
     | CLASSNAME
     | expr binopKey adverb? expr
     | NAME EQUALS expr
     | TILDE  NAME EQUALS expr
     | expr DOT NAME EQUALS expr
     | NAME PAREN_OPEN argList keyArgList? PAREN_CLOSE EQUALS expr
     | HASH multiAssignVars EQUALS expr
     | expr1 SQUARE_OPEN argList SQUARE_CLOSE EQUALS expr
     ;

expr1 : literal
      | block
      | listComp
      | NAME
      | UNDERSCORE
      | message
      | PAREN_OPEN exprSeq PAREN_CLOSE
      | TILDE NAME
      | SQUARE_OPEN arrayElems SQUARE_CLOSE
      | PAREN_OPEN numericSeries PAREN_CLOSE
      | PAREN_OPEN COLON numericSeries PAREN_CLOSE
      | PAREN_OPEN dictLiterals? PAREN_CLOSE
      | expr1 SQUARE_OPEN argList SQUARE_CLOSE
      | indexSeries
      ;

message : NAME block+
        | PAREN_OPEN binopKey PAREN_CLOSE block+
        | NAME PAREN_OPEN PAREN_CLOSE block+
        | NAME PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
        | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN PAREN_CLOSE block+
        | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
        | NAME PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
        | PAREN_OPEN binopKey PAREN_CLOSE PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
        | CLASSNAME SQUARE_OPEN arrayElems? SQUARE_CLOSE
        | CLASSNAME block+
        | CLASSNAME PAREN_OPEN PAREN_CLOSE block*
        | CLASSNAME PAREN_OPEN keyArgList COMMA? PAREN_CLOSE block*
        | CLASSNAME PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
        | CLASSNAME PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
        | expr DOT PAREN_OPEN PAREN_CLOSE block*
        | expr DOT PAREN_OPEN keyArgList? COMMA? PAREN_CLOSE block*
        | expr DOT NAME PAREN_OPEN keyArgList COMMA? PAREN_CLOSE block*
        | expr DOT PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
        | expr DOT PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
        | expr DOT NAME PAREN_OPEN PAREN_CLOSE block*
        | expr DOT NAME PAREN_OPEN argList keyArgList? PAREN_CLOSE block*
        | expr DOT NAME PAREN_OPEN performArgList keyArgList? PAREN_CLOSE
        | expr DOT NAME block*
        ;

indexSeries : expr1 SQUARE_OPEN argList DOT_DOT exprSeq? SQUARE_CLOSE
            | expr1 SQUARE_OPEN DOT_DOT exprSeq SQUARE_CLOSE
            ;

indexSeriesAssign : indexSeries EQUALS expr;

block : HASH? CURLY_OPEN argDecls? varDecls? body? CURLY_CLOSE ;

body : return
     | exprSeq return?
     ;

return : CARET expr SEMICOLON? ;

exprSeq : expr (SEMICOLON expr)* SEMICOLON? ;

varDecls : (VAR varDefList SEMICOLON)+ ;

listComp : CURLY_OPEN COLON exprSeq COMMA qualifiers CURLY_CLOSE
         | CURLY_OPEN SEMICOLON exprSeq COMMA qualifiers CURLY_CLOSE
         ;

qualifiers : qualifier (COMMA qualifier)* ;

qualifier : NAME ARROW_LEFT exprSeq
          | NAME NAME ARROW_LEFT exprSeq
          | exprSeq
          | VAR NAME EQUALS exprSeq
          | COLON COLON exprSeq
          | COLON WHILE exprSeq
          ;

binopKey : BINOP
         | KEYWORD
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

adverb : DOT NAME
       | DOT integer
       | DOT PAREN_OPEN exprSeq PAREN_CLOSE
       ;

multiAssignVars : NAME (COMMA NAME)* (ELLIPSES NAME)? ;

pipeDefList : pipeDef (COMMA pipeDef)* ;

pipeDef : NAME EQUALS? literal?
        | NAME EQUALS? PAREN_OPEN exprSeq PAREN_CLOSE
        ;

primitive : PRIMITIVE SEMICOLON? ;

classExtension  : PLUS CLASSNAME CURLY_OPEN method* CURLY_CLOSE
                ;

interpreterCode : PAREN_OPEN varDecls+ body PAREN_CLOSE
                | varDecls+ body
                | body
                ;
