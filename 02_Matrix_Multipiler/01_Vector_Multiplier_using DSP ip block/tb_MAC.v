`timescale 1ns / 1ps
module tb_MAC();
	reg					clk;
	reg 				rstn;
	reg 				dsp_enable;
	reg signed 	[7:0] 	dsp_input;
	reg signed 	[7:0] 	dsp_weight;
	reg 				dsp_valid_i;
	wire 				dsp_valid_o;
	wire signed [31:0] 	dsp_output;
	
	// make clock (frequency : 100MHz)
	initial begin
		clk =0;
		forever
			#5 clk = ~clk;
	end
		
	//reset all system
	initial begin
			rstn = 1;
		#20 rstn = 0;
			dsp_enable = 0;	dsp_input = 0; dsp_weight = 0;
			dsp_valid_i = 0;
		#10 rstn = 1;
	end
	
	initial begin
		#40
		wait(rstn);
		#15 dsp_enable = 1; dsp_input = 1; dsp_weight = -1;
		#10 dsp_enable = 1; dsp_input = 2; dsp_weight = -1;
		#10 dsp_enable = 1; dsp_input = 3; dsp_weight = -1;
		#10 dsp_enable = 1; dsp_input = 4; dsp_weight = -1;
		#10 dsp_enable = 1; dsp_input = 5; dsp_weight = -1;
		#10 dsp_enable = 1; dsp_input = 6; dsp_weight = -1;
		#10 dsp_enable = 1; dsp_input = 7; dsp_weight = -1;
		#10 dsp_enable = 1; dsp_input = 8; dsp_weight = -1;
		dsp_valid_i = 1;
		#10 dsp_enable = 0; dsp_input = 0; dsp_weight = 0;
		dsp_valid_i = 0;
		#10 dsp_enable = 0; dsp_input = 0; dsp_weight = 0;
	end
	
	initial begin
		#100
			wait(dsp_weight == 0);
		#20
			$stop();
	end
	
	MAC dut(
		.clk_i(clk),
		.rstn_i(rstn),
		.dsp_enable_i(dsp_enable),
		.dsp_valid_i(dsp_valid_i),
		.dsp_input_i(dsp_input),
		.dsp_weight_i(dsp_weight),
		
		.dsp_valid_o(dsp_valid_o),
		.dsp_output_o(dsp_output)
	);
	
endmodule