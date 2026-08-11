`timescale 1ns/1ps
module top_module(
    input               clk,
    input               reset,      // synchronous, active high
    input               start,       // pulse high for 1 cycle to begin
    input  signed [7:0]  multiplicand,
    input  signed [7:0]  multiplier,
    output reg signed [15:0] product,
    output  reg             done ,       // high for 1 cycle when product is valid
    output reg busy
);
reg[2:0]count;
reg signed [8:0]M;
reg signed [8:0]A;
reg[7:0]Q;
reg Q_1;
reg signed [8:0] next_A;
reg signed [17:0] combined;
reg[1:0]state;
localparam IDLE=2'b00;
localparam RUN=2'b01;
localparam DONE=2'b10;
always@(posedge clk)begin
  if(reset)begin
     state<=IDLE;
     count<=0;
     M<=0;
     Q<=0;
     Q_1<=0;
     A<=0;
     product<=0;
     done<=0;
     busy<=0;
     end
  else begin 
       case(state)
          IDLE:begin
            done<=0;
            busy<=0;
            if(start)begin
               M<={multiplicand[7],multiplicand};
               A<=0;
               Q<=multiplier;
               Q_1<=0;
               count<=0;
               busy<=1;
               state<=RUN;
            end
          end
          RUN:begin
             busy<=1;
             done<=0;
             if({Q[0],Q_1}==2'b01)
                next_A=A+M;
             else if({Q[0],Q_1}==2'b10)
                next_A=A-M;
             else 
                next_A=A;
             combined = {next_A,Q,Q_1};
             combined = combined >>> 1;
             A<=combined[17:9];
             Q<=combined[8:1];
             Q_1<=combined[0];
             if(count==3'b111)begin
                 state<=DONE;
                 product<=combined[16:1];
                 count<=0;
                 end
             else 
               count<=count+1'b1;
               end
             DONE: begin
                busy  <= 0;
                done  <= 1;
                state <= IDLE;
            end

        endcase
    end
end
endmodule
                
           
        