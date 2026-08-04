module test;
parameter ADDR_WIDTH = 6;
parameter DATA_WIDTH = 8;
reg clk;
reg wr_en_a;
reg [ADDR_WIDTH-1:0] addr_a;
reg [DATA_WIDTH-1:0] data_in_a;
wire [DATA_WIDTH-1:0] data_out_a;
reg wr_en_b;
reg [ADDR_WIDTH-1:0] addr_b;
reg [DATA_WIDTH-1:0] data_in_b;
wire [DATA_WIDTH-1:0] data_out_b;
top_module #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) dut (
    .clk(clk),
    .wr_en_a(wr_en_a),
    .addr_a(addr_a),
    .data_in_a(data_in_a),
    .data_out_a(data_out_a),
    .wr_en_b(wr_en_b),
    .addr_b(addr_b),
    .data_in_b(data_in_b),
    .data_out_b(data_out_b)
);
initial
    clk = 0;
always #5 clk = ~clk;
initial begin
    wr_en_a = 0;
    wr_en_b = 0;
    addr_a = 0;
    addr_b = 0;
    data_in_a = 0;
    data_in_b = 0;
    #10;
    wr_en_a = 1;
    addr_a = 6'd5;
    data_in_a = 8'hAA;
    #10;
    wr_en_a = 0;
    addr_a = 6'd5;
    #10;
    wr_en_a = 1;
    addr_a = 6'd10;
    data_in_a = 8'h55;
    wr_en_b = 0;
    addr_b = 6'd10;
    #10;
    wr_en_a = 0;
    #10;
    wr_en_a = 1;
    addr_a = 6'd15;
    data_in_a = 8'h11;
    wr_en_b = 1;
    addr_b = 6'd20;
    data_in_b = 8'h22;
    #10;
    wr_en_a = 0;
    wr_en_b = 0;
    #10;
    wr_en_a = 1;
    addr_a = 6'd30;
    data_in_a = 8'hAA;
    wr_en_b = 1;
    addr_b = 6'd30;
    data_in_b = 8'hBB;
    #10;
    wr_en_a = 0;
    wr_en_b = 0;
    #10;
    addr_a = 6'd5;
    addr_b = 6'd10;
    #10;
    addr_a = 6'd15;
    addr_b = 6'd20;
    #10;
    addr_a = 6'd30;
    addr_b = 6'd30;
   #10;
wr_en_a = 1;
addr_a = 6'd40;
data_in_a = 8'h5A;
wr_en_b = 0;
addr_b = 6'd40;
#10;
wr_en_a = 0;
#10;
addr_a = 6'd40;
addr_b = 6'd40;
#10; $finish;
end
endmodule