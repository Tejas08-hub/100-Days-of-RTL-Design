module top_module(
    input  [7:0] in,
    output reg [2:0] pos,   // bit position of the highest-priority '1'
    output valid   // 1 if any input bit is set, 0 if in == 0
);
always@(*)begin
casez(in)
8'b1???????:pos=3'b111;
8'b01??????:pos=3'b110;
8'b001?????:pos=3'b101;
8'b0001????:pos=3'b100;
8'b00001???:pos=3'b011;
8'b000001??:pos=3'b010;
8'b0000001?:pos=3'b001;
8'b00000001:pos=3'b000;
default:begin
 pos=3'b000;
end
endcase
end
assign valid=(in ? 1 : 0);
endmodule
