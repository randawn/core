module ex(
    input rst_,
    
    input [7:0]  ex_i_alu_op,
    input [2:0]  ex_i_alu_sel,
    input [31:0] ex_i_reg0,
    input [31:0] ex_i_reg1,
    input [4:0]  ex_i_waddr,
    input ex_i_wreg,

    output reg ex_o_wreg,
    output reg [4:0] ex_o_waddr,
    output reg [31:0] ex_o_wdata,

    // hilo
    input [31:0] ex_i_rdata_hi,
    input [31:0] ex_i_rdata_lo,
    output reg ex_o_re_hilo,
    output reg [31:0] ex_o_wdata_hi,
    output reg [31:0] ex_o_wdata_lo,
    output reg ex_o_we_hilo,

    // forwarding
    input mem_o_we_hilo,
    input [31:0] mem_o_wdata_hi,
    input [31:0] mem_o_wdata_lo,
    input wb_o_we_hilo,
    input [31:0] wb_o_wdata_hi,
    input [31:0] wb_o_wdata_lo
);

reg [31:0] logicout;
reg [31:0] shiftout;
reg [31:0] moveout;
reg [31:0] arithout;
reg [31:0] reghi;
reg [31:0] reglo;

// forwarding
always @* begin
    if (!rst_) begin
        reghi = 'b0;
        reglo = 'b0;
    end else if (mem_o_we_hilo) begin
        reghi = mem_o_wdata_hi;
        reglo = mem_o_wdata_lo;
    end else if (wb_o_we_hilo) begin
        reghi = wb_o_wdata_hi;
        reglo = wb_o_wdata_lo;
    end else begin
        reghi = ex_i_rdata_hi;
        reglo = ex_i_rdata_lo;
    end
end

// hi low
always @* begin
    if (!rst_) begin
        moveout = 'b0;
        ex_o_re_hilo = 'b0;
        ex_o_wdata_hi = 'b0;
        ex_o_wdata_lo = 'b0;
        ex_o_we_hilo = 'b0;
    end else begin
        case (ex_i_alu_op)
            `EXE_OP_MOVZ: begin
                moveout = ex_i_reg0;
            end
            `EXE_OP_MOVN: begin
                moveout = ex_i_reg0;
            end
            `EXE_OP_MFHI: begin
                moveout = reghi;
                ex_o_re_hilo = 'b1;
            end
            `EXE_OP_MFLO: begin
                moveout = reglo;
                ex_o_re_hilo = 'b1;
            end
            `EXE_OP_MTHI: begin
                ex_o_we_hilo = 'b1;
                ex_o_wdata_hi = ex_i_reg0;
                ex_o_wdata_lo = reglo;
                ex_o_re_hilo = 'b1;
            end
            `EXE_OP_MTLO: begin
                ex_o_we_hilo = 'b1;
                ex_o_wdata_hi = reghi;
                ex_o_wdata_lo = ex_i_reg0;
                ex_o_re_hilo = 'b1;
            end
            default: begin
                ex_o_we_hilo = 'b0;
                ex_o_re_hilo = 'b0;
            end
        endcase
    end
end

// logic
always @* begin
    if (!rst_) begin
        logicout = 'b0;
    end else begin
        case (ex_i_alu_op)
            `EXE_OP_AND: begin
                logicout = ex_i_reg0 & ex_i_reg1;
            end
            `EXE_OP_OR: begin
                logicout = ex_i_reg0 | ex_i_reg1;
            end
            `EXE_OP_NOR: begin
                logicout = ~(ex_i_reg0 | ex_i_reg1);
            end
            `EXE_OP_XOR: begin
                logicout = ex_i_reg0 ^ ex_i_reg1;
            end
            default: begin
                logicout = 'b0;
            end
        endcase
    end
end

// shift
always @* begin
    if (!rst_) begin
        shiftout = 'b0;
    end else begin
        case (ex_i_alu_op)
            `EXE_OP_SLL: begin
                shiftout = ex_i_reg1 << ex_i_reg0;
            end
            `EXE_OP_SRL: begin
                shiftout = ex_i_reg1 >> ex_i_reg0;
            end
            `EXE_OP_SRA: begin
                shiftout = (ex_i_reg1 >> ex_i_reg0) |
                           ((32'hffffffff >> ex_i_reg0) << ex_i_reg0);
            end
            default: begin
                shiftout = 'b0;
            end
        endcase
    end
end

// arith
wire [31:0] ex_i_reg1_comp = ~ex_i_reg1 + 1;
always @* begin
    if (!rst_) begin
        arithout = 'b0;
    end else begin
        case (ex_i_alu_op)
            `EXE_OP_SLT: begin
                arithout = (ex_i_reg0[31] && !ex_i_reg1[31]) ||
                           ((!ex_i_reg0[31] && !ex_i_reg1[31]) && (ex_i_reg0<ex_i_reg1))  ||
                           ((!ex_i_reg0[31] && !ex_i_reg1[31]) && (ex_i_reg0>ex_i_reg1));
            end
            `EXE_OP_SLTU: begin
                arithout = ex_i_reg0<ex_i_reg1;
            end
            `EXE_OP_ADD, `EXE_OP_ADDI, `EXE_OP_ADDU, `EXE_OP_ADDIU: begin
                arithout = ex_i_reg0 + ex_i_reg1;
            end
            `EXE_OP_SUB, `EXE_OP_SUBU: begin
                arithout = ex_i_reg0 + ex_i_reg1_comp;
            end
            `EXE_OP_CLZ:
            `EXE_OP_CLO:
        endcase
    end
end


always @* begin
    if (!rst_) begin
        ex_o_wreg = 'b0;
    end else begin
        ex_o_wreg = ex_i_wreg;
        ex_o_waddr= ex_i_waddr;
        case (ex_i_alu_sel)
            `EXE_RES_LOGIC: begin
                ex_o_wdata = logicout;
            end
            `EXE_RES_SHIFT: begin
                ex_o_wdata = shiftout;
            end
            `EXE_RES_MOVE: begin
                ex_o_wdata = moveout;
            end
            default: begin
                ex_o_wdata = 'b0;
            end
        endcase
    end
end


endmodule
