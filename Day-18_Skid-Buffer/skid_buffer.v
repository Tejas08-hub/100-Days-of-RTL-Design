module top_module #(
    parameter WIDTH = 8
)(
    input                   clk,
    input                   reset,     // synchronous, active high
    // upstream (sender) side
    input  [WIDTH-1:0]      in_data,
    input                   in_valid,
    output                  in_ready,
    // downstream (receiver) side
    output [WIDTH-1:0]      out_data,
    output                  out_valid,
    input                   out_ready
);
reg[WIDTH-1:0]main_data;
reg main_valid;
reg[WIDTH-1:0]skid_buff;
reg skid_buff_valid;
// Input can be accepted if:
// 1. Main slot is empty, or
// 2. Skid slot is empty, or
// 3. Current output is being consumed, freeing a slot
assign in_ready = !skid_buff_valid || !main_valid ||
                  (out_ready && out_valid);
assign out_data=main_data;
assign out_valid=main_valid;
always@(posedge clk)begin
   if(reset)begin
     main_data<=0;
     main_valid<=0;
     skid_buff<=0;
     skid_buff_valid<=0;
     end
   else begin 
        if(out_valid && out_ready) begin
    if(skid_buff_valid) begin
        main_data <= skid_buff;
        main_valid <= 1;
        skid_buff_valid <= 0;

        if(in_valid) begin
            skid_buff <= in_data;
            skid_buff_valid <= 1;
        end
    end
    else if(in_valid && in_ready) begin
        main_data <= in_data;
        main_valid <= 1;
    end
    else begin
        main_valid <= 0;
    end
end
         else begin
             if(!main_valid)begin
                  if(in_valid && in_ready)begin
                      main_data<=in_data;
                      main_valid<=1;
                     end
                   end
             else if(in_valid && in_ready)begin
                        skid_buff<=in_data;
                        skid_buff_valid<=1;
                    end
             end
        end
   end
 endmodule                  
                