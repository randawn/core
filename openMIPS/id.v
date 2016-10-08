module id(
    input rst_,
    input [31:0] id_i_pc,
    input id_i_inst_vld,
    input [31:0] id_i_inst,
    input [31:0] reg0_data,
    input [31:0] reg1_data,

    // forwarding
    input ex_o_wreg,
    input [4:0] ex_o_waddr,
    input [31:0] ex_o_wdata,
    input mem_o_wreg,
    input [4:0] mem_o_waddr,
    input [31:0] mem_o_wdata,

    output reg reg0_read,
    output reg reg1_read,
    output reg [4:0] reg0_addr,
    output reg [4:0] reg1_addr,

    output reg [7:0] id_o_alu_op,
    output reg [2:0] id_o_alu_sel,
    output reg [31:0] id_o_reg0,
    output reg [31:0] id_o_reg1,
    output reg [4:0] id_o_waddr,
    output reg id_o_wreg
);

// R type
wire [5:0] op = id_i_inst[31:26];
wire [4:0] rs = id_i_inst[25:21];
wire [4:0] rt = id_i_inst[20:16];
wire [4:0] rd = id_i_inst[15:11];
wire [4:0] shamt = id_i_inst[10:6];
wire [5:0] funct = id_i_inst[5:0];

wire [2:0] op_grp = op[5:3];
wire [2:0] op_idx = op[2:0];
wire [2:0] func_grp = funct[5:3];
wire [2:0] func_idx = funct[2:0];
// I type
wire [15:0] imme = id_i_inst[15:0];
// J type
wire [25:0] addr = id_i_inst[25:0];

reg inst_vld;

reg reg0_sft, reg1_sft;
reg reg0_imme_up, reg1_imme_up;
reg reg0_imme_sign, reg1_imme_sign;

assign reg0_addr = rs;
assign reg1_addr = rt;
// DECODE
always @* begin
    if (!rst_) begin
        reg0_read = 'b0;
        reg1_read = 'b0;
        reg0_sft = 'b0;
        reg1_sft = 'b0;
        reg0_imme_up = 'b0;
        reg1_imme_up = 'b0;
        reg0_imme_sign = 'b0;
        reg1_imme_sign = 'b0;

        id_o_alu_op = 'b0;
        id_o_alu_sel = 'b0;
        id_o_reg0 = 'b0;
        id_o_reg1 = 'b0;
        id_o_waddr = 'b0;
        id_o_wreg = 'b0;
    end else if(id_i_inst_vld) begin
        reg0_read = 'b0;
        reg1_read = 'b0;
        reg0_sft = 'b0;
        reg1_sft = 'b0;
        reg0_imme_up = 'b0;
        reg1_imme_up = 'b0;
        reg0_imme_sign = 'b0;
        reg1_imme_sign = 'b0;

        id_o_alu_op = 'b0;
        id_o_alu_sel = 'b0;
        id_o_reg0 = 'b0;
        id_o_reg1 = 'b0;
        id_o_waddr = 'b0;
        id_o_wreg = 'b0;

        id_o_waddr = rd;
        case (op_grp)
            `INS_OP_GRP_BASIC: begin
                case(op_idx)
                    3'b000: begin                       // R-format
                        case (func_grp)
                            `INS_FUNC_GRP_SHT: begin    // func shift
                                id_o_wreg = 'b1;        // shift register left/right by the distance indicated by immediate shamt
                                reg1_read = 'b1;        // or the register rs and put the result in register rd.
                                case (func_idx)
                                    3'b000: begin       // op *sll* shift left logical
                                        id_o_alu_op = `EXE_OP_SLL;
                                        id_o_alu_sel= `EXE_RES_SHIFT;
                                        reg0_sft = 'b1;
                                    end
                                    3'b001: begin
                                    end
                                    3'b010: begin       // op *srl* shift right logical
                                        id_o_alu_op = `EXE_OP_SRL;
                                        id_o_alu_sel= `EXE_RES_SHIFT;
                                        reg0_sft = 'b1;
                                    end
                                    3'b011: begin       // op *sra* shift right arithmetic
                                        id_o_alu_op = `EXE_OP_SRA;
                                        id_o_alu_sel= `EXE_RES_SHIFT;
                                        reg0_sft = 'b1;
                                    end
                                    3'b100: begin       // op *sllv* sll variable
                                        id_o_alu_op = `EXE_OP_SLL;
                                        id_o_alu_sel= `EXE_RES_SHIFT;
                                        reg0_read = 'b1;
                                    end
                                    3'b101: begin
                                    end
                                    3'b110: begin       // op *srlv* srl variable
                                        id_o_alu_op = `EXE_OP_SRL;
                                        id_o_alu_sel= `EXE_RES_SHIFT;
                                        reg0_read = 'b1;
                                    end
                                    3'b111: begin       // op *srav* sra variable
                                        id_o_alu_op = `EXE_OP_SRA;
                                        id_o_alu_sel= `EXE_RES_SHIFT;
                                        reg0_read = 'b1;
                                    end
                                endcase
                            end
                            `INS_FUNC_GRP_JMP: begin
                                case (func_idx)
                                    3'b000: begin       // op *jr* jump register
                                    end
                                    3'b001: begin       // op *jalr* jump and link
                                    end
                                    3'b010: begin       // op *movz* move conditional on zero
                                        id_o_alu_op = `EXE_OP_MOVZ;
                                        id_o_alu_sel= `EXE_RES_MOVE;
                                        reg0_read = 'b1;
                                        reg1_read = 'b1;
                                        id_o_wreg = reg1_data == 'b0;
                                    end
                                    3'b011: begin       // op *movn* mov on not zero
                                        id_o_alu_op = `EXE_OP_MOVN;
                                        id_o_alu_sel= `EXE_RES_MOVE;
                                        reg0_read = 'b1;
                                        reg1_read = 'b1;
                                        id_o_wreg = reg1_data != 'b0;
                                    end
                                    3'b100: begin       // op ** syscall
                                    end
                                    3'b101: begin       // op ** break
                                    end
                                    3'b110: begin
                                    end
                                    3'b111: begin       // op *sync*
                                        id_o_alu_op = `EXE_OP_NOP;
                                        id_o_alu_sel= `EXE_RES_NOP;
                                        reg1_read = 'b1;
                                    end
                                endcase
                            end
                            `INS_FUNC_GRP_HILO: begin
                                case (func_idx)
                                    3'b000: begin       // op *mfhi* move from hi register
                                        id_o_alu_op = `EXE_OP_MFHI;
                                        id_o_alu_sel= `EXE_RES_MOVE;
                                        id_o_wreg = 'b1;
                                    end
                                    3'b001: begin       // op *mthi* move to hi register
                                        id_o_alu_op = `EXE_OP_MTHI;
                                        reg0_read = 'b1;
                                    end
                                    3'b010: begin       // op *mflo* move from low register
                                        id_o_alu_op = `EXE_OP_MFLO;
                                        id_o_alu_sel= `EXE_RES_MOVE;
                                        id_o_wreg = 'b1;
                                    end
                                    3'b011: begin       // op *mtlo* move to hi register
                                        id_o_alu_op = `EXE_OP_MTLO;
                                        reg0_read = 'b1;
                                    end
                                    3'b100: begin
                                    end
                                    3'b101: begin
                                    end
                                    3'b110: begin
                                    end
                                    3'b111: begin
                                    end
                                endcase
                            end
                            `INS_FUNC_GRP_MUL: begin
                                //id_o_wreg = 'b1;
                                reg0_read = 'b1;
                                reg1_read = 'b1;
                                case (func_idx)
                                    3'b000: begin       // op *mult*
                                        id_o_alu_op = `EXE_OP_MULT;
                                        //id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                    3'b001: begin       // op *multu*
                                        id_o_alu_op = `EXE_OP_MULTU;
                                        //id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                    3'b010: begin       // op *div*
                                        id_o_alu_op = `EXE_OP_DIV;
                                        //id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                    3'b011: begin       // op *divu*
                                        id_o_alu_op = `EXE_OP_DIVU;
                                        //id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                endcase
                            end
                            `INS_FUNC_GRP_BAS: begin    // 
                                id_o_wreg = 'b1;
                                reg0_read = 'b1;
                                reg1_read = 'b1;
                                case (func_idx)
                                    3'b000: begin       // op *add*
                                        id_o_alu_op = `EXE_OP_ADD;
                                        id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                    3'b001: begin       // op *addu*
                                        id_o_alu_op = `EXE_OP_ADDU;
                                        id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                    3'b010: begin       // op *sub*
                                        id_o_alu_op = `EXE_OP_SUB;
                                        id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                    3'b011: begin       // op *subu*
                                        id_o_alu_op = `EXE_OP_SUBU;
                                        id_o_alu_sel= `EXE_RES_ARITH;
                                    end
                                    3'b100: begin       // op *and*
                                        id_o_alu_op = `EXE_OP_AND;
                                        id_o_alu_sel= `EXE_RES_LOGIC;
                                    end
                                    3'b101: begin       // op *or*
                                        id_o_alu_op = `EXE_OP_OR;
                                        id_o_alu_sel= `EXE_RES_LOGIC;
                                    end
                                    3'b110: begin       // op *xor*
                                        id_o_alu_op = `EXE_OP_XOR;
                                        id_o_alu_sel= `EXE_RES_LOGIC;
                                    end
                                    3'b111: begin       // op *nor*
                                        id_o_alu_op = `EXE_OP_NOR;
                                        id_o_alu_sel= `EXE_RES_LOGIC;
                                    end
                                endcase
                            end
                            `INS_FUNC_GRP_SET: begin
                                id_o_wreg = 'b1;
                                reg0_read = 'b1;
                                reg1_read = 'b1;
                                case (func_idx)
                                    3'b010: begin       // op *slt*
                                        id_o_alu_op = `EXE_OP_SLT;
                                    end
                                    3'b011: begin       // op *sltu*
                                        id_o_alu_op = `EXE_OP_SLTU;
                                    end
                                endcase
                            end
                        endcase
                    end
                endcase
            end
            `INS_OP_GRP_IMM: begin
                id_o_wreg = 'b1;
                id_o_waddr = rt;
                reg0_read = 'b1;
                case (op_idx)
                    3'b000: begin   // op *addi*
                        id_o_alu_op = `EXE_OP_ADDI;
                        id_o_alu_sel= `EXE_RES_ARITH;
                        reg1_imme_sign = 'b1;
                    end
                    3'b001: begin   // op *addiu*
                        id_o_alu_op = `EXE_OP_ADDIU;
                        id_o_alu_sel= `EXE_RES_ARITH;
                        reg1_imme_sign = 'b1;   // misnomer
                    end
                    3'b010: begin   // op *slti* set less than imm.
                        id_o_alu_op = `EXE_OP_SLT;
                        id_o_alu_sel= `EXE_RES_ARITH;
                        reg1_imme_sign = 'b1;
                    end
                    3'b011: begin   // op *sltiu* slti unsigned
                        id_o_alu_op = `EXE_OP_SLTU;
                        id_o_alu_sel= `EXE_RES_ARITH;
                        reg1_imme_sign = 'b1;
                    end
                    3'b100: begin   // op *andi*
                        id_o_alu_op = `EXE_OP_AND;
                        id_o_alu_sel= `EXE_RES_LOGIC;
                    end
                    3'b101: begin   // op *ori*
                        id_o_alu_op = `EXE_OP_OR;
                        id_o_alu_sel= `EXE_RES_LOGIC;
                    end
                    3'b110: begin   // op *xori*
                        id_o_alu_op = `EXE_OP_XOR;
                        id_o_alu_sel= `EXE_RES_LOGIC;
                    end
                    3'b111: begin   // op *lui* load upper imm.
                        id_o_alu_op = `EXE_OP_OR;   // PSEODU INST
                        id_o_alu_sel= `EXE_RES_LOGIC;
                        reg1_imme_up = 'b1;
                    end
                endcase
            end
            `INS_OP_GRP_TLB: begin
            end
            `INS_OP_GRP_MUL: begin
                case(op_idx)
                    3'b000: begin
                        case (func_grp)
                            3'b000: begin
                                id_o_wreg = 'b1;
                                reg0_read = 'b1;
                                reg1_read = 'b1;
                                case (func_idx)
                                    3'b000: begin   // op *madd*
                                    end
                                    3'b001: begin   // op *maddu*
                                    end
                                    3'b010: begin   // op *mul*
                                        id_o_alu_op = `EXE_OP_MUL;
                                        id_o_alu_sel = `EXE_RES_MUL;
                                    end
                                    3'b100: begin   // op *msub*
                                    end
                                    3'b101: begin   // op *msubu*
                                    end
                                endcase
                            end
                            3'b100: begin
                                id_o_wreg = 'b1;
                                reg0_read = 'b1;
                                id_o_alu_sel = `EXE_RES_ARITH;
                                case (func_idx)
                                    3'b000: begin   // op *clz* counting leading zeros
                                        id_o_alu_op = `EXE_OP_CLZ;
                                    end
                                    3'b001: begin   // op *clo* counting leading ones
                                        id_o_alu_op = `EXE_OP_CLO;
                                    end
                                endcase
                            end
                        endcase
                    end
                endcase
            end
            `INS_OP_GRP_LOAD: begin
            end
            `INS_OP_GRP_STORE: begin
            end
            `INS_OP_GRP_FPLD: begin
                case (op_idx)
                    3'b011: begin   // op *pref*
                        id_o_alu_op = `EXE_OP_NOP;
                        id_o_alu_sel= `EXE_RES_NOP;
                    end
                endcase
            end
            `INS_OP_GRP_FPST: begin
            end
            default: begin
            end
        endcase
    end else begin
        reg0_read = 'b0;
        reg1_read = 'b0;
        reg0_sft = 'b0;
        reg1_sft = 'b0;
        reg0_imme_up = 'b0;
        reg1_imme_up = 'b0;

        id_o_alu_op = 'b0;
        id_o_alu_sel = 'b0;
        id_o_reg0 = 'b0;
        id_o_reg1 = 'b0;
        id_o_waddr = 'b0;
        id_o_wreg = 'b0;
    end
end

// SRC0
always @* begin
    if (!rst_) begin
        id_o_reg0 = 'b0;
    end else if ((reg0_read && ex_o_wreg) && (reg0_addr==ex_o_waddr)) begin
        id_o_reg0 = ex_o_wdata;
    end else if ((reg0_read && mem_o_wreg) && (reg0_addr==mem_o_waddr)) begin
        id_o_reg0 = mem_o_wdata;
    end else if (reg0_read) begin
        id_o_reg0 = reg0_data;
    end else if (reg0_sft) begin
        id_o_reg0 = shamt;
    end else if (reg0_imme_up) begin
        id_o_reg0 = {imme, 16'b0};
    end else if (reg0_imme_sign) begin
        id_o_reg0 = {{16{imme[15]}}, imme};
    end else if (!reg0_read) begin
        id_o_reg0 = imme;
    end else begin
        id_o_reg0 = 'b0;
    end
end
// SRC1
always @* begin
    if (!rst_) begin
        id_o_reg1 = 'b0;
    end else if ((reg1_read && ex_o_wreg) && (reg1_addr==ex_o_waddr)) begin
        id_o_reg1 = ex_o_wdata;
    end else if ((reg1_read && mem_o_wreg) && (reg1_addr==mem_o_waddr)) begin
        id_o_reg1 = mem_o_wdata;
    end else if (reg1_read) begin
        id_o_reg1 = reg1_data;
    end else if (reg1_sft) begin
        id_o_reg1 = shamt;
    end else if (reg1_imme_up) begin
        id_o_reg1 = {imme, 16'b0};
    end else if (reg1_imme_sign) begin
        id_o_reg1 = {{16{imme[15]}}, imme};
    end else if (!reg1_read) begin
        id_o_reg1 = imme;
    end else begin
        id_o_reg1 = 'b0;
    end
end

endmodule
