module test;
reg [7:0]in;
wire [2:0]pos;
wire valid;
top_module dut(
.in(in),
.pos(pos),
.valid(valid));
initial begin 
in=8'b01001000;
#10;in=8'b00100000;
#10;in=8'b00010000;
#10;in=8'b00001000;
#10;in=8'b00000000;
#10;in=8'b00100010;
#10;in=8'b00100010;
#10;in=8'b01100000;
#10;in=8'b10100001;
#10;$finish;
end
endmodule