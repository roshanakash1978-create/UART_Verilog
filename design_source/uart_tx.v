`timescale 1ns / 1ps
module uart_tx(
    input clk,
    input rst,
    input start_tx,
    input [7:0] data_in,
    input baud_tick,
    output reg tx,
    output reg busy
);
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;
    reg [1:0] state;
    always @(posedge clk) begin
        if(rst) begin
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            tx        <= 1'b1;
            busy      <= 1'b0;
            state     <= IDLE;
        end 
        else begin
            case(state)                
                IDLE: begin
                    busy <= 1'b0;
                    tx   <= 1'b1;                    
                    if(start_tx) begin
                        state     <= START;
                        shift_reg <= data_in;
                        bit_count <= 3'b0;
                    end
                end
                START: begin
                    tx   <= 1'b0;
                    busy <= 1'b1;
                    
                    if(baud_tick) begin
                        state <= DATA;
                    end
                end
                DATA: begin
                    if(baud_tick) begin
                        tx<= shift_reg[0];
                        shift_reg <= shift_reg >> 1;                        
                        if(bit_count == 3'd7) begin
                            state     <= STOP;
                            bit_count <= 3'b0;
                        end 
                        else begin
                            bit_count <= bit_count + 1'b1;
                        end
                    end
                end
                STOP: begin
                    tx <= 1'b1; 
                    if(baud_tick) begin
                        state <= IDLE;
                        busy  <= 1'b0;
                    end
                end
                default: state <= IDLE;         
            endcase
        end
    end
endmodule
