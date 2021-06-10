// %option yylineno
%{
#define YYSTYPE char *
#include <stdio.h>
// #include "y.tab.h"
extern FILE* yyin;
extern int yylineno;
// extern char* yylval;
extern char* yytext;
extern int yyleng;
extern int yylex(void);
extern int yyparse(void);

int main(int argc, char ** argv) {
    printf("yacc\n");

    char filepath[] = "./add2.v";
    if ((yyin = fopen(filepath, "r")) == NULL){
        printf("Can't open file %s\n", filepath);
        return 1;
    }

    // yylex();
    // int type;
    // while (type = yylex()){
    //     printf("type = %d\t, len = %d\t, line = %d\t, value = %s\t \n", type, yyleng, yylineno, yytext);
    // }

    // printf("num_line = %d, num_col = %d, num_chars = %d \n", num_line, num_col, num_chars);
    int parse_result = yyparse();
    printf("parse_result: %d\n", parse_result);
    return parse_result;
}

int yywrap(void) {
    return 1;
}

void yyerror(const char *msg) {
	extern char *yytext;
    fprintf(stderr, "len = %d\t, line = %d\t, value = %s\t \n", yyleng, yylineno, yytext);
	fprintf(stderr, "parser error: %s, near %s\n", msg, yytext);
}
%}
// %union {
// int int_value;
// double double_value;
// }
%token ANY
%token ID
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%left  SEMICOLON POUND COMMA SPACE CRLF

%token LOGIC_TYPE ASSIGN
%token PORT_DIRECTION BIT_SLICE NUMBER_INTEGER NUMBER_WITH_BIT_LENGTH

%token AT COMMENT
%token BLOCKING_ASSIGNMENT NONBLOCKING_ASSIGNMENT
%token OPERATOR BOOLEAN COMPARE

%token MODULE ENDMODULE
%token VERILOG_BEGIN VERILOG_END
%token IF ELSE
// %token 
// %token blocking_assignment nonblocking_assignment assignment
// %token module endmodule
// %nonterm field fields table tables value values condition conditions sql_select
// %type <double_value> expression term primary_expression

// sql_insert: INSERT INTO table '('fields')' VALUES '('values')' 
// : MODULE ID POUND '(' parameter_list ')' '(' port_list ')' SEMICOLON { printf("module match \n"); }
//   port_item_type port_name { printf("port_item -> port_item_type : %s -> port_name : %s \n", $1, $2); }
%%
start: module { printf("[start] module\n"); }
;

module: 
  module_header module_body ENDMODULE { printf("[accept] module \n"); }
| /* empty */ { printf("[empty] module empty\n"); }
;

module_header:
  module_id module_parameter module_port SEMICOLON { printf("[accept] module header with parameter \n"); }
// | module_id module_port SEMICOLON { printf("[accept] module header without parameter \n"); }
// | module_id SEMICOLON { printf("[accept] module header without parameter and port \n"); }
;

module_id:
  MODULE ID { printf("[accept] module and module id : %s \n", $2); }
;

module_parameter:
  POUND LEFT_PARENTHESIS parameter_list RIGHT_PARENTHESIS
  { printf("[accept] module parameter \n"); }
;

module_port:
  LEFT_PARENTHESIS port_list RIGHT_PARENTHESIS
  { printf("[accept] module port \n"); }
;

parameter_list:
  parameter_item { printf("[accept] one parameter : %s\n", $1); }
| parameter_list COMMA parameter_item { printf("[parser] parameter_list -> parameter_item 1 : %s , parameter_item 2 : %s \n", $1, $3); }
| /* empty */ { printf("[empty] parameter_list empty\n"); }
;

parameter_item:
  ID BLOCKING_ASSIGNMENT NUMBER_INTEGER { printf("[accept] one parameter_item : %s = %s\n", $1, $3); }
;

port_list:
  port_item { printf("[accept] one port : %s\n", $1); }
| port_list COMMA port_item { printf("[parser] port_list -> port_item 1 : %s , port_item 2 : %s \n", $1, $3); }
| /* empty */ { printf("[empty] port_list empty\n"); }
;

port_item:
  PORT_DIRECTION port_name_list { printf("[accept] one port direction : %s , name : %s \n", $1, $2); }
// | /* empty */ { printf("[empty] port_item empty\n"); }
;

port_name_list:
  ID { printf("[accept] one port name : %s \n", $1); }
// | port_name_list COMMA ID { printf("[parser] port_name_list : %s , port_name_list : %s \n", $1, $3); }
;

module_body: 
  module_body comment module_body {}
| module_body logic_expression module_body {}
| ANY { printf("any : %s \n", $1); }
| /* empty */ { printf("[empty] module_body empty\n"); }
;

comment:
  COMMENT { printf("[accept] comment %s \n", $1); }
;

logic_expression:
  ASSIGN ID BLOCKING_ASSIGNMENT NUMBER_WITH_BIT_LENGTH SEMICOLON
  { printf("[accept] one logic_expression : id : %s , value : %s \n", $2, $4); }
;

%%
