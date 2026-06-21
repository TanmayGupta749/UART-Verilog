module UART_RX(
input clk,rst,baud_tick,
input tx,             // Serial data received from transmitter

output reg [7:0]out, // Received parallel data byte
output reg rx_done,  //  Pulses high when a byte is received
output reg calculated_parity, //  Parity computed from received data bits
output reg frame_error, //High when stop bit is invalid
output reg received_parity,  // Parity bit received from transmitter
output reg parity_error //  // High when parity check fails
    );
    reg [7:0] temp=8'b0; // Shift register for received data
    reg [2:0] count; // Counts received data bits
    // FSM States
     parameter IDLE=3'b000;
    parameter START=3'b001;
     parameter  DATA=3'b010;
     parameter PARITY=3'b011;
    parameter STOP=3'b100;
    
    reg [2:0]ps,ns;
    reg [2:0]parity_count=0; // Counts number of logic '1's
    
    // Serial-to-parallel shift register
    always @(posedge clk)begin
    if(rst) begin
    temp<=0;
    out<=0;
    end
    else if(baud_tick && ps==DATA)begin
    temp<=temp>>1;
    temp[7]<=tx;
    end
    end
    
    // State Register
    always @(posedge clk) begin
    if(rst)
    ps<=IDLE;
    else
    ps<=ns;
    end
    
    // Next-State Logic
    always @(*) begin 
    case(ps)
   IDLE: begin   //// IDLE
   if(tx==0)
   ns=START;
   else
   ns=IDLE;
   
   end
    
    START: begin
    if(baud_tick && tx==0) 
    ns=DATA;
    else
    ns=START;
    end
    
    DATA: begin
    if(count==7 && baud_tick)
    ns=PARITY;
    else
    ns=DATA;
    end
   
   PARITY: begin
   if(baud_tick)
   ns=STOP;
   else 
   ns=PARITY;
   end
   
   
   STOP: begin
   if(baud_tick && tx==1)
   ns=IDLE;
   else 
   ns=STOP;
   
   
   end
    endcase
   end 
   
   // Data Bit Counter
   always @(posedge clk) begin
   if(rst)
   count<=0;
   else if(baud_tick && ps==DATA)
   count<=count+1;
   else if(ps==IDLE)
   count<=0;
   end
   
   // // Output Data Register
   always @(posedge clk)
begin
    if(ps == STOP && baud_tick && tx == 1)
        out<= temp;
end
   
   // Complete Flag
   always @(posedge clk) begin
   if(baud_tick && ps==STOP)
   rx_done<=1;
   else
   rx_done<=0;
   end
   
   // Parity Calculation
   always @(posedge clk) begin
   if(rst || ps==IDLE)
   parity_count<=0;
  else if(tx==1 && ps==DATA && baud_tick)
   parity_count<=parity_count+1;
   else
   parity_count<=parity_count;
   end
   
   // Received Parity Bit Capture
   always @(*) begin
   if(parity_count%2==0)
   calculated_parity=0;
   else 
   calculated_parity=1;
   end
 
 always @(posedge clk) begin 
 if(rst)
 received_parity<=0;
 else if(ps==PARITY && baud_tick)
 received_parity<=tx;
 end
 
 // Parity Error Detection
 always @(posedge clk) begin
 if(rst)
 parity_error<=0;
 else if(ps==STOP && baud_tick)
 if(calculated_parity == received_parity)
 parity_error<=0;
 else if(calculated_parity!=received_parity)
 parity_error<=1;
 end
      
      // Framing Error Detection
    always @(posedge clk) begin
    if(rst)
    frame_error<=0;
    else if(ps==STOP && tx==0 && baud_tick) 
    frame_error<=1;

    else
    frame_error<=0;
    end
endmodule
