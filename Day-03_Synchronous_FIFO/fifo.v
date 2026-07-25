module fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 8
)(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [WIDTH-1:0] d_in,
    output reg [WIDTH-1:0] d_out,
    output full,
    output empty
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [ADDR_WIDTH:0] wr_ptr;
reg [ADDR_WIDTH:0] rd_ptr;

// Write Logic
always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
    end
    else if (wr_en && (!full || rd_en)) begin
        mem[wr_ptr[ADDR_WIDTH-1:0]] <= d_in;
        wr_ptr <= wr_ptr + 1;
    end
end

// Read Logic
always @(posedge clk) begin
    if (rst) begin
        rd_ptr <= 0;
        d_out <= 0;
    end
    else if (rd_en && (!empty || wr_en)) begin
        d_out <= mem[rd_ptr[ADDR_WIDTH-1:0]];
        rd_ptr <= rd_ptr + 1;
    end
end

// Status Flags
assign empty = (wr_ptr == rd_ptr);

assign full =
    ({~wr_ptr[ADDR_WIDTH], wr_ptr[ADDR_WIDTH-1:0]} == rd_ptr);

endmodule