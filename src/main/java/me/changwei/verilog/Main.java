package me.changwei.verilog;

import me.changwei.verilog.parser.VerilogLexer;
import me.changwei.verilog.parser.VerilogParser;

import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

public class Main {
    public static void main(String[] args) throws Exception {
        System.out.println("cw1997");

        String fileName = "add2.v";

        CharStream charStream = CharStreams.fromFileName(fileName);
        VerilogLexer lexer = new VerilogLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        VerilogParser parser = new VerilogParser(tokenStream);

        ParseTreeWalker parserWalk = new ParseTreeWalker();
        parserWalk.walk(new MyListener(),parser.start());
    }
}
