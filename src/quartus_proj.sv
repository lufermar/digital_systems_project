
// Here we define the inputs / outputs
module quartus_proj(
    input           MAX10_CLK1_50,  // 50 HMz clock
    input  [1:0]    KEY,            // Buttons
    inout  [9:0]    ARDUINO_IO,     // Header pins
    output [9:0]    LEDR,           // LEDs
    input  [9:0]    SW,             // Switches
    output [7:0]    HEX0,           // 7-segment dieplay
    output [7:0]    HEX1,           // 7-segment dieplay
    output [7:0]    HEX2,           // 7-segment dieplay
    output [7:0]    HEX3,           // 7-segment dieplay
    output [7:0]    HEX4            // 7-segment dieplay
);
    
	 // Connect the LEDs 0 and 1 to the switches 0 and 1
    assign LEDR[1:0] = SW[1:0];
	 
	 // connect the LED 2 to the AND of the two switches
	 // assign LEDR[2] = SW[1] && SW[0];
	 assign LEDR[2] = SW[1] ^ SW[0];

endmodule
