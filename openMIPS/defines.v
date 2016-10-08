
`define TURE        1'b1
`define FALSE       1'b0

// FOR EX
// op
`define EXE_OP_NOP  8'd0

`define EXE_OP_OR   8'd1
`define EXE_OP_AND  8'd2
`define EXE_OP_NOR  8'd3
`define EXE_OP_XOR  8'd4

`define EXE_OP_SLL  8'd5
`define EXE_OP_SRL  8'd6
`define EXE_OP_SRA  8'd7

`define EXE_OP_MOVZ  8'd8
`define EXE_OP_MOVN  8'd9
`define EXE_OP_MFHI  8'd10
`define EXE_OP_MFLO  8'd11
`define EXE_OP_MTHI  8'd12
`define EXE_OP_MTLO  8'd13

`define EXE_OP_SLT      8'd14
`define EXE_OP_SLTU     8'd15
`define EXE_OP_SLTI     8'd16
`define EXE_OP_SLTIU    8'd17
`define EXE_OP_ADD      8'd18
`define EXE_OP_ADDU     8'd19
`define EXE_OP_SUB      8'd20
`define EXE_OP_SUBU     8'd21
`define EXE_OP_ADDI     8'd22
`define EXE_OP_ADDIU    8'd23
`define EXE_OP_CLZ      8'd24
`define EXE_OP_CLO      8'd25

`define EXE_OP_MULT     8'd26
`define EXE_OP_MULTU    8'd27
`define EXE_OP_MUL      8'd28

`define EXE_OP_DIV      8'd26
`define EXE_OP_DIVU     8'd27
`define EXE_OP_MUL      8'd28

// sel
`define EXE_RES_NOP   3'd0
`define EXE_RES_LOGIC 3'd1
`define EXE_RES_SHIFT 3'd2
`define EXE_RES_MOVE  3'd3
`define EXE_RES_ARITH 3'd4
`define EXE_RES_MUL   3'd5

// FOR ID
// OP (31:26) inst: 31-29 group 28-26 index
`define INS_OP_GRP_BASIC    3'd0
`define INS_OP_GRP_IMM      3'd1
`define INS_OP_GRP_TLB      3'd2
`define INS_OP_GRP_MUL      3'd3
`define INS_OP_GRP_LOAD     3'd4
`define INS_OP_GRP_STORE    3'd5
`define INS_OP_GRP_FPLD     3'd6
`define INS_OP_GRP_FPST     3'd7

// OP=6'b0 FUNC(5:0) for R-format 
`define INS_FUNC_GRP_SHT    3'd0
`define INS_FUNC_GRP_JMP    3'd1
`define INS_FUNC_GRP_HILO   3'd2
`define INS_FUNC_GRP_MUL    3'd3
`define INS_FUNC_GRP_BAS    3'd4
`define INS_FUNC_GRP_SET    3'd5

