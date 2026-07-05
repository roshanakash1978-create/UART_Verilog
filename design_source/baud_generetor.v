`timescale 1ns / 1ps
module baud_generator(
    input clk,
    input rst,
    output reg baud_tick
);
    reg [23:0] accumulator;
    localparam INCREMENT = 24'd1611;
    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 24'b0;
            baud_tick   <= 1'b0;
        end 
        else begin
            accumulator <= accumulator + INCREMENT;
            if ((accumulator + INCREMENT) < accumulator) begin
                baud_tick <= 1'b1;
            end 
            else begin
                baud_tick <= 1'b0;
            end
        end
    end
endmodule
