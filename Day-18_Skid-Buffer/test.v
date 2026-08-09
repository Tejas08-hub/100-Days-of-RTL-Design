`timescale 1ns/1ps

module test;

reg clk;
reg reset;

reg [7:0] in_data;
reg in_valid;
wire in_ready;

wire [7:0] out_data;
wire out_valid;
reg out_ready;

top_module dut(
    .clk(clk),
    .reset(reset),
    .in_data(in_data),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .out_data(out_data),
    .out_valid(out_valid),
    .out_ready(out_ready)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin

    reset = 1;
    in_data = 0;
    in_valid = 0;
    out_ready = 0;

    #10;
    reset = 0;

    // Pass-through
    out_ready = 1;
    in_valid = 1;
    in_data = 10;

    #10;
    in_data = 20;

    #10;
    in_data = 30;

    #10;
    in_valid = 0;

    #10;

    // Receiver stalls
    in_valid = 1;
    in_data = 40;
    out_ready = 0;

    #10;
    in_data = 50;

    #10;
    in_data = 60;

    #10;

    // Receiver becomes ready
    out_ready = 1;

    #10;
    in_valid = 0;

    #30;

    $finish;
end

always @(posedge clk) begin
    $display("Time=%0t | in_valid=%b in_ready=%b in_data=%0d | out_valid=%b out_ready=%b out_data=%0d",
             $time, in_valid, in_ready, in_data,
             out_valid, out_ready, out_data);
end

endmodule