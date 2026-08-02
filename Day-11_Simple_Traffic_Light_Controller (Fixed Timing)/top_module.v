module top_module(
    input        clk,
    input        reset,     // synchronous, active high
    output reg [1:0] light   // 2'b00 = Red, 2'b01 = Green, 2'b10 = Yellow
);
reg[1:0]state;
localparam red=2'b00;
localparam green=2'b01;
localparam yellow=2'b10;
reg[1:0]count;
always@(posedge clk)begin
  if(reset)begin
     state<=red;
     count<=0;
     end
  else begin
    case(state)
        green:begin
           if(count==2'b11)begin
               state<=yellow;
               count<=0;
               end
            else 
              count<=count+1'b1;
              end
         yellow:begin
           if(count==2'b01)begin
              state<=red;
              count<=0;
              end
           else 
           count<=count+1'b1;
           end
          red:begin
           if(count==2'b11)begin
              state<=green;
              count<=0;
              end
              else 
               count<=count+1'b1;
              end
              default:begin
                 state<=red;
                 count<=0;
                 end
             endcase
           end
         end
   always@(*)begin
    case(state)
         red:light=2'b00;
         green:light=2'b01;
         yellow:light=2'b10;
         default:light=2'b00;
         endcase
         end
         endmodule
              