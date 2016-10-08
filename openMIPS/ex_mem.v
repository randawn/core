module ex_mem(
    input clk,
    input rst_, 

    input ex_o_wreg,
    input [4:0] ex_o_waddr,
    input [31:0] ex_o_wdata,

    input ex_o_we_hilo,
    input [31:0] ex_o_wdata_hi,
    input [31:0] ex_o_wdata_lo,

    output reg [4:0] mem_i_waddr,
    output reg mem_i_wreg,
    output reg [31:0] mem_i_wdata,

    output reg mem_i_we_hilo,
    output reg [31:0] mem_i_wdata_hi,
    output reg [31:0] mem_i_wdata_lo
);

dr_reg #(1) wreg_reg  (.d(ex_o_wreg), .q(mem_i_wreg), .*);
dr_reg #(5) wd_reg    (.d(ex_o_waddr), .q(mem_i_waddr), .*);
dr_reg #(32) wdata_reg(.d(ex_o_wdata), .q(mem_i_wdata), .*);

dr_reg #(1) we_reg          (.d(ex_o_we_hilo),  .q(mem_i_we_hilo), .*);
dr_reg #(32) wdata_hi_reg   (.d(ex_o_wdata_hi), .q(mem_i_wdata_hi), .*);
dr_reg #(32) wdata_lo_reg   (.d(ex_o_wdata_lo), .q(mem_i_wdata_lo), .*);

endmodule
