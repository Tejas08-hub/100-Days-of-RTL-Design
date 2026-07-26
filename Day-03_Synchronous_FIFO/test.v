`timescale 1ns/1ps
module fifo_tb;
parameter width = 8;
parameter depth = 8;
reg clk;
reg reset;
reg wr_en;
reg rd_en;
reg [width-1:0] d_in;
wire [width-1:0] d_out;
wire full;
wire empty;
integer i;
fifo #(
    .width(width),
    .depth(depth)
) dut (
    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .d_in(d_in),
    .rd_en(rd_en),
    .d_out(d_out),
    .full(full),
    .empty(empty)
);
always #5 clk = ~clk;
initial begin
    clk = 0;
    reset = 1;
    wr_en = 0;
    rd_en = 0;
    d_in = 0;
    #20;
    reset = 0;
    $display("------ WRITE OPERATION ------");
    for(i=1; i<=depth; i=i+1)
    begin
        @(negedge clk);
        wr_en = 1;
        d_in = i;
        @(posedge clk);
        $display("[%0t] Write Data = %0d", $time, d_in);
    end
    @(negedge clk);
    wr_en = 0;
    #20;
    $display("------ READ OPERATION ------");
    for(i=1; i<=depth; i=i+1)
    begin
        @(negedge clk);
        rd_en = 1;
        @(posedge clk);
        #1;
        $display("[%0t] Read Data = %0d", $time, d_out);
    end
    @(negedge clk);
    rd_en = 0;
    #20;
    $finish;
end
initial begin
    $monitor("Time=%0t | d_in=%0d | d_out=%0d | wr_ptr=%b | rd_ptr=%b | full=%b | empty=%b",
             $time,
             d_in,
             d_out,
             dut.wr_ptr,
             dut.rd_ptr,
             full,
             empty);
end
endmodule