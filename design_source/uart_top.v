`timescale 1ns / 1ps
module uart_top (
    input        rst,
    input  [7:0] data_in,
    input        start_tx,
    input        clk,
    output       tx,
    output       busy
);
    wire baud_tick;
    baud_generator bg (
        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick)
    );
    uart_tx ut (
        .rst       (rst),
        .baud_tick (baud_tick),
        .clk       (clk),
        .start_tx  (start_tx),
        .data_in   (data_in),
        .tx        (tx),
        .busy      (busy)
    );
endmodule
