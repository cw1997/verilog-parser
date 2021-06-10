#!/bin/bash

# author: cw1997 <changwei1006@gmail.com>
# repo: https://github.com/cw1997/verilog-parser
# data: 2021-06-11 02:55:25

NAME='Verilog'
START='start'
FILE='../add2.v'
OUTPUT_DIRECTORY='./output'

java org.antlr.v4.Tool ./src/${NAME}.g4 -o ${OUTPUT_DIRECTORY} && \
javac ${OUTPUT_DIRECTORY}/*.java && \
cd ${OUTPUT_DIRECTORY} && \
java org.antlr.v4.gui.TestRig ${NAME} ${START} -gui ${FILE}
