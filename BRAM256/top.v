// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    output USBPU  // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    ////////
    // make a simple blink circuit
    ////////

    // keep track of time and location in blink_pattern
    reg [25:0] blink_counter;

    // pattern that will be flashed over the LED over time
    wire [31:0] blink_pattern = 32'b101010001110111011100010101;

    // increment the blink_counter every clock
    always @(posedge CLK) begin
        blink_counter <= blink_counter + 1;
    end

    // light up the LED according to the pattern
    assign LED = blink_pattern[blink_counter[25:21]];
    assign PIN_13 = CLK;
    wire [15:0] AAA;
    SB_RAM256x16 ram(
      .RDATA(AAA),
      .RCLK(1'b0),
      .RCLKE(1'b0),
      .RE(1'b0),
      .RADDR(8'b0),
      .WCLK(1'b0),
      .WCLKE(1'b0),
      .WE(1'b0),
      .WADDR(8'b0),
      .MASK(16'b0),
      .WDATA(16'd0)
      );
endmodule
