// Module: fifo_mem
// Description:
// This is the memory block of Async FIFO
// It stores data using write clock and gives data using read address

module fifo_mem
#(
    parameter DSIZE = 8,
    parameter ASIZE = 4
)
(
    input  wclk,
    input  winc,
    input wfull,

    input  [ASIZE-1:0] waddr,
    input  [DSIZE-1:0]   wdata,

    input [ASIZE-1:0] raddr,

    output [DSIZE-1:0] rdata
);

localparam DEPTH = (1 << ASIZE);

reg [DSIZE-1:0] mem [0:DEPTH-1];

always @(posedge wclk)
begin
    if(winc && !wfull)
        mem[waddr] <= wdata;
end

assign rdata = mem[raddr];

endmodule