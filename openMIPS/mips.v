module mips(
    input clk,
    input rst_,

    input inst_vld,
    input [31:0] inst,
    output [31:0] pc,
    output pc_vld
);

// output
wire [31:0] if_o_pc;
wire if_o_pc_vld;
pc_reg u_pc_reg(.*);

// output
assign pc = if_o_pc;
assign pc_vld = if_o_pc_vld;

// input
wire [31:0] if_o_inst = inst;
wire if_o_inst_vld = inst_vld;

// output
wire [31:0] id_i_pc;
wire id_i_inst_vld;
wire [31:0] id_i_inst;
if_id u_if_id(.*);

// output
wire reg0_read;
wire reg1_read;
wire [4:0] reg0_addr;
wire [4:0] reg1_addr;
// output
wire [7:0] id_o_alu_op;
wire [2:0] id_o_alu_sel;
wire [31:0] id_o_reg0;
wire [31:0] id_o_reg1;
wire [4:0] id_o_waddr;
wire id_o_wreg;
id u_id(.*);

// output
wire [7:0] ex_i_alu_op;
wire [2:0] ex_i_alu_sel;
wire [31:0] ex_i_reg0;
wire [31:0] ex_i_reg1;
wire [4:0] ex_i_waddr;
wire ex_i_wreg;
id_ex u_id_ex(.*);

// output
wire ex_o_we_hilo;
wire [31:0] ex_o_wdata_hi;
wire [31:0] ex_o_wdata_lo;
wire ex_o_wreg;
wire [4:0] ex_o_waddr;
wire [31:0] ex_o_wdata;
ex u_ex(.*);

// output
wire mem_i_we_hilo;
wire [31:0] mem_i_wdata_hi;
wire [31:0] mem_i_wdata_lo;
wire [4:0] mem_i_waddr;
wire mem_i_wreg;
wire [31:0] mem_i_wdata;
ex_mem u_ex_mem(.*);

// output
wire [4:0] mem_o_waddr;
wire mem_o_wreg;
wire [31:0] mem_o_wdata;
wire mem_o_we_hilo;
wire [31:0] mem_o_wdata_hi;
wire [31:0] mem_o_wdata_lo;
mem u_mem(.*);

// output
wire wb_i_we_hilo;
wire [31:0] wb_i_wdata_hi;
wire [31:0] wb_i_wdata_lo;
wire wb_i_wreg;
wire [4:0] wb_i_waddr;
wire [31:0] wb_i_wdata;
mem_wb u_mem_wb(.*);

// output
wire wb_o_we_hilo;
wire [31:0] wb_o_wdata_hi;
wire [31:0] wb_o_wdata_lo;
wire wb_o_wreg;
wire [4:0] wb_o_waddr;
wire [31:0] wb_o_wdata;
wb u_wb(.*);

// output
wire [31:0] ex_i_rdata_hi;
wire [31:0] ex_i_rdata_lo;
wire ex_o_re_hilo;
wire [31:0] reg0_data;
wire [31:0] reg1_data;
regfile u_regfile(
    .re0(reg0_read),
    .raddr0(reg0_addr),
    .rdata0(reg0_data),
    .re1(reg1_read),
    .raddr1(reg1_addr),
    .rdata1(reg1_data),
    .we(wb_o_wreg),
    .waddr(wb_o_waddr),
    .wdata(wb_o_wdata),
    .we_hilo(wb_o_we_hilo),
    .wdata_hi(wb_o_wdata_hi),
    .wdata_lo(wb_o_wdata_lo),
    .re_hilo(ex_o_re_hilo),
    .rdata_hi(ex_i_rdata_hi),
    .rdata_lo(ex_i_rdata_lo),
    .*
);

endmodule

