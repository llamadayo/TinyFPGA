`timescale 1ms/1ms

/// SPI
module simple_spi_m_bit_rw
#(
	parameter reg_width = 8
)
(
	// System side
	input rstn,
	input CLK,
	input t_start,
	input [reg_width-1:0] d_in,
	input [counter_width:0] t_size,
	output reg [reg_width-1:0] d_out,
	// SPI side
	input miso,
	output wire mosi,
	output wire spi_clk,
	output reg cs,

	input PIN_6,
	output PIN_20,
	output PIN_21,
	output PIN_14,
	output PIN_13,


	output USBPU  // USB pull-up resistor

);
  assign USBPU = 0;



	parameter counter_width = $clog2(reg_width);
	parameter reset = 0, idle = 1, load = 2, transact = 3, unload = 4;


	//=======================================================
	//  REG/WIRE declarations
	//=======================================================

	reg [reg_width-1:0] mosi_d;
	reg [reg_width-1:0] miso_d;
	reg [counter_width:0] count;
	reg [2:0] state;


	//=======================================================
	//  TinyFPGA Input and output
	//=======================================================

	assign PIN_6 = miso;

	assign PIN_21 = spi_clk;
	assign PIN_20 = mosi;
	assign PIN_14 = cs;

	assign PIN_13 = CLK;



	// begin state machine
	always @(state)
	begin
		case (state)
			reset:
			begin
				d_out <= 0;
				miso_d <= 0;
				mosi_d <= 0;
				count <= 0;
				cs <= 1;
			end
			idle:
			begin
				d_out <= d_out;
				miso_d <= 0;
				mosi_d <= 0;
				count <= 0;
				cs <= 1;
			end
			load:
			begin
				d_out <= d_out;
				miso_d <= 0;
				mosi_d <= d_in;
				count <= t_size;
				cs <= 0;
			end
			transact:
			begin
				cs <= 0;
			end
			unload:
			begin
				d_out <= miso_d;
				miso_d <= 0;
				mosi_d <= 0;
				count <= count;
				cs <= 0;
			end

			default:
				state = reset;
		endcase
	end

	always @(posedge CLK)
	begin
		if (!rstn)
			state = reset;
		else
			case (state)
				reset:
					if (t_start)
						state = load;
					else
						state = idle;
				idle:
					if (t_start)
						state = load;
				load:
					if (count != 0)
						state = transact;
					else
						state = reset;
				transact:
					if (count != 0)
						state = transact;
					else
						state = unload;
				unload:
					if (t_start)
						state = load;
					else
						state = idle;
			endcase
	end
	// end state machine

	// begin SPI logic

	assign mosi = ( ~cs ) ? mosi_d[reg_width-1] : 1'bz;
	assign spi_clk = ( state == transact ) ? CLK : 1'b0;

	// Shift Data
	always @(posedge spi_clk)
	begin
		if ( state == transact )
			miso_d <= {miso_d[reg_width-2:0], miso};
	end

	always @(negedge spi_clk)
	begin
		if ( state == transact )
		begin
			mosi_d <= {mosi_d[reg_width-2:0], 1'b0};
			count <= count-1;
		end
	end
	// end SPI logic

endmodule

module spi_test();

	parameter bits = 32;

	reg CLK;
	reg t_start;
	reg [bits-1:0] d_in;
	wire [bits-1:0] d_out;
	reg [$clog2(bits):0] t_size;
	wire cs;
	reg rstn;
	wire spi_clk;
	wire miso;
	wire mosi;


	simple_spi_m_bit_rw
	#(
		.reg_width(bits)
	) spi
	(
		.CLK(CLK),
		.t_start(t_start),
		.d_in(d_in),
		.d_out(d_out),
		.t_size(t_size),
		.cs(cs),
		.rstn(rstn),
		.spi_clk(spi_clk),
		.miso(miso),
		.mosi(mosi)
	);

	assign miso = mosi;
	always
		#2 CLK = !CLK;

	initial
	begin
		CLK = 0;
		t_start = 0;
		d_in = 0;
		rstn = 0;
		t_size = bits;
		#4;
		rstn = 1;
	end

	initial
	begin
		$dumpfile("simple_spi.lxt");
			$dumpvars(0,spi);
	end

	integer i;
	task transact_test;
		// input [bits-1:0] data;
		reg [31:0] data;
		data = {16{2'b10}};

		begin
			d_in = data[bits-1:0];
			#3 t_start = 1;
			#4 t_start = 0;
			for( i=0; i < bits; i=i+1)
			begin
				#4;
			end
			#16;
		end
	endtask

	initial
	begin
		#10;
		transact_test( {1'b0, 64'hDEADBEEF} );
		// $finish;
	end


	Pll_5mhz u3(
	    .clock_in(CLK),
	    .clock_out(spi_clk),
	    .locked(pll_locked)

	);

endmodule
