// Module: async_fifo_top
// Description:
// This connects all FIFO blocks together

module async_fifo_top
#(
    parameter DSIZE = 8,
    parameter ASIZE = 4
)
(
    input wclk,
    input wrst_n,
    input winc,
    input  [DSIZE-1:0] wdata,

    input rclk,
    input rrst_n,
    input rinc,

    output [DSIZE-1:0] rdata,

    output wfull,
    output rempty
);

wire [ASIZE:0] wbin, rbin;
wire [ASIZE:0] wgray, rgray;

wire [ASIZE:0] rq2_rgray;
wire [ASIZE:0] wq2_wgray;

fifo_mem #(DSIZE,ASIZE) mem (
    .wclk(wclk),
    .winc(winc),
    .wfull(wfull),
    .waddr(wbin[ASIZE-1:0]),
    .wdata(wdata),
    .raddr(rbin[ASIZE-1:0]),
    .rdata(rdata)
);

sync_2ff #(ASIZE+1) sync_r2w (
    .clk(wclk),
    .rst_n(wrst_n),
    .din(rgray),
    .q1(),
    .q2(rq2_rgray)
);

sync_2ff #(ASIZE+1) sync_w2r (
    .clk(rclk),
    .rst_n(rrst_n),
    .din(wgray),
    .q1(),
    .q2(wq2_wgray)
);

wptr_full #(ASIZE) wptr (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .winc(winc),
    .rq2_rgray(rq2_rgray),
    .wfull(wfull),
    .wbin(wbin),
    .wgray(wgray)
);

rptr_empty #(ASIZE) rptr (
    .rclk(rclk),
    .rrst_n(rrst_n),
    .rinc(rinc),
    .wq2_wgray(wq2_wgray),
    .rempty(rempty),
    .rbin(rbin),
    .rgray(rgray)
);

endmodule