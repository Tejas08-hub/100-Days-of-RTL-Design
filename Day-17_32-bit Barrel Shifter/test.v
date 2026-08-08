module test;
reg [31:0] data_in;
reg[4:0]  shift_amt; 
reg direction; 
wire[31:0] data_out;
top_module dut(
    .data_in(data_in),
    .shift_amt(shift_amt),
    .direction(direction),
    .data_out(data_out));
initial begin 
    data_in = 10;
    shift_amt = 0;
    direction = 0;
    #10;

    data_in = 1;
    shift_amt = 1;
    direction = 0;
    #10;

    data_in = 5;
    shift_amt = 2;
    direction = 0;
    #10;

    data_in = 10;
    shift_amt = 3;
    direction = 0;
    #10;

    data_in = 15;
    shift_amt = 4;
    direction = 0;
    #10;

    data_in = 32;
    shift_amt = 1;
    direction = 1;
    #10;

    data_in = 64;
    shift_amt = 2;
    direction = 1;
    #10;

    data_in = 100;
    shift_amt = 3;
    direction = 1;
    #10;

    data_in = 255;
    shift_amt = 4;
    direction = 1;
    #10;

    data_in = 1024;
    shift_amt = 5;
    direction = 0;
    #10;

    $finish;
end
endmodule