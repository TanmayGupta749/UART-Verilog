module UART_TX(
input clk,rst,load,
input baud_tick,
input [7:0] in,
output reg tx,      //  UART serial transmit line
output reg tx_busy, // High while transmission is in progress
output reg tx_done,     // Pulses high when frame transmission completes
output reg parity_bit    // Generated parity bit for transmitted data


    );
    // FSM States
    reg [7:0] temp; // shift register for shfting input
    reg [2:0]count; // count for transmitting data
    parameter IDLE=3'b000;
    parameter START=3'b001;
     parameter  DATA=3'b010;
     parameter PARITY=3'b011;
    parameter STOP=3'b100;
    reg [2:0]ps,ns;
    
    
    // Data Register and Shift Logic
    always @(posedge clk) begin
    if(rst)
    temp<=0;
    else begin
    if(load && ps==IDLE)
    temp<=in;
    if(baud_tick && ps==DATA)begin 
    temp<=temp>>1;
    end
    end
    end
    
    // State Register
    always @(posedge clk) begin
    if(rst)begin
    ps<=IDLE;
    end
    else begin
    ps<=ns;
    end
    end
    
    // Next-State Logic
    always @(*) begin
    case(ps)
    IDLE: begin  // IDLE
    if(load) begin
    ns=START;
    end
    else
    ns=IDLE;
    end
    START: begin   // Start
    if(baud_tick) begin
    ns=DATA;
   
    end
else
ns=START;
    end
    
    DATA: begin     /// DATA
    if(baud_tick && count==7) begin
    ns=PARITY;
    
    end
    else  begin
    ns=DATA;
    end
    end
    PARITY: begin   /// PARITY
    if(baud_tick)
    ns=STOP;
    else
    ns=PARITY;
    end
    STOP : begin // STOP
    if(baud_tick) begin
    ns=IDLE;
    end
    else  begin
    ns=STOP;
    end
    end
    default: 
    ns=IDLE;
    endcase
    end
    
    // Bit Counter
    always @(posedge clk) begin
    if(rst)
    count<=0;
    else if(ps==IDLE)
    count<=0;
    else if(baud_tick && ps==DATA)
    count<=count+1;
    end
    
    // Parity Bit Generation
    always @(posedge clk) begin
    if(rst)
    parity_bit<=0;
   else if(ps==IDLE && load==1)
    parity_bit<=^in;
    end
    
    // TX Output Logic
    always @(*) begin
    case(ps)
    IDLE: tx=1;
    START: tx=0;
    DATA: tx=temp[0];
    PARITY: tx=parity_bit;
    STOP: tx=1;
    default: tx=1;
    endcase
    end
    
    // TX Busy Flag
    always @(posedge clk) begin
    if(ps==IDLE)
    tx_busy<=0;
    else 
    tx_busy<=1;
    end
    
    // TX Done Flag
    always @(posedge clk) begin
    if(ps==STOP && baud_tick)
    tx_done<=1;
    else 
   tx_done<=0;
    end  
endmodule
