module UART_tb();
    reg clk,rst,load;
    reg [7:0] in;
    wire [7:0] out;
    // UART status signals
    wire tx_busy;
    wire tx_done;
     wire parity_bit;
    wire frame_error;
    wire rx_done;
   
    wire calculated_parity;
    wire received_parity;
    wire parity_error;


// Device Under Test (DUT)
UART_connection DUT(
.clk(clk),.rst(rst),.load(load),.in(in),.out(out)
,.tx_done(tx_done),.tx_busy(tx_busy),.parity_bit(parity_bit)
,.rx_done(rx_done) ,.frame_error(frame_error),.calculated_parity(calculated_parity)
,.received_parity(received_parity),.parity_error(parity_error)
);
initial begin
clk=0;
end
always #5 clk=~clk;
initial begin
rst=0;load=0;in=8'h00;
#4 rst=1;
#10 rst=0;load=1;in=8'h8F;
#10 load=0;
#1200in=8'h9C; load=1;
#10 load=0;
#2400 $finish;
// End Simulation
end
endmodule
