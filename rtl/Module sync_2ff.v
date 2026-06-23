// Module: sync_2ff
// Description:
// This is a simple 2 flip-flop synchronizer used to pass signals safely
// between two clock domains in Async FIFO


module sync_2ff
#(
    parameter WIDTH = 5
)
(
    input clk,
    input rst_n,

    input  [WIDTH-1:0] din,

    output reg [WIDTH-1:0]  q1,
    output reg [WIDTH-1:0]  q2
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        q1 <= 0;
        q2 <= 0;
    end
    else
    begin
        q1 <= din;
        q2 <= q1;
    end
end

endmodule