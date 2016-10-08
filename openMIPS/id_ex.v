module id_ex(
    input clk,
    input rst_,
    input [7:0]  id_o_alu_op,
    input [2:0]  id_o_alu_sel,
    input [31:0] id_o_reg0,
    input [31:0] id_o_reg1,
    input [4:0]  id_o_waddr,
    input id_o_wreg,

    output reg [7:0]  ex_i_alu_op,
    output reg [2:0]  ex_i_alu_sel,
    output reg [31:0] ex_i_reg0,
    output reg [31:0] ex_i_reg1,
    output reg [4:0]  ex_i_waddr,
    output reg ex_i_wreg
);

dr_reg #(8)  alu_op_reg(.d(id_o_alu_op),  .q(ex_i_alu_op), .*);
dr_reg #(3) alu_sel_reg(.d(id_o_alu_sel), .q(ex_i_alu_sel), .*);
dr_reg #(32)   reg0_reg(.d(id_o_reg0),    .q(ex_i_reg0), .*);
dr_reg #(32)   reg1_reg(.d(id_o_reg1),    .q(ex_i_reg1), .*);
dr_reg #(5)      wd_reg(.d(id_o_waddr),   .q(ex_i_waddr), .*);
dr_reg #(1)    wreg_reg(.d(id_o_wreg),    .q(ex_i_wreg), .*);

endmodule
