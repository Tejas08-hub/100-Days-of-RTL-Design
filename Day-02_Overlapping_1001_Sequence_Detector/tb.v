module tb;
reg clk,reset,d_in;
wire detected;
initial clk=0;
always#5 clk=~clk;
seq_detector dut(
.clk(clk),
.reset(reset),
.d_in(d_in),
.detected(detected));
initial begin 
reset=1'b1;
d_in=0;
#10;reset=1'b0;
    d_in=1;
#10;d_in=0;
#10;d_in=0;
#10;d_in=1;
#10;d_in=0;
#10;d_in=1;
#10;d_in=0;
#10;d_in=1;
#10;d_in=0;
#10;d_in=0;
#10;d_in=1;
#10;$finish;
end
endmodule
