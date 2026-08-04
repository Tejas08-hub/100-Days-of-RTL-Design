module top_module #(
    parameter ADDR_WIDTH = 6,   // 64 locations
    parameter DATA_WIDTH = 8
)(
    input clk,
    // Port A
    input                    wr_en_a,
    input  [ADDR_WIDTH-1:0]  addr_a,
    input  [DATA_WIDTH-1:0]  data_in_a,
    output reg [DATA_WIDTH-1:0] data_out_a,
    // Port B
    input                    wr_en_b,
    input  [ADDR_WIDTH-1:0]  addr_b,
    input  [DATA_WIDTH-1:0]  data_in_b,
    output reg [DATA_WIDTH-1:0] data_out_b
);
reg[DATA_WIDTH-1:0]mem[0:(1<<ADDR_WIDTH)-1];
always@(posedge clk)begin
   data_out_a<=mem[addr_a];
   data_out_b<=mem[addr_b];
   if(wr_en_a && wr_en_b &&(addr_a==addr_b))begin
            mem[addr_b]<=data_in_b;//port b wins
            data_out_a<=data_in_a;
            data_out_b<=data_in_b;
    end
    else begin
        if(wr_en_a)begin
           mem[addr_a]<=data_in_a;
           data_out_a<=data_in_a;
        end
        if(wr_en_b)begin
          mem[addr_b]<=data_in_b;
          data_out_b<=data_in_b;
         end
       end
    end
endmodule