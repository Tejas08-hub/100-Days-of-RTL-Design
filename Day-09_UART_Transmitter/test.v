`timescale 1ns/1ps

module test;

reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

reg [7:0] rx_data;
integer i;

top dut(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 0;
    rx_data = 0;

    #20;
    reset = 0;

    #20;
    tx_data = 8'hA5;
    tx_start = 1;

    #10;
    tx_start = 0;

    @(negedge tx);

    repeat(15) @(posedge clk);

    for(i=0;i<8;i=i+1) begin
        rx_data[i] = tx;
        repeat(10) @(posedge clk);
    end

    if(tx !== 1'b1)
        $display("FAIL : Stop bit error");

    if(rx_data == 8'hA5)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");
        
    $display("Expected = %h",8'hA5);
    $display("Received = %h",rx_data);

    #50;
    $finish;
end

endmodule