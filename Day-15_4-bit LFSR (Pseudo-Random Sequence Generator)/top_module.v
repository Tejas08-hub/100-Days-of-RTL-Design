module top_module(
    input        clk,
    input        reset,     // synchronous, active high
    output reg [3:0] lfsr_out
);
wire feedback;
always@(posedge clk)begin
   if(reset)
       lfsr_out<=4'b0001;
    else 
       lfsr_out<={lfsr_out[2:0],feedback};
    end
assign feedback=lfsr_out[3] ^ lfsr_out[2];
endmodule