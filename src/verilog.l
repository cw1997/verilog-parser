%option caseless
%option yylineno
%{
#include <stdio.h>
#define YYSTYPE char *
extern YYSTYPE yylval;
#include "y.tab.h"
// #include "token.h"
// extern FILE* yyin;
extern int yylineno;
extern int yylex(void);
extern int yyparse(void);
// extern char* yylval;

int num_line = 0, num_col = 0, num_chars = 0;

%}

break_line (\r|\n|\r\n)+
space [ \t]+

comment \/\/.*{break_line}

semicolon ;
pound #
comma ,

at \@

letter [A-Za-z]
digit_without_0 [1-9]
digit [0-9]
underline _

left_parenthesis \(
right_parenthesis \)

module module
endmodule endmodule

port_direction input|output|inout

reg reg
wire wire
logic logic
logic_type {reg}|{wire}|{logic}

begin begin
end end

if if
else else

assign assign
always always
posedge posedge
negedge negedge

operator (\+)|(\-)|(\*)|(\/)
compare ==|!=|>|>=|<|<=
boolean and|(\&)|(\&\&)|or|(\|)|(\|\|)|not|(\~)|(\!)|xor|(\^)

blocking_assignment =
nonblocking_assignment <=
assignment {blocking_assignment}|{nonblocking_assignment}

string '.*'
number_integer {digit}+({digit}|{underline})*{digit}*
number_with_bit_length {digit}+\'(h|d|o|b){number_integer}

bit_slice \[{number_integer}:{number_integer}\]

id ({underline}|{letter})+({underline}|{letter}|{digit})*

%%
{semicolon} { return SEMICOLON; }
{pound} { return POUND; }
{comma} { return COMMA; }

{module} { return MODULE; }
{endmodule} { return ENDMODULE; }

{begin} { return VERILOG_BEGIN; }
{end} { return VERILOG_END; }

{if} { return IF; }
{else} { return ELSE; }

{left_parenthesis} { return LEFT_PARENTHESIS; }
{right_parenthesis} { return RIGHT_PARENTHESIS; }

{at} { return AT; }

{comment} {
    yylval = strdup(yytext);
    return COMMENT;
}

{blocking_assignment} { return BLOCKING_ASSIGNMENT; }
{nonblocking_assignment} { return NONBLOCKING_ASSIGNMENT; }

{assign} { return ASSIGN; }

{port_direction} {
    yylval = strdup(yytext);
    return PORT_DIRECTION;
}
{logic_type} {
    yylval = strdup(yytext);
    return LOGIC_TYPE;
}
{bit_slice} {
    yylval = strdup(yytext);
    return BIT_SLICE;
}
{number_integer} {
    yylval = strdup(yytext);
    return NUMBER_INTEGER;
}
{number_with_bit_length} {
    yylval = strdup(yytext);
    return NUMBER_WITH_BIT_LENGTH;
}

{operator} { return OPERATOR; }
{boolean} { return BOOLEAN; }
{compare} { return COMPARE; }

{id} {
    yylval = strdup(yytext);
    return ID; 
}

{break_line} {
    // printf("break_line: %s\n", yytext);
    ++num_line; ++num_line; ++num_chars;
    // return CRLF;
}
{space} {
    // printf("break_line: %s\n", yytext);
    ++num_col;
    // ++num_line; ++num_line; ++num_chars;
    // return SPACE;
}

. {
    // printf(".: %s\n", yytext);
    ++num_col;
    // return ANY;
};

%%

// int main(int argc, char ** argv) {
//     printf("lex\n");
//     int type;
//     char filepath[] = "./add2.v";
//     if ((yyin = fopen(filepath, "r")) == NULL){
//         printf("Can't open file %s\n", filepath);
//         return 1;
//     }
//     while (type = yylex()){
//         if (type == CRLF) continue;
//         printf("type = %d\t, len = %d\t, line = %d\t, value = %s\t \n", type, yyleng, yylineno, yytext);
//     }
//     printf("num_line = %d, num_col = %d, num_chars = %d \n", num_line, num_col, num_chars);
//     return 0;  
// }

// int yywrap() {
// 	return 1;
// }

// void yyerror(const char *msg) {
// 	extern char *yytext;
// 	fprintf(stderr, "parser error: %s, near %s\n", msg, yytext);
// }
