module top_module(
    input  clk_src,     // source domain clock
    input  rst_src,     // source domain synchronous reset
    input  pulse_in,     // single-cycle pulse in source domain

    input  clk_dst,     // destination domain clock
    input  rst_dst,     // destination domain synchronous reset
    output reg pulse_out     // single-cycle pulse in destination domain
);
reg toggle;
reg sync_1;
reg sync_2;
reg sync_d;
always@(posedge clk_src)begin
    if(rst_src)
       toggle<=0;
    else if(pulse_in)
        toggle<=~toggle;
     end
always@(posedge clk_dst)begin
     if(rst_dst)begin
        sync_1<=0;
        sync_2<=0;
        sync_d<=0;
        pulse_out<=0;
        end
    else begin
       sync_1<=toggle;
       sync_2<=sync_1;
       sync_d<=sync_2;
       pulse_out<=sync_2^sync_d;
     end
    end
 endmodule
    