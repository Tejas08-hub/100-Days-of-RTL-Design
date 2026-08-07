`timescale 1ns/1ps
module test;
reg clk;
reg reset;
wire clk_out;
time rise_time, fall_time;
time high_time, low_time;
initial clk = 0;
always #5 clk = ~clk;
top_module dut(
    .clk(clk),
    .reset(reset),
    .clk_out(clk_out)
);
initial begin
    reset = 1;
    #10 reset = 0;
    #100;
    $finish;
end
always @(posedge clk_out) begin
    low_time = $time - fall_time;
    rise_time = $time;
    if(fall_time != 0)
        $display("LOW Time = %0t ns", low_time);
end
always @(negedge clk_out) begin
    high_time = $time - rise_time;
    fall_time = $time;
    if(rise_time != 0)
        $display("HIGH Time = %0t ns", high_time);
end
endmodule