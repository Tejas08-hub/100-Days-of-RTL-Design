module test;
reg clk,reset;
reg[3:0]req;
wire[3:0]grant;
top_module dut(
.clk(clk),
.reset(reset),
.req(req),
.grant(grant));
initial clk=0;
always #5 clk=~clk;
initial begin
reset=1;req=4'b0000;
#10;reset=0;req=4'b0001;
#10; req=4'b0010;
#10; req=4'b0100;
#10; req=4'b1000;
#10; req=4'b1010;
#10; req=4'b1110;
#10; req=4'b0111;
#10; req=4'b1010;
#10; req=4'b0011;
#10;$finish;
end
endmodule