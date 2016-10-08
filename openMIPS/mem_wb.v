module mem_wb(
    input clk,
    input rst_, 

    input [4:0] mem_o_waddr,
    input mem_o_wreg,
    input [31:0] mem_o_wdata,

    input mem_o_we_hilo,
    input [31:0] mem_o_wdata_hi,
    input [31:0] mem_o_wdata_lo,

    output reg [4:0] wb_i_waddr,
    output reg wb_i_wreg,
    output reg [31:0] wb_i_wdata,

    output reg wb_i_we_hilo,
    output reg [31:0] wb_i_wdata_hi,
    output reg [31:0] wb_i_wdata_lo
);

dr_reg #(5) wd_reg    (.d(mem_o_waddr), .q(wb_i_waddr), .*);
dr_reg #(1) wreg_reg  (.d(mem_o_wreg), .q(wb_i_wreg), .*);
dr_reg #(32) wdata_reg(.d(mem_o_wdata), .q(wb_i_wdata), .*);

dr_reg #(1) we_hi_reg     (.d(mem_o_we_hilo), .q(wb_i_we_hilo), .*);
dr_reg #(32) wdata_hi_reg (.d(mem_o_wdata_hi), .q(wb_i_wdata_hi), .*);
dr_reg #(32) wdata_lo_reg (.d(mem_o_wdata_lo), .q(wb_i_wdata_lo), .*);

endmodule
