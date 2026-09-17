`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2026 13:09:40
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input wire clk,
    input wire reset,
    input wire baud_tick,

    input wire [7:0] data_in,
    input wire tx_start,

    output reg tx,
    output reg tx_busy,
    output reg tx_done
);

    // Store the data to be transmitted
    reg [7:0] data_reg;

    // Counts data bits: 0 to 7
    reg [3:0] bit_count;

    // FSM states
    reg [1:0] state;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;


    always @(posedge clk) begin

        if (reset) begin

            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            tx_done   <= 1'b0;

            data_reg  <= 8'b0;
            bit_count <= 4'd0;

            state     <= IDLE;
        end

        else begin

            // tx_done is normally LOW
            tx_done <= 1'b0;

            case (state)

               
                // IDLE STATE
               
                IDLE: begin

                    tx      <= 1'b1;
                    tx_busy <= 1'b0;

                    if (tx_start) begin

                        // Store input data
                        data_reg <= data_in;

                        // Start from D0
                        bit_count <= 4'd0;

                        tx_busy <= 1'b1;

                        state <= START;
                    end
                end


                
                // START BIT
               
                START: begin

                    if (baud_tick) begin

                        // UART start bit = 0
                        tx <= 1'b0;

                        state <= DATA;
                    end
                end


                
                // DATA BITS
                
                DATA: begin

                    if (baud_tick) begin

                        // Send one data bit
                        // LSB is transmitted first
                        tx <= data_reg[bit_count];

                        if (bit_count == 4'd7) begin

                            // All 8 bits transmitted
                            bit_count <= 4'd0;

                            state <= STOP;
                        end

                        else begin

                            // Move to next bit
                            bit_count <= bit_count + 1'b1;
                        end
                    end
                end


                
                // STOP BIT
                
                STOP: begin

                    if (baud_tick) begin

                        // UART stop bit = 1
                        tx <= 1'b1;

                        tx_busy <= 1'b0;

                        // Transmission completed
                        tx_done <= 1'b1;

                        state <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule
