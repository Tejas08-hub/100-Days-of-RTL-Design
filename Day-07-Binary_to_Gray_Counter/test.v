`timescale 1ns / 1ps

module test;

parameter WIDTH = 4;

reg clk;
reg reset;
reg en;

wire [WIDTH-1:0] gray_out;

reg [WIDTH-1:0] prev_gray;
reg [WIDTH-1:0] diff;
reg first;

integer i;
integer count;

top_module #(
    .WIDTH(WIDTH)
) dut (
    .clk(clk),
    .reset(reset),
    .en(en),
    .gray_out(gray_out)
);

// Clock Generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Stimulus
initial begin
    reset = 1;
    en = 0;

    #10;
    reset = 0;
    en = 1;

    #160;

    en = 0;

    #20;

    $finish;
end

// Initialize checker
initial begin
    prev_gray = 0;
    diff = 0;
    first = 1;
end

// Display values
initial begin
    $display("--------------------------------------------");
    $display("Time\tGray\tStatus");
    $display("--------------------------------------------");
end

// Gray Code Checker
always @(posedge clk) begin

    if(reset) begin
        prev_gray <= 0;
        first <= 1;
    end
    else if(en) begin

        if(!first) begin

            diff = prev_gray ^ gray_out;
            count = 0;

            for(i=0; i<WIDTH; i=i+1)
                if(diff[i])
                    count = count + 1;

            if(count == 1)
                $display("%0t\t%b\tPASS", $time, gray_out);
            else
                $display("%0t\t%b\tFAIL (Changed Bits = %0d)", $time, gray_out, count);

        end

        prev_gray <= gray_out;
        first <= 0;

    end
end

endmodule