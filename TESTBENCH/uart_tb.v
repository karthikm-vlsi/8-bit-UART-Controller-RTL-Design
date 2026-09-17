`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2026 13:53:43
// Design Name: 
// Module Name: uart_tb
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


`timescale 1ns/1ps

module uart_tb;

    
    // Testbench signals
    
    reg clk;
    reg reset;

    reg [7:0] tx_data;
    reg tx_start;

    wire rx;

    wire tx;
    wire tx_busy;
    wire tx_done;

    wire [7:0] rx_data;
    wire rx_done;


    
    // Create clock
   
    always #5 clk = ~clk;


    
    // Loopback connection
    
    assign rx = tx;


    
    // UART Top Module
   
    uart_top #(
        .CLOCK_FREQ(100),
        .BAUD_RATE(10)
    ) uut (

        .clk(clk),
        .reset(reset),

        .tx_data(tx_data),
        .tx_start(tx_start),

        .rx(rx),

        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),

        .rx_data(rx_data),
        .rx_done(rx_done)
    );


    
    // Test procedure
    
    initial begin

        // Initial values
        clk      = 0;
        reset    = 1;
        tx_data  = 8'b00000000;
        tx_start = 0;


        
        // Reset
        
        #20;

        reset = 0;


        
        // Send data
       
        #20;

        tx_data = 8'b10110010;

        tx_start = 1;

        #10;

        tx_start = 0;


       
        // Wait for transmission
      
        wait(tx_done);


      
        // Wait for reception
        
        wait(rx_done);


       
        // Display result
        
        $display("Transmitted Data = %b", tx_data);
        $display("Received Data    = %b", rx_data);


        
        // Check result
     
        if (rx_data == tx_data)
            $display("UART TEST PASSED");

        else
            $display("UART TEST FAILED");


        // Stop simulation
        #20;

        $finish;

    end

endmodule
