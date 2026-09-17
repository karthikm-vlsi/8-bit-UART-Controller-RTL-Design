`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2026 13:20:32
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx(
    input wire clk,
    input wire reset,
    input wire baud_tick,

    input wire rx,

    output reg [7:0] data_out,
    output reg rx_done
);

    reg [7:0] data_reg;
    reg [3:0] bit_count;

    reg [1:0] state;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;


    always @(posedge clk) begin

        if (reset) begin

            data_out <= 8'b0;
            rx_done  <= 1'b0;

            data_reg <= 8'b0;
            bit_count <= 4'd0;

            state <= IDLE;
        end

        else begin

            // Normally rx_done is LOW
            rx_done <= 1'b0;

            case (state)

                
                // IDLE
                
                IDLE: begin

                    if (rx == 1'b0) begin

                        // Possible start bit detected
                        bit_count <= 4'd0;

                        state <= START;
                    end
                end


                
                // START BIT
                
                START: begin

                    if (baud_tick) begin

                        // Confirm start bit
                        if (rx == 1'b0) begin

                            state <= DATA;
                        end

                        else begin

                            // False start
                            state <= IDLE;
                        end
                    end
                end


                
                // DATA BITS
                
                DATA: begin

                    if (baud_tick) begin

                        // Receive LSB first
                        data_reg[bit_count] <= rx;

                        if (bit_count == 4'd7) begin

                            bit_count <= 4'd0;

                            state <= STOP;
                        end

                        else begin

                            bit_count <= bit_count + 1'b1;
                        end
                    end
                end


                
                // STOP BIT
                
                STOP: begin

                    if (baud_tick) begin

                        if (rx == 1'b1) begin

                            // Transfer received data
                            data_out <= data_reg;

                            rx_done <= 1'b1;
                        end

                        state <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
