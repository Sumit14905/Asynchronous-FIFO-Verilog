// Module: rptr_empty
// Description:
// Generates read pointer and empty signal using Gray code

module rptr_empty
#(
    parameter ASIZE = 4
)
(
    input rclk,
    input rrst_n,
    input  rinc,

    input  [ASIZE:0] wq2_wgray,

    output reg  rempty,

    output reg [ASIZE:0] rbin,
    output reg [ASIZE:0] rgray
);

wire [ASIZE:0] rbinnext;
wire [ASIZE:0] rgraynext;

assign rbinnext = rbin + (rinc & ~rempty);

assign rgraynext = (rbinnext >> 1) ^ rbinnext;

always @(posedge rclk or negedge rrst_n)
begin
    if(!rrst_n)
    begin
        rbin  <= 0;
        rgray <= 0;
    end
    else
    begin
        rbin  <= rbinnext;
        rgray <= rgraynext;
    end
end

always @(posedge rclk or negedge rrst_n)
begin
    if(!rrst_n)
        rempty <= 1;
    else
        rempty <= (rgraynext == wq2_wgray);
end

endmodule