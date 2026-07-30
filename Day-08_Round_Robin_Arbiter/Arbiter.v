module top_module(
    input        clk,
    input        reset,     // synchronous, active high
    input  [3:0] req,       // one bit per requester, 1 = requesting
    output reg [3:0] grant   // one-hot: at most one bit set per cycle
);
reg[2:0]state;
localparam no_win=3'b000;
localparam req_zero=3'b001;
localparam req_one=3'b010;
localparam req_two=3'b011;
localparam req_three=3'b100;
always@(posedge clk)begin
if(reset)begin
state<=no_win;
grant<=4'b0000;
end
else begin
   case(state)
      no_win:begin
   if(req[0]==1)begin
     state<=req_zero;
     grant<=4'b0001;
   end
   else if(req[1]==1)begin
      state<=req_one;
      grant<=4'b0010;
    end
    else if(req[2]==1)begin
       state<=req_two;
       grant<=4'b0100;
    end
    else if(req[3]==1)begin
        state<=req_three;
        grant<=4'b1000;
    end
    else
     grant<=4'b0000;
   end
   req_zero:begin
   if(req[1]==1)begin
     state<=req_one;
     grant<=4'b0010;
   end
   else if(req[2]==1)begin
      state<=req_two;
      grant<=4'b0100;
    end
    else if(req[3]==1)begin
       state<=req_three;
       grant<=4'b1000;
    end
    else if(req[0]==1)begin
        state<=req_zero;
        grant<=4'b0001;
    end
    else
     grant<=4'b0000;
   end
   req_one:begin
   if(req[2]==1)begin
     state<=req_two;
     grant<=4'b0100;
   end
   else if(req[3]==1)begin
      state<=req_three;
      grant<=4'b1000;
    end
    else if(req[0]==1)begin
       state<=req_zero;
       grant<=4'b0001;
    end
    else if(req[1]==1)begin
        state<=req_one;
        grant<=4'b0010;
    end
    else
     grant<=4'b0000;
   end
      req_two:begin
   if(req[3]==1)begin
     state<=req_three;
     grant<=4'b1000;
   end
   else if(req[0]==1)begin
      state<=req_zero;
      grant<=4'b0001;
    end
    else if(req[1]==1)begin
       state<=req_one;
       grant<=4'b0010;
    end
    else if(req[2]==1)begin
        state<=req_two;
        grant<=4'b0100;
    end
    else
     grant<=4'b0000;
   end 
   req_three:begin
   if(req[0]==1)begin
     state<=req_zero;
     grant<=4'b0001;
   end
   else if(req[1]==1)begin
      state<=req_one;
      grant<=4'b0010;
    end
    else if(req[2]==1)begin
       state<=req_two;
       grant<=4'b0100;
    end
    else if(req[3]==1)begin
        state<=req_three;
        grant<=4'b1000;
    end
       else
     grant<=4'b0000;
     end
     default:begin
       state<=no_win;
       grant<=4'b0000;
      end
    endcase
   end
  end
endmodule
      
      

