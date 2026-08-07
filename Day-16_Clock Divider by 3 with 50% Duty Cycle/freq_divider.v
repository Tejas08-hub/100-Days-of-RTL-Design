`timescale 1ns/1ps
module top_module(
    input  clk,
    input  reset,       // synchronous, active high (synchronous to clk_in's posedge domain)
    output clk_out
);
reg[1:0]counter1;
reg[1:0]counter2;
always@(posedge clk)begin
   if(reset)
      counter1<=0;
   else if(counter1==2'b10)
       counter1<=0;
   else 
      counter1<=counter1+1'b1;
  end
always@(negedge clk)begin
   if(reset)
      counter2<=0;
   else if(counter2==2'b10)
        counter2<=0;
   else 
        counter2<=counter2+1'b1;
   end
assign clk_out=((counter1==2'b10) | (counter2==2'b10));
endmodule