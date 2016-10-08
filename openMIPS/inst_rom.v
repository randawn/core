module inst_rom(
    input pc_vld,
    input [31:0] pc,
    output inst_vld,
    output [31:0] inst
);

reg [31:0] inst_mem[0:1023];

initial begin
    $readmemh("bench/inst_rom.data", inst_mem);
end

assign inst_vld = pc_vld;
assign inst = !pc_vld ? 'b0 : inst_mem[pc[10-1:2]];

endmodule
