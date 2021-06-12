grammar Verilog;

//@header{package me.changwei.verilog.parser;}

options {
}

// grammer
start: moduleHeader moduleBody moduleFooter EOF;

moduleHeader: MODULE ID parameterBlock? portBlock? SEMICOLON;

//#(parameterList?)
parameterBlock: POUND PARENTHESIS_LEFT parameterList? PARENTHESIS_RIGHT;
//parameter netName1 = 123, netName2 = 7'd456
parameterList: PARAMETER parameterItem (COMMA parameterItem)*;
parameterItem: parameterName (EQUAL NUMBER_INTEGER)?;
parameterName: ID;

//(portList)
portBlock: PARENTHESIS_LEFT portList PARENTHESIS_RIGHT;
//input i1, i2
portList: portItem (COMMA portItem)*;
//output wire [3:0] o1, o2,
portItem: PORT_DIRECTION netType? bitRange? portNameList;
//o3, o4,
portNameList: portName (COMMA portName)*;
portName: ID;

moduleBody:
( assign
| paramList
| wireList
| regList
| always
)*
;

moduleFooter: ENDMODULE;

//========================================

variable: NUMBER_INTEGER|ID;
lValue: ID;
rValue: OPERATOR_UNARY?variable;

//assign wire1 = 8'b1234_5678;
assign: ASSIGN lValue EQUAL rValue SEMICOLON;

//localparam netName1 = 123, netName2 = 7'd456;
paramList: (localparamList|parameterList) SEMICOLON;
localparamList: LOCALPARAM localparamItem (COMMA localparamItem)*;
localparamItem: lValue EQUAL NUMBER_INTEGER;

//wire [7:0] netName = 123;
//wire [7:0] netName1 = 123, netName2 = 7'd456;
//wire netName = 123;
//wire netName1 = 123, netName2 = 7'd456;
wireList: netType bitRange? wireItem (COMMA wireItem)* SEMICOLON;
wireItem: lValue EQUAL rValue;
//reg [7:0] netName = 123;
//reg [7:0] netName1 = 123, netName2 = 7'd456;
//reg       netName = 123;
//reg       netName1 = 123, netName2 = 7'd456;
regList: netType bitRange? regItem (COMMA regItem)* SEMICOLON;
regItem: lValue;

//always @(eventList|*) begin alwaysBody* end;
always: ALWAYS AT PARENTHESIS_LEFT (eventList|eventAny)? PARENTHESIS_RIGHT BEGIN alwaysBody* END;

eventAny: STAR;
//posedge clk or negedge rst_n
eventList: eventItem (OPERATOR_BOOLEAN_TEXT eventItem)*;
//posedge clk
eventItem: EDGE lValue;

alwaysBody: statement|conditionBlock;

statement: lValue assignment expression SEMICOLON;
expression: rValue (operator rValue)*;

conditionBlock: IF condition codeBlock
| conditionBlock ELSE conditionBlock
| conditionBlock ELSE codeBlock
;

condition: PARENTHESIS_LEFT expression PARENTHESIS_RIGHT;
codeBlock: BEGIN statement* END;

//[7:0] [:0] [7:] [:]
bitRange: BRACKET_LEFT NUMBER_INTEGER? COLON NUMBER_INTEGER? BRACKET_RIGHT;

assignment: EQUAL|LESS_THAN_EQUAL;
netType: WIRE|REG;
operator: OPERATOR_BOOLEAN_TEXT|OPERATOR_BOOLEAN_SYMBOL_SINGLE|OPERATOR_BOOLEAN_SYMBOL_DOUBLE|OPERATOR_ARITHMETIC;

// lexer

SPACE: [ \t]+ -> skip;
BREAK_LINE: [\r\n]+ -> skip;
COMMENT: '//' .*? ('\r'? '\n' | EOF) -> skip;

PARENTHESIS_LEFT: '(';
PARENTHESIS_RIGHT: ')';

BRACKET_LEFT: '[';
BRACKET_RIGHT: ']';

PORT_DIRECTION: 'input'|'output'|'inout';
EDGE: 'posedge'|'negedge';

COMMA: ',';
SEMICOLON: ';';
COLON: ':';
POUND: '#';
STAR: '*';

MODULE: 'module';
ENDMODULE: 'endmodule';

PARAMETER: 'parameter';
LOCALPARAM: 'localparam';

ASSIGN: 'assign';

ALWAYS: 'always';
AT: '@';

BEGIN: 'begin';
END: 'end';

IF: 'if';
ELSE: 'else';

EQUAL: '=';
LESS_THAN_EQUAL: '<=';

WIRE: 'wire';
REG: 'reg';

OPERATOR_BOOLEAN_TEXT: 'and'|'or'|'xor'|'not';
OPERATOR_BOOLEAN_SYMBOL_SINGLE: '&'|'|'|'^';
OPERATOR_BOOLEAN_SYMBOL_DOUBLE: '&&'|'||'|'^^';
OPERATOR_ARITHMETIC: '+'|'-'|'*'|'/';
OPERATOR_UNARY: '~'|'!';

fragment UNDERLINE: '_';
fragment LETTER: [a-zA-Z];
fragment DIGIT_HEX_WITHOUT_ZERO: [1-9a-fA-F];
fragment DIGIT_HEX: ('0'|DIGIT_HEX_WITHOUT_ZERO);
fragment DIGIT_DEC_WITHOUT_ZERO: [1-9];
fragment DIGIT_DEC: ('0'|DIGIT_DEC_WITHOUT_ZERO);
fragment DIGIT_OCT_WITHOUT_ZERO: [1-7];
fragment DIGIT_OCT: ('0'|DIGIT_HEX_WITHOUT_ZERO);
fragment DIGIT_BIN_WITHOUT_ZERO: [1];
fragment DIGIT_BIN: ('0'|DIGIT_HEX_WITHOUT_ZERO);

// allow: a123, _a123, _123, disallow: 0123, 123, 123_, 1a
ID: (LETTER|UNDERLINE)(LETTER|UNDERLINE|DIGIT_DEC)*;

// allow: 123, disallow: 0123
// NUMBER_DEC_INTEGER_WITHOUT_BIT_LEADER: (DIGIT_DEC_WITHOUT_ZERO)(DIGIT_DEC)*; 
fragment NUMBER_HEX_INTEGER_WITHOUT_BIT_LEADER: ((DIGIT_HEX+UNDERLINE*DIGIT_HEX+)|DIGIT_HEX)+;
fragment NUMBER_DEC_INTEGER_WITHOUT_BIT_LEADER: ((DIGIT_DEC+UNDERLINE*DIGIT_DEC+)|DIGIT_DEC)+;
fragment NUMBER_OCT_INTEGER_WITHOUT_BIT_LEADER: ((DIGIT_OCT+UNDERLINE*DIGIT_OCT+)|DIGIT_OCT)+;
fragment NUMBER_BIN_INTEGER_WITHOUT_BIT_LEADER: ((DIGIT_BIN+UNDERLINE*DIGIT_BIN+)|DIGIT_BIN)+;

fragment NUMBER_INTEGER_WITHOUT_BIT_LEADER: (NUMBER_HEX_INTEGER_WITHOUT_BIT_LEADER|NUMBER_DEC_INTEGER_WITHOUT_BIT_LEADER|NUMBER_OCT_INTEGER_WITHOUT_BIT_LEADER|NUMBER_BIN_INTEGER_WITHOUT_BIT_LEADER);

fragment NUMBER_HEX_INTEGER_WITH_BIT_LEADER: NUMBER_HEX_INTEGER_WITHOUT_BIT_LEADER'\''[Hh]NUMBER_HEX_INTEGER_WITHOUT_BIT_LEADER;
fragment NUMBER_DEC_INTEGER_WITH_BIT_LEADER: NUMBER_DEC_INTEGER_WITHOUT_BIT_LEADER'\''[Dd]NUMBER_DEC_INTEGER_WITHOUT_BIT_LEADER;
fragment NUMBER_OCT_INTEGER_WITH_BIT_LEADER: NUMBER_OCT_INTEGER_WITHOUT_BIT_LEADER'\''[Oo]NUMBER_OCT_INTEGER_WITHOUT_BIT_LEADER;
fragment NUMBER_BIN_INTEGER_WITH_BIT_LEADER: NUMBER_BIN_INTEGER_WITHOUT_BIT_LEADER'\''[Bb]NUMBER_BIN_INTEGER_WITHOUT_BIT_LEADER;

fragment NUMBER_INTEGER_WITH_BIT_LEADER: (NUMBER_HEX_INTEGER_WITH_BIT_LEADER|NUMBER_DEC_INTEGER_WITH_BIT_LEADER|NUMBER_OCT_INTEGER_WITH_BIT_LEADER|NUMBER_BIN_INTEGER_WITH_BIT_LEADER);

NUMBER_INTEGER: NUMBER_INTEGER_WITH_BIT_LEADER|NUMBER_INTEGER_WITHOUT_BIT_LEADER;
