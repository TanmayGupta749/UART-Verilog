module UART_connection(
input clk,rst,load,
input [7:0] in,
output [7:0] out,
// Transmitter status signals
 output tx_busy,
    output tx_done,
    output parity_bit,
    // Receiver status signals
    output frame_error,
    output rx_done,
    output calculated_parity,
    output received_parity,
    output parity_error
    );
    wire baud_tick; // UART baud rate clock
    wire serial_line; // Serial communication line between TX and RX

// Baud Rate Generator
    Baudgenerator U1(
    .clk(clk),.baud_tick(baud_tick)
);

// UART Transmitter
    UART_TX U2(
    .clk(clk),.rst(rst),.load(load),.baud_tick(baud_tick),
    .in(in),.tx(serial_line),.tx_done(tx_done),.tx_busy(tx_busy)
   ,.parity_bit(parity_bit)
    );
    
    // UART Receiver
    UART_RX U3(
    .clk(clk),.rst(rst),.baud_tick(baud_tick),.tx(serial_line)
    ,.out(out),.rx_done(rx_done) ,.frame_error(frame_error)
    ,.calculated_parity(calculated_parity),.received_parity(received_parity),
    .parity_error(parity_error)
    
    );
endmodule
