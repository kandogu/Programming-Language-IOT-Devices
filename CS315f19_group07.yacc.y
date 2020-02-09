/* souffle.y */
%token GO STOP 
%token READ_TEMP READ_HUM READ_AIR_PRESS READ_AIR_QUALITY READ_LIGHT READ_SOUND_LEVEL SEND RECEIVE TURN_ON_SWITCH TURN_OFF_SWITCH CONNECT 
%token STRING INTEGER DOUBLE BOOLEAN CONN TIME URL VOID
%token LOOP FROM TO BY UNTIL 
%token PRINT SCAN
%token IF ELIF ELSE 
%token RETURN 
%token PLUS_SIGN MINUS_SIGN DIV_SIGN MOD_SIGN MULT_SIGN
%token INCREMENT_OP DECREMENT_OP 
%token OR AND 
%token ASSIGMENT_OP 
%token EQUAL_COMP LESS_COMP GREATER_COMP LESS_EQUAL_COMP GREATER_EQUAL_COMP NON_EQUAL_COMP 
%token SEMICOLON DOT COMMA NL 
%token END_BLOCK_COMMENT BLOCK_COMMENT SINGLE_COMMENT 
%token LEFT_SQ_BRAC RIGHT_SQ_BRAC LEFT_CR_BRAC RIGHT_CR_BRAC LEFT_PARAN RIGHT_PARAN 
%token STRING_CONST IDENTIFIER INTEGER_CONST DOUBLE_CONST TRUE FALSE URL_CONST
%%


program: main {printf("Input program is valid \n"); return 0;}
       | function_list  main {printf("Input program is valid \n"); return 0;}
       ;

function_list: function_declaration
             | function_list function_declaration
             ;

main:  GO LEFT_CR_BRAC statements RIGHT_CR_BRAC STOP SEMICOLON; 

statements: statement
          | statement statements
;

statement: matched
         | unmatched
;

matched_list: matched_list matched
            | matched
;

matched: IF LEFT_PARAN logic_expr RIGHT_PARAN matched  ELSE matched 
       | IF LEFT_PARAN logic_expr RIGHT_PARAN LEFT_CR_BRAC matched_list RIGHT_CR_BRAC ELSE matched
       | IF LEFT_PARAN logic_expr RIGHT_PARAN LEFT_CR_BRAC matched_list RIGHT_CR_BRAC ELSE LEFT_CR_BRAC matched_list RIGHT_CR_BRAC
       | IF LEFT_PARAN logic_expr RIGHT_PARAN matched  ELSE LEFT_CR_BRAC matched_list RIGHT_CR_BRAC
       | non_if_statements
;

unmatched_list: unmatched_list unmatched
              | unmatched
;

unmatched: IF LEFT_PARAN logic_expr RIGHT_PARAN  statement
         | IF LEFT_PARAN logic_expr RIGHT_PARAN  matched  ELSE  unmatched
         | IF LEFT_PARAN logic_expr RIGHT_PARAN  LEFT_CR_BRAC matched_list RIGHT_CR_BRAC  ELSE  unmatched
         | IF LEFT_PARAN logic_expr RIGHT_PARAN  LEFT_CR_BRAC unmatched_list RIGHT_CR_BRAC  ELSE  statement
         | IF LEFT_PARAN logic_expr RIGHT_PARAN  LEFT_CR_BRAC unmatched_list RIGHT_CR_BRAC  ELSE  LEFT_CR_BRAC unmatched_list RIGHT_CR_BRAC
         | IF LEFT_PARAN logic_expr RIGHT_PARAN  LEFT_CR_BRAC matched_list RIGHT_CR_BRAC  ELSE  LEFT_CR_BRAC unmatched_list RIGHT_CR_BRAC
         | IF LEFT_PARAN logic_expr RIGHT_PARAN  LEFT_CR_BRAC unmatched_list RIGHT_CR_BRAC  ELSE  LEFT_CR_BRAC matched_list RIGHT_CR_BRAC 

non_if_statements: loops
                 | input SEMICOLON
                 | output SEMICOLON
                 | function_call SEMICOLON
                 | declaration SEMICOLON
                 | dec_assign SEMICOLON
                 | assignment SEMICOLON
                 | primitive_function_call SEMICOLON
                 | comment
;

loops: for_loop
     | while_loop
;

for_loop: LOOP loop_data_type IDENTIFIER FROM const_number TO const_number BY arithmetic_op const_number LEFT_CR_BRAC statements RIGHT_CR_BRAC
;

while_loop: UNTIL LEFT_PARAN logic_expr RIGHT_PARAN LEFT_CR_BRAC statements RIGHT_CR_BRAC;

function_declaration: function_header function_body;

function_header: data_type IDENTIFIER LEFT_PARAN parameter_list RIGHT_PARAN;

function_body: LEFT_CR_BRAC statements RETURN expression SEMICOLON RIGHT_CR_BRAC
             | LEFT_CR_BRAC statements RIGHT_CR_BRAC
             | LEFT_CR_BRAC RETURN expression SEMICOLON RIGHT_CR_BRAC
;

function_call: IDENTIFIER LEFT_PARAN expression_list RIGHT_PARAN
;

primitive_function_call: READ_TEMP LEFT_PARAN RIGHT_PARAN
                       | READ_HUM LEFT_PARAN RIGHT_PARAN
                       | READ_AIR_PRESS LEFT_PARAN RIGHT_PARAN
                       | READ_AIR_QUALITY LEFT_PARAN RIGHT_PARAN
                       | READ_LIGHT LEFT_PARAN RIGHT_PARAN
                       | READ_SOUND_LEVEL LEFT_PARAN RIGHT_PARAN
                       | SEND LEFT_PARAN IDENTIFIER COMMA  const_number RIGHT_PARAN
                       | SEND LEFT_PARAN IDENTIFIER COMMA IDENTIFIER RIGHT_PARAN
                       | RECEIVE LEFT_PARAN IDENTIFIER RIGHT_PARAN
                       | RECEIVE LEFT_PARAN URL_CONST RIGHT_PARAN
                       | TURN_ON_SWITCH LEFT_PARAN expression RIGHT_PARAN
                       | TURN_OFF_SWITCH LEFT_PARAN expression RIGHT_PARAN
                       | CONNECT LEFT_PARAN IDENTIFIER RIGHT_PARAN
                       | CONNECT LEFT_PARAN URL_CONST RIGHT_PARAN
                       ;

declaration: data_type identifier_list;

expression: logic_expr
          | arithmetic_expression
          | STRING_CONST
          | URL_CONST
          ;

expression_list: expression
               | expression COMMA expression_list
               | ;

arithmetic_expression: arithmetic_expression PLUS_SIGN term
                     | arithmetic_expression MINUS_SIGN term
                     | term
;


term: term MULT_SIGN factor
    | term DIV_SIGN factor
    | term MOD_SIGN factor
    | factor
;

factor: LEFT_PARAN arithmetic_expression RIGHT_PARAN
      | IDENTIFIER
      | const_number
      | function_call
      | primitive_function_call
;

identifier_list: 
               | IDENTIFIER
               | IDENTIFIER COMMA identifier_list
;

parameter_list: 
              | parameter
              | parameter_list COMMA parameter
;

parameter: data_type IDENTIFIER;

assignment: post_increment_expr
          | post_decrement_expr
          | IDENTIFIER ASSIGMENT_OP expression
;

dec_assign: data_type IDENTIFIER ASSIGMENT_OP expression;

post_increment_expr: IDENTIFIER increment_op;

post_decrement_expr: IDENTIFIER decrement_op;


data_type: INTEGER
         | DOUBLE
         | STRING
         | BOOLEAN
         | CONN
         | TIME
         | URL
         | VOID
;

loop_data_type: INTEGER
              | DOUBLE;

const_number: INTEGER_CONST
            | DOUBLE_CONST
            | negative_number
;

arithmetic_op: PLUS_SIGN
             | MINUS_SIGN
             | MULT_SIGN
             | DIV_SIGN
;

logic_expr: logic_expr logic_op comp_expr
          | logic_expr logic_op sub_logic_expr
          | comp_expr
          | sub_logic_expr
;

sub_logic_expr: LEFT_PARAN logic_expr RIGHT_PARAN
              | boolean
;

comp_expr: comp_item comp_op comp_item;

comp_item: arithmetic_expression;
         | boolean;
         | STRING_CONST
         | URL_CONST
;
logic_op: OR
        | AND
;

comp_op: EQUAL_COMP
       | NON_EQUAL_COMP
       | LESS_COMP
       | GREATER_COMP
       | LESS_EQUAL_COMP
       | GREATER_EQUAL_COMP
;

input: SCAN LEFT_PARAN IDENTIFIER RIGHT_PARAN;

output: PRINT LEFT_PARAN expression_list RIGHT_PARAN
;

negative_number: MINUS_SIGN INTEGER_CONST
               | MINUS_SIGN DOUBLE_CONST
;

boolean: TRUE
       | FALSE
;

comment: SINGLE_COMMENT 
       | BLOCK_COMMENT END_BLOCK_COMMENT
       ;

increment_op: INCREMENT_OP
;

decrement_op: DECREMENT_OP
;

%%
#include "lex.yy.c"
extern int yylineno;
main() {
  return yyparse();
}
int yyerror( char *s ) { 
  fprintf(stderr, "%s on line %d\n", s, yylineno); 
}
