module regfile(
    input clk,
    input rst_,
    input we,
    input [4:0] waddr,
    input [31:0] wdata,
    input re0,
    input [4:0] raddr0,
    output [31:0] rdata0,
    input re1,
    input [4:0] raddr1,
    output [31:0] rdata1,

    input we_hilo,
    input [31:0] wdata_hi,
    input [31:0] wdata_lo,
    input re_hilo,
    output [31:0] rdata_hi,
    output [31:0] rdata_lo
);

reg [31:0] regs [0:31];
reg [31:0] hi_reg;
reg [31:0] lo_reg;

always @(posedge clk) begin
    if (we && (waddr!=0)) begin
        regs[waddr] <= #1 wdata;
    end
end

assign rdata0 = !rst_ ? 'b0:
                !re0  ? 'b0:
                (raddr0=='b0) ? 'b0:
                ((raddr0==waddr) && we) ? wdata:
                                   regs[raddr0];
assign rdata1 = !rst_ ? 'b0:
                !re1  ? 'b0:
                (raddr1=='b0) ? 'b0:
                ((raddr1==waddr) && we) ? wdata:
                                   regs[raddr1];

den_reg #(32) hi_reg_reg(.d(wdata_hi), .q(hi_reg), .en(we_hilo), .*);
den_reg #(32) lo_reg_reg(.d(wdata_lo), .q(lo_reg), .en(we_hilo), .*);
assign rdata_hi = !rst_ ?   'b0:
                  !re_hilo? 'b0:
                         hi_reg;
assign rdata_lo = !rst_ ?   'b0:
                  !re_hilo? 'b0:
                         lo_reg;

endmodule
