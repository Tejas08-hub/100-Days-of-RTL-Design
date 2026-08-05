module test;
reg clk;
reg enable;
wire naive_clk_out;
wire gated_clk;
initial clk=0;
always #5 clk=~clk;
top_module dut1(
   .clk(clk),
   .enable(enable),
   .gated_clk(gated_clk));
naive_clock_gate dut2(
   .clk(clk),
   .enable(enable),
   .naive_clk_out(naive_clk_out));
initial begin
    enable = 0;
    #7  enable = 1;
    #4  enable = 0;
    
    #10 enable = 1;
    #8  enable = 0;
    
    #7  enable = 1;
    #3  enable = 0;

    #12 enable = 1;
    #9  enable = 0;

    #20 $finish;
end
endmodule