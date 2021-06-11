package me.changwei.verilog;

import me.changwei.verilog.parser.VerilogBaseListener;
import me.changwei.verilog.parser.VerilogParser;

import java.util.List;

public class MyListener extends VerilogBaseListener {
    @Override
    public void enterModuleHeader(VerilogParser.ModuleHeaderContext ctx) {
        super.enterModuleHeader(ctx);
        String moduleName = ctx.ID().getText();
        System.out.printf("module Name: %s\n", moduleName);
    }

    @Override
    public void enterPortList(VerilogParser.PortListContext ctx) {
        super.enterPortList(ctx);
        List<VerilogParser.PortItemContext> ports = ctx.portItem();
        for (VerilogParser.PortItemContext port : ports) {
            String textDirection = port.PORT_DIRECTION().getText();
            System.out.printf("port Direction: %s ", textDirection);
            switch (textDirection) {
                case "input":
                    System.out.print("  -> ");
                    break;
                case "output":
                    System.out.print(" <- ");
                    break;
                case "inout":
                    System.out.print("<-> ");
                    break;
            }

            List<VerilogParser.PortNameContext> portNames = port.portNameList().portName();
            System.out.print("port Name: ");
            for (VerilogParser.PortNameContext portName : portNames) {
                System.out.printf("%s , ", portName.getText());
            }
            System.out.println();
        }
    }
}
