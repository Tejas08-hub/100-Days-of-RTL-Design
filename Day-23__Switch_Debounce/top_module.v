module top_module #(
    parameter CLK_FREQ    = 50_000_000,  // 50 MHz
    parameter DEBOUNCE_MS = 10             // debounce window in ms
)(
    input  clk,
    input  reset,          // synchronous, active high
    input  switch_in,       // raw, bouncy input
    output reg switch_out    // clean, debounced output
);
localparam DEBOUNCE_CYCLES = (CLK_FREQ * DEBOUNCE_MS) / 1000;
reg sync_1;
reg sync_2;
reg[18:0]counter;
always@(posedge clk)begin
   if(reset)begin
      sync_1<=0;
      sync_2<=0;
      counter<=0;
      switch_out<=0;
      end
   else begin
       sync_1<=switch_in;
       sync_2<=sync_1;
       if(sync_2==switch_out)
          counter<=0;
       else begin
          if(counter==DEBOUNCE_CYCLES-1)begin
              switch_out<=sync_2;
              counter<=0;
              end
           else begin
            counter<=counter+1'b1;
            end
           end
         end
        end
 endmodule
          
