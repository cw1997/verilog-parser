module add2 #(
    parameter
    clock_freq_hz = 50_000_000,
    clock_ns_per_hz = 20
) (
    input  wire [ 7:0] add1,
    input  wire [ 7:0] add2,add3, add4,
    output reg  [ 8:0] result_add,
    output reg  [ 8:0] result_sub,
    output      [ 8:0] result_ori,      result_and,
    output      [ 8:0] result,
    input              clk, rst_n
);

parameter require_carry = 1;
localparam lp1 = 8'b0, lp2 = 15'hfc;
localparam
lp1 = 8'b0,
lp2 = 15'hfc,
unused = 0
;

reg [15:0] r1, r2, r3;
reg r1, r2, r3;
reg        r4;
reg [15:0] r4;

wire [31:0] w1;
wire w2, w3;
wire [31:0] w1 = 32'habcd_ef00;
wire w2 = 1, w3 = 0;
wire        w1;
wire [31:0] w2, w3;

wire [7:0] complexExpression = 1 + (2 + 3) * 4 + 6 / (7 - 8)- w2 * (2 | w3 & (w1 + 9 * (123 + (45) % 6)));

// this is comment
assign result_ori = 9'b0_1234_5678;
// assign result = add1 + add2;

always @(posedge clk or negedge rst_n) begin
    result <= add1 + add2 + add3;
    if (~rst_n) begin
        result_add <= 0;
        result_sub <= 0;
    end else begin
        result_add <= add1 + add2;
        result_sub <= add1 - add2;
    end
    
    // result 2
    if (~rst_n) begin
        result <= 9'b0;
    end else begin
        result <= 9'b0_1234_5678;
    end
end

// result_and
// always @(posedge clk or negedge rst_n) begin
//     if (~rst_n) begin
//         result_and <= 9'b0;
//     end else if (2 == 1 + 1) begin
//         // if (4 == 1+2) begin
//         //     if (3 == 6 / 2) begin
//         //         result_and <= add1 & add2;
//         //     end else begin
//         //         // pass
//         //     end
//         // end
//         result_and <= add1 & add2;
//     end else begin
//         result_and <= add1 & add2;
//     end
// end
    
endmodule
