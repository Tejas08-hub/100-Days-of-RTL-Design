module test;
reg clk,reset;
wire[1:0] light;
initial clk=0;
always #5 clk=~clk;
top_module dut(
.clk(clk),
.reset(reset),
.light(light));
initial begin
reset=1;
#10; reset=0;
#50; reset=1;
#60;reset=0;
#100;$finish;
end
endmodule