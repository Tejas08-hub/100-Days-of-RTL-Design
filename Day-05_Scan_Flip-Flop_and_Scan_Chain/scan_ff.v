module scan_ff(
    input  clk,
    input  reset,      // synchronous, active high
    input  se,         // scan enable: 1 = scan/test mode, 0 = normal mode
    input  d_in,           // functional data input
    input  si,          // scan-in (test data input)
    output reg q
);
wire mux_out;
assign mux_out=(se ? si : d_in);
always@(posedge clk)begin
  if(reset)
    q<=0;
  else 
    q<=mux_out;
   end
 endmodule
    