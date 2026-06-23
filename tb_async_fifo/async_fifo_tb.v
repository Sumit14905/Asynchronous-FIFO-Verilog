`timescale 1ns/1ps

module async_fifo_tb();

    parameter DSIZE = 8;
    parameter ASIZE = 4;
    parameter DEPTH = (1 << ASIZE);

    reg  [DSIZE-1:0] wdata;
    wire [DSIZE-1:0] rdata;

    wire wfull;
    wire rempty;

    reg winc;
    reg rinc;

    reg wclk;
    reg rclk;

    reg wrst_n;
    reg rrst_n;

    // DUT
    async_fifo_top dut (
        .wclk   (wclk),
        .wrst_n (wrst_n),
        .winc   (winc),
        .wdata  (wdata),

        .rclk   (rclk),
        .rrst_n (rrst_n),
        .rinc   (rinc),

        .rdata  (rdata),
        .wfull  (wfull),
        .rempty (rempty)
    );

    integer i;

  
    // Clock Generation
   

    always #5  wclk = ~wclk;   // Write Clock
    always #7  rclk = ~rclk;   // Read Clock

   

    initial begin

        // Initialization
        wclk   = 0;
        rclk   = 0;

        wrst_n = 1;
        rrst_n = 1;

        winc   = 0;
        rinc   = 0;

        wdata  = 0;

      
        // Reset
       
        #40;
        wrst_n = 0;
        rrst_n = 0;

        #40;
        wrst_n = 1;
        rrst_n = 1;

    
        // TEST CASE 1
        // Normal FIFO Operation
        
        rinc = 1;

        for(i = 0; i < 10; i = i + 1)
        begin
            @(posedge wclk);

            if(!wfull)
            begin
                wdata = $random;
                winc  = 1;
            end

            @(posedge wclk);
            winc = 0;
        end

       
        // TEST CASE 2
        // Fill FIFO and verify FULL flag
     

        rinc = 0;

        for(i = 0; i < DEPTH + 3; i = i + 1)
        begin
            @(posedge wclk);

            if(!wfull)
            begin
                wdata = $random;
                winc  = 1;
            end
            else
                winc = 0;

            @(posedge wclk);
            winc = 0;
        end

        
        // TEST CASE 3
        // Empty FIFO and verify EMPTY flag
        
        winc = 0;

        for(i = 0; i < DEPTH + 3; i = i + 1)
        begin
            @(posedge rclk);

            if(!rempty)
                rinc = 1;
            else
                rinc = 0;

            @(posedge rclk);
            rinc = 0;
        end

        // End Simulation


        #100;
        $finish;

    end

endmodule