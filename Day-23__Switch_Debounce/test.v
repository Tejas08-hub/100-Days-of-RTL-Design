`timescale 1ms/1us

module tb;

reg clk;
reg reset;
reg switch_in;
wire switch_out;

top_module #(
    .CLK_FREQ(1000),
    .DEBOUNCE_MS(5)
) dut (
    .clk(clk),
    .reset(reset),
    .switch_in(switch_in),
    .switch_out(switch_out)
);

initial begin
    clk = 0;
    forever #0.5 clk = ~clk;
end

initial begin
    reset = 1;
    switch_in = 0;

    #3;
    reset = 0;

    #5;

    switch_in = 1;
    #1;
    switch_in = 0;
    #1;
    switch_in = 1;
    #1;
    switch_in = 0;
    #1;
    switch_in = 1;

    #8;

    switch_in = 0;
    #1;
    switch_in = 1;
    #1;
    switch_in = 0;
    #1;
    switch_in = 1;
    #1;
    switch_in = 0;

    #8;

    switch_in = 0;

    #10;

    $finish;
end
endmodule