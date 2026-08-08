module top_module(
    input  [31:0] data_in,
    input  [4:0]  shift_amt,   // 0 to 31
    input         direction,    // 0 = left, 1 = right
    output [31:0] data_out
);
wire[31:0]stage1;
wire[31:0]stage2;
wire[31:0]stage3;
wire[31:0]stage4;
wire[31:0]stage5;
assign stage1=(shift_amt[0]?(direction?data_in>>1:data_in<<1):data_in);
assign stage2=(shift_amt[1]?(direction?stage1>>2:stage1<<2):stage1);
assign stage3=(shift_amt[2]?(direction?stage2>>4:stage2<<4):stage2);
assign stage4=(shift_amt[3]?(direction?stage3>>8:stage3<<8):stage3);
assign stage5=(shift_amt[4]?(direction?stage4>>16:stage4<<16):stage4);
assign data_out=stage5;
endmodule