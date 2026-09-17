module uart_top #(
    parameter CLOCK_FREQ = 100_000_000,
    parameter BAUD_RATE  = 9600
)(
    input wire clk,
    input wire reset,

    // Transmitter inputs
    input wire [7:0] tx_data,
    input wire tx_start,

    // Receiver input
    input wire rx,

    // Transmitter outputs
    output wire tx,
    output wire tx_busy,
    output wire tx_done,

    // Receiver outputs
    output wire [7:0] rx_data,
    output wire rx_done
);

    // Baud timing signal
    wire baud_tick;


    // --------------------------------
    // Baud Generator
    // --------------------------------
    baud_generator #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );


    // --------------------------------
    // UART Transmitter
    // --------------------------------
    uart_tx transmitter (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),

        .data_in(tx_data),
        .tx_start(tx_start),

        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );


    // --------------------------------
    // UART Receiver
    // --------------------------------
    uart_rx receiver (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),

        .rx(rx),

        .data_out(rx_data),
        .rx_done(rx_done)
    );

endmodule