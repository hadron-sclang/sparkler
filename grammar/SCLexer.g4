lexer grammar SCLexer;

// Lexer rules are in priority order, so need to define more specific tokens before more general ones.

STRING : '"' (~'"'|'\\' .)* '"' ;

SYMBOL_QUOTE : '\'' (~'\''|'\\' .)* '\'' ;
SYMBOL_SLASH : '\\' [a-zA-Z0-9_]* ;

// Comments (not to be confused with binops)
COMMENT_LINE : '//' ~('\n'|'\r')*? ('\n'|'\r') -> channel(2) ;
COMMENT_BLOCK : '/*' (COMMENT_BLOCK|.)*? '*/' -> channel(2) ;

// Reserved words
ARG : 'arg' ;
CLASSVAR : 'classvar' ;
CONST : 'const' ;
FALSE : 'false' ;
INF : 'inf' ;
PI : 'pi' ;
TRUE : 'true' ;
VAR : 'var' ;

// Not a reserved word, but still needs to be defined before NAME
WHILE : 'while' ;

CHARACTER : '$' (.|'\\'.) ;

CLASSNAME : [A-Z] [a-zA-Z0-9_]* ;

FLOAT : [0-9]+ '.' [0-9]+ ;
FLOAT_FLAT : [0-9]+ 'b'+ ;
FLOAT_FLAT_CENTS : [0-9]+ 'b' [0-9]+ ;
FLOAT_RADIX : [1-9] [0-9]* 'r' [a-zA-Z0-9]+ '.' [A-Z0-9]+ ;
FLOAT_SCI : [0-9]+ ('.' [0-9]+)? 'e' ('-' | '+')? [0-9]+ ;
FLOAT_SHARP : [0-9]+ 's'+ ;
FLOAT_SHARP_CENTS : [0-9]+ 's' [0-9]+ ;

INT : [0-9]+ ;
INT_HEX : '0x' [0-9a-f]* ;
INT_RADIX : [1-9] [0-9]* 'r' [a-zA-Z0-9]+ ;

KEYWORD : [a-z] [a-zA-Z0-9_]* ':' ;

NAME : [a-z] [a-zA-Z0-9_]* ;

PRIMITIVE : '_' [a-zA-Z0-9_]+ ;

// Valid binop constructions that also happen to be used in the language, so their definition comes before BINOP.
ARROW_LEFT : '<-' ;
ASTERISK : '*' ;
EQUALS : '=' ;
GREATER_THAN : '>' ;
LESS_THAN : '<' ;
MINUS : '-' ;
PIPE : '|' ;
PLUS : '+' ;
READ_WRITE : '<>' ;
BINOP : ('!' | '@' | '%' | '&' | '*' | '-' | '+' | '=' | '|' | '<' | '>' | '?' | '/')+ ;

// Delimiters.
CARET : '^' ;
COLON : ':' ;
COMMA : ',' ;
CURLY_OPEN : '{' ;
CURLY_CLOSE : '}' ;
HASH : '#' ;
TILDE : '~' ;
PAREN_OPEN : '(' ;
PAREN_CLOSE : ')' ;
SQUARE_OPEN : '[' ;
SQUARE_CLOSE : ']' ;
UNDERSCORE : '_' ;
SEMICOLON : ';' ;

DOT : '.' ;
DOT_DOT : '..' ;
ELLIPSES : '...' ;

WHITESPACE : [ \t\r\n]+ -> channel(HIDDEN) ;
