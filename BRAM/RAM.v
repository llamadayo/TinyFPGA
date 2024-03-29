module RAM (
  input clk,

  output PIN_13,
  output PIN_14,
  output PIN_15,
  output PIN_18,
  output PIN_19,

  output USBPU  // USB pull-up resistor

);
assign USBPU = 0;

assign WCLK = clk;
assign RCLK = ~clk;

assign PIN_13 = WCLK;
assign PIN_14 = WCLKE;

assign PIN_15 = we;

assign PIN_18 = RCLK;
assign PIN_19 = RDATA[3];


reg [7:0] raddr = 8'd0;

reg [24:0] counter;
reg we = 1'b0;

always @ ( posedge clk ) begin
    if (counter < 1)
    begin
      counter <= counter + 1'b1;
    end
    else
    begin
      we <= ~we;
      counter <= 0;
    end
end
// reg [10:0] raddr = 8'd1;


ram40_4k_256x16 ram256x16_inst (
  .RDATA(RDATA_c[15:0]),
  .RADDR(RADDR_c[7:0]),
  .RCLK(RCLK_c),
  .RCLKE(RCLKE_c),
  .RE(RE_c),
  .WADDR(WADDR_c[7:0]),
  .WCLK(WCLK_c),
  .WCLKE(WCLKE_c),
  .WDATA(WDATA_c[15:0]),
  .WE(WE_c),
  .MASK(MASK_c[15:0])
);


parameter INIT_0 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_1 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_2 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_3 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_4 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_5 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_6 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_7 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_8 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_9 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
parameter INIT_F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
// SB_RAM40_4K #(
//   .WRITE_MODE(0),
//   .READ_MODE(0),
//   .INIT_0(INIT_0),
//   .INIT_1(INIT_1),
//   .INIT_2(INIT_2),
//   .INIT_3(INIT_3),
//   .INIT_4(INIT_4),
//   .INIT_5(INIT_5),
//   .INIT_6(INIT_6),
//   .INIT_7(INIT_7),
//   .INIT_8(INIT_8),
//   .INIT_9(INIT_9),
//   .INIT_A(INIT_A),
//   .INIT_B(INIT_B),
//   .INIT_C(INIT_C),
//   .INIT_D(INIT_D),
//   .INIT_E(INIT_E),
//   .INIT_F(INIT_F)
// ) ram (
//   .RDATA(RDATA),
//   .RCLK (~clk),
//   .RCLKE(RCLKE),
//   .RE   (RE   ),
//   .RADDR(RADDR),
//   .WCLK (clk ),
//   .WCLKE(we   ),
//   .WE   (we   ),
//   .WADDR(WADDR),
//   .MASK (MASK ),
//   .WDATA({8{2'b11}})      // WDATA
// );

endmodule
