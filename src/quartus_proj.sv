
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

    // Create signals
    logic clk;
    logic tick;
    logic signed[15:0] data;

    logic              adc_clk;        // SPI clk
    logic              adc_mosi;       // MOSI: always 1
    logic              adc_cnv;        // Start conversion (SPI CS)
    logic              adc_miso;       // MISO: The DAC data
    
    logic              dac_clk;        // SPI clock
    logic              dac_mosi;       // SPI MOSI
    logic              dac_cs;         // chip select
    logic              dac_reset_n;    // reset of the DAC

    // Assign the clock to the 50 MHz FPGA clock
    assign clk = MAX10_CLK1_50;
    // Assign reset
    assign reset = !KEY[0];

    // Create the tick generator
    TickGen #(
        .DIVIDER(50)
    ) tickGen (
        .clk_i(clk),
        .reset_i(reset),
        .tick_o(tick)
    );

    ADC adc(
        .clk_i(clk),
        .reset_i(reset),
        .start_i(tick),
        .data_o(data),
        .spi_clk_o(adc_clk),
        .spi_mosi_o(adc_mosi),
        .cnv_o(adv_cnv),
        .spi_miso_i(adc_miso),
        .is_idle_o()
    );

    DAC dac(
        .clk_i(clk),
        .reset_i(reset),
        .start_i(tick),
        .data_i(data),
        .spi_clk_o(dac_clk),
        .spi_mosi_o(dac_mosi),
        .spi_cs_o(dac_cs),
        .dac_reset_no(dac_reset_n),
        .is_idle_o()
    );

    // the wireing:
    assign ARDUINO_IO[0] = dac_cs;
	assign ARDUINO_IO[1] = dac_clk;
    assign ARDUINO_IO[2] = dac_mosi;
    assign ARDUINO_IO[3] = dac_reset_n;
    
    assign ARDUINO_IO[4] = adc_cnv;
    assign ARDUINO_IO[5] = adc_clk;
    assign ARDUINO_IO[6] = adc_mosi;
    assign adc_miso = ARDUINO_IO[7];

endmodule
