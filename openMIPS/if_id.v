module if_id(
    input clk,
    input rst_,
    input [31:0] if_o_pc,
    input if_o_inst_vld,
    input [31:0] if_o_inst,
    output [31:0] id_i_pc,
    output id_i_inst_vld,
    output [31:0] id_i_inst
);

dr_reg #(32) pc_reg(.d(if_o_pc), .q(id_i_pc), .*);
dr_reg #(1)  inst_vld_reg(.d(if_o_inst_vld), .q(id_i_inst_vld), .*);
dr_reg #(32) inst_reg(.d(if_o_inst), .q(id_i_inst), .*);

endmodule
