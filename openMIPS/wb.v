module wb(
    input wb_i_we_hilo,
    input [31:0] wb_i_wdata_hi,
    input [31:0] wb_i_wdata_lo,
    input wb_i_wreg,
    input [4:0] wb_i_waddr,
    input [31:0] wb_i_wdata,

    output reg wb_o_we_hilo,
    output reg [31:0] wb_o_wdata_hi,
    output reg [31:0] wb_o_wdata_lo,
    output reg wb_o_wreg,
    output reg [4:0] wb_o_waddr,
    output reg [31:0] wb_o_wdata
);

always @* begin
    wb_o_we_hilo = wb_i_we_hilo;
    wb_o_wdata_hi = wb_i_wdata_hi;
    wb_o_wdata_lo = wb_i_wdata_lo;
    wb_o_wreg = wb_i_wreg;
    wb_o_waddr = wb_i_waddr;
    wb_o_wdata = wb_i_wdata;
end

endmodule
