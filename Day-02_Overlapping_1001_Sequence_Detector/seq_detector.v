module seq_detector(
input clk,
input reset,
input d_in,
output reg detected);
localparam no_match=3'b000;
localparam one_bit_match=3'b001;
localparam two_bit_match=3'b010;
localparam three_bit_match=3'b011;
localparam fourth_bit_match=3'b100;
reg[2:0]state;
always@(posedge clk)begin
if(reset)begin
  detected<=1'b0;
  state<=no_match;
end
else begin 
   case(state)
      no_match:begin
      detected<=1'b0;
        if(d_in==1)
            state<=one_bit_match;
        else 
            state<=no_match;
      end
      one_bit_match:begin
       detected<=1'b0;
         if(d_in==0)
           state<=two_bit_match;
         else
           state<=one_bit_match;
       end
       two_bit_match:begin
         detected<=1'b0;
           if(d_in==0)
             state<=three_bit_match;
           else
             state<=one_bit_match;
        end
        three_bit_match:begin
          detected<=1'b0;
            if(d_in==1)
               state<=fourth_bit_match;
            else
               state<=no_match;
        end
        fourth_bit_match:begin
          detected<=1'b1;
           if(d_in==1)
            state<=one_bit_match;
           else
            state<=no_match;
       end
       default:begin
         detected<=1'b0;
         state<=no_match;
        end
       endcase
      end
    end
endmodule

