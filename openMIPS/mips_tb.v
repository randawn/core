module mips_tb;


reg clk;
reg rst_;
initial begin
    clk = 0;
    forever begin
        #10 clk = !clk;
    end
end

initial begin
    rst_= 0;
    #100 rst_ = 1;
    #10000 $finish;
end

wire inst_vld;
wire [31:0] inst;
wire [31:0] pc;
wire pc_vld;

mips u_mips(.*);

inst_rom u_inst_rom(.*);

initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, "mips_tb");
end

endmodule
