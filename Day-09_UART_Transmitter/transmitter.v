`timescale 1ns/1ps
module top_module(
    input        clk,
    input        reset,       // synchronous, active high
    input        baud_tick,
    input        tx_start,    // pulse high for 1 cycle to begin a transmission
    input  [7:0] tx_data,     // byte to send
    output reg   tx,          // serial output line, idles HIGH
    output reg    tx_busy      // high while a transmission is in progress
);
reg[7:0]shift_register;
reg[2:0]index;
reg[1:0]state;
localparam idle_state=2'b00;
localparam start_state=2'b01;
localparam data_state=2'b10;
localparam stop_state=2'b11;
always@(posedge clk)begin
  if(reset)begin
     shift_register<=0;
     tx<=1;
     tx_busy<=0;
     index<=0;
     state<=idle_state;
   end
   else begin
     case(state)
        idle_state:begin
          tx<=1;
          tx_busy<=0;
          if(tx_start)begin
             index<=0;
             shift_register<=tx_data;
             tx_busy<=1;
             state<=start_state;
            end
           end
          start_state: begin
    tx <= 0;
    tx_busy <= 1;
    if(baud_tick) begin
        tx <= shift_register[0];
        shift_register <= shift_register >> 1;
        index <= 1;
        state <= data_state;
    end
end
           data_state: begin
    tx_busy <= 1;
    if(baud_tick) begin
        if(index == 3'd8) begin
            state <= stop_state;
            tx <= 1;
        end
        else begin
            tx <= shift_register[0];
            shift_register <= shift_register >> 1;
            index <= index + 1'b1;
        end
    end
end
              stop_state:begin
                tx<=1;
                tx_busy<=1;
                if(baud_tick)begin
                  state<=idle_state;
                  tx_busy<=0;
                end
            end
            default:begin
               state<=idle_state;
              end
         endcase
       end
      end
   endmodule    
                                  