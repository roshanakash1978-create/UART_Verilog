`timescale 1ns / 1ps
module uart_tx_tb;
  uart_top UUT (
        .clk      (clk),
        .data_in  (data_in),
        .rst      (rst),
        .start_tx (start_tx),
        .tx       (tx),
        .busy     (busy)
    );
    reg        clk;
    reg        rst;
    reg        start_tx;
    reg  [7:0] data_in;
    wire       tx;
    wire       busy;
    initial clk = 0;
    always #5 clk = ~clk; // 100mhz means 100 million clock cycles in a second. 1/100M is how much 1 clock cycle lasts that is 10ns(0->1->0). we need only 0->1 so its 5ns.
    initial begin
        rst      = 1;
        start_tx = 0;
        data_in  = 8'h00;
        #20;
        rst      = 0;
        #20;
        data_in  = 8'h55;
        start_tx = 1;
        #10;
        start_tx = 0;
        #1200000;
        $finish;
    end
endmodule
