`timescale 1ns/1ps
module test;
reg clk_src;
reg clk_dst;
reg rst_src;
reg rst_dst;
reg pulse_in;
wire pulse_out;
top_module dut (
    .clk_src(clk_src),
    .rst_src(rst_src),
    .pulse_in(pulse_in),
    .clk_dst(clk_dst),
    .rst_dst(rst_dst),
    .pulse_out(pulse_out)
);
initial begin
    clk_src = 0;
    forever #5 clk_src = ~clk_src;
end
initial begin
    clk_dst = 0;
    forever #20 clk_dst = ~clk_dst;
end
initial begin
    rst_src = 1;
    rst_dst = 1;
    pulse_in = 0;
    #30;
    rst_src = 0;
    rst_dst = 0;
    #25;
    pulse_in = 1;
    #10;
    pulse_in = 0;
    #80;
    pulse_in = 1;
    #10;
    pulse_in = 0;
    #80;
    pulse_in = 1;
    #10;
    pulse_in = 0;
    #150;
    $finish;
end
endmodule