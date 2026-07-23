module tb;
reg clk;
reg reset;
reg up_down;
wire [3:0]count;
initial begin 
clk=0;
reset=1;
up_down=1;
end
always #5 clk=~clk;
top uut(
.clk(clk),
.reset(reset),
.up_down(up_down),
.count(count));
initial begin
#10;reset=0;
up_down=1'b1;
#50;up_down=0;
#100;
$finish;
end
endmodule
