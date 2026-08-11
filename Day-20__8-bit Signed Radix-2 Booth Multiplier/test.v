`timescale 1ns/1ps

module test;

reg clk;
reg reset;
reg start;
reg signed [7:0] multiplicand;
reg signed [7:0] multiplier;

wire signed [15:0] product;
wire done;
wire busy;

top_module uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .multiplicand(multiplicand),
    .multiplier(multiplier),
    .product(product),
    .done(done),
    .busy(busy)
);

always #5 clk = ~clk;

task test_case;
    input signed [7:0] m;
    input signed [7:0] q;
    reg signed [15:0] expected;
    begin
        expected = m * q;

        @(negedge clk);
        multiplicand = m;
        multiplier = q;
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);

        if(product == expected)
            $display("PASS: %0d x %0d = %0d", m, q, product);
        else
            $display("FAIL: %0d x %0d = %0d Expected = %0d",
                     m, q, product, expected);

        @(negedge clk);
    end
endtask

initial begin
    clk = 0;
    reset = 1;
    start = 0;
    multiplicand = 0;
    multiplier = 0;

    #20;
    reset = 0;

    test_case(5,3);
    test_case(5,-3);
    test_case(-5,3);
    test_case(-5,-3);

    test_case(0,25);
    test_case(25,0);
    test_case(-1,8);
    test_case(8,-1);
    test_case(-128,1);
    test_case(-128,-1);

    #20;
    $finish;
end

endmodule