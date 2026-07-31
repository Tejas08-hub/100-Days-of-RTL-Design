`timescale 1ns/1ps
module top(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    output tx,
    output tx_busy
);
wire baud_tick;
baud_rate_generator BG (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);
top_module TX (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);
endmodule