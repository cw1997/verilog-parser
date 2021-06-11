#!/bin/bash

# author: cw1997 <changwei1006@gmail.com>
# repo: https://github.com/cw1997/verilog-parser
# data: 2021-06-11 02:55:25

PACKAGE='me.changwei.verilog.parser'
NAME='Verilog'
START='start'
FILE='../../../add2.v'
OUTPUT_DIRECTORY='./verilog'
SUB_DIRECTORY='/me/changwei/verilog/parser'
OUTPUT_SRC_DIRECTORY="${OUTPUT_DIRECTORY}/target/generated-sources${SUB_DIRECTORY}"
OUTPUT_BIN_DIRECTORY="${OUTPUT_DIRECTORY}/target/classes"

java org.antlr.v4.Tool -listener -visitor -long-messages ./src/${NAME}.g4 -o ${OUTPUT_SRC_DIRECTORY} -package ${PACKAGE} && \
mkdir -p ${OUTPUT_BIN_DIRECTORY} && \
javac ${OUTPUT_SRC_DIRECTORY}/*.java -d ${OUTPUT_BIN_DIRECTORY} && \
cd ${OUTPUT_BIN_DIRECTORY} && \
java org.antlr.v4.gui.TestRig ${PACKAGE}.${NAME} ${START} -gui ${FILE}
