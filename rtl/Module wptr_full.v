// Module: wptr_full
// Description:
// Generates write pointer and full signal using Gray code

module wptr_full
#(
    parameter ASIZE = 4
)
(
    input wclk,
    input  wrst_n,
    input winc,

    input  [ASIZE:0] rq2_rgray,

    output reg   wfull,

    output reg [ASIZE:0] wbin,
    output reg [ASIZE:0] wgray
);

wire [ASIZE:0] wbinnext;
wire [ASIZE:0] wgraynext;

assign wbinnext = wbin + (winc & ~wfull);

assign wgraynext = (wbinnext >> 1) ^ wbinnext;

always @(posedge wclk or negedge wrst_n)
begin
    if(!wrst_n)
    begin
        wbin  <= 0;
        wgray <= 0;
    end
    else
    begin
        wbin  <= wbinnext;
        wgray <= wgraynext;
    end
end

always @(posedge wclk or negedge wrst_n)
begin
    if(!wrst_n)
        wfull <= 0;
    else
        wfull <= (wgraynext =={~rq2_rgray[ASIZE:ASIZE-1],rq2_rgray[ASIZE-2:0]});
end

endmodule