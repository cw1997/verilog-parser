module add2 #(
    clock_freq_hz = 50_000_000,
    clock_ns_per_hz = 20
) (
    input  add1,
    input  add2,add3,
    output result_add,
    output result_sub,
    output result_ori,
    input  clk, 
    input  rst_n
);

// this is comment
assign result_ori = 9'b0_1234_5678;
// assign result = add1 + add2;

always @(posedge clk or negedge rst_n) begin
    result <= add1 + add2 + add3;
    if (~rst_n) begin
        result <= 9'b0;
    end else begin
        result_add <= add1 + add2;
        result_sub <= add1 - add2;
    end
end
    
endmodule
