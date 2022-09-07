lexer grammar SCLexer;

ARG : 'arg' ;

ARROW_LEFT : '<-' ;

ASTERISK : '*' ;

BINOP : ('!' | '@' | '%' | '&' | '*' | '-' | '+' | '=' | '|' | '<' | '>' | '?' | '/')+ ;

CARET : '^' ;

CLASSNAME : [A-Z] [a-zA-Z0-9_]* ;

CLASSVAR : 'classvar' ;

COLON : ':' ;

COMMA : ',' ;

COMMENT_LINE : '//' .*? '\n' -> channel(2) ;
COMMENT_BLOCK : '/*' -> channel(2), pushMode(INSIDE_BLOCK) ;

CONST : 'const' ;

CURLY_OPEN : '{' ;
CURLY_CLOSE : '}' ;

DOT : '.' ;
DOT_DOT : '..' ;

ELLIPSES : '...' ;

EQUALS : '=' ;

FLOAT : [-]? [0-9]+ '.' [0-9]+ ;
FLOAT_RADIX : [-]? [1-9] [0-9]* 'r' [a-zA-Z0-9]+ '.' [A-Z0-9]+ ;
FLOAT_SCI : [-]? [0-9]+ ('.' [0-9]+)? 'e' ('-' | '+')? [0-9]+ ;

GREATER_THAN : '>' ;

HASH : '#' ;

INT : [-]? [1-9] [0-9]* ;
INT_HEX : [-]? '0x' [0-9a-f]* ;
INT_RADIX : [-]? [1-9] [0-9]* 'r' [a-zA-Z0-9]+ ;

KEYWORD : [a-z] [a-zA-Z0-9_]* ':' ;

LESS_THAN : '<' ;

MINUS : '-' ;

NAME : [a-z] [a-zA-Z0-9_]* ;

PAREN_OPEN : '(' ;
PAREN_CLOSE : ')' ;

PI : 'pi' ;

PIPE : '|' ;

PLUS : '+' ;

PRIMITIVE : '_' [a-zA-Z0-9_]* ;

READ_WRITE : '<>' ;

SEMICOLON : ';' ;

STRING : '"' (.|'\\"')*? '"' ;

SQUARE_OPEN : '[' ;
SQUARE_CLOSE : ']' ;

SYMBOL_QUOTE : '\'' (.|'\\\'')*? ;
SYMBOL_SLASH : '\\' [a-zA-Z0-9_]* ;

TILDE : '~' ;

UNDERSCORE : '_' ;

VAR : 'var' ;

WHITESPACE : [ \t\r\n]+ -> channel(HIDDEN) ;

WHILE : 'while' ;

mode INSIDE_BLOCK;
END_BLOCK : '*/' -> channel(2), popMode ;
IGNORE : . -> more ;
NEST_BLOCK : '/*' -> channel(2), pushMode(INSIDE_BLOCK) ;
