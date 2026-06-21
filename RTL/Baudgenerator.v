module Baudgenerator(
input clk,
output reg baud_tick
  );
  // Clock divider counter
// Assuming clk = 96 kHz and UART baud rate = 9600 bps
// baud_freq= 96000 / 9600 = 10
parameter clk_freq=96000;
parameter baud_rate=9600;
parameter baud_freq=clk_freq/baud_rate;
  reg [12:0]count=0;   
  
  always @(posedge clk) begin
  // Generate a one-clock-cycle baud tick every 10 clock cycles
  if(count==baud_freq-1) begin
   baud_tick<=1;
   count<=0;
   end
   else begin
   baud_tick<=0;
   count<=count+1;
  end
  end
endmodule
