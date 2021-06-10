#!/bin/sh
clear
# lex verilog.l && gcc lex.yy.c && ./a.out;
lex verilog.l && yacc -dv verilog.y && gcc lex.yy.c y.tab.c && ./a.out;
# echo "=============================="
# echo "source file: "
# echo "=============================="
# cat test.v;