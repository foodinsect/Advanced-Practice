`timescale 1ns / 1ps

module MAC(
    input wire                  rstn_i,
    input wire                  clk_i,
    input wire                  dsp_enable_i,
    input wire                  dsp_valid_i,
    input wire signed   [7:0]   dsp_input_i,
    input wire signed   [7:0]   dsp_weight_i,

    output wire signed  [31:0]  dsp_output_o,
    output wire                 dsp_valid_o
);

reg signed  [30:0] partial_sum;    // Register to store the accumulated partial sum
reg signed  [31:0] dsp_output;     // Register to store the final DSP output
wire signed [31:0] dsp_temp;      // Wire to store the temporary DSP result

reg [1:0] dsp_valid_delay;        // Shift register for valid signal delay

assign dsp_output_o = dsp_output;
assign dsp_valid_o = dsp_valid_delay[1];

// Store the DSP input signal in the register
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        partial_sum <= 0;
    end else begin
        partial_sum <= $signed({dsp_temp[31], dsp_temp[29:0]});
    end 
end

// Shift register for the valid signal
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        dsp_valid_delay <= 2'b0;
    end else begin
        dsp_valid_delay[0] <= dsp_valid_i;
        dsp_valid_delay[1] <= dsp_valid_delay[0];
    end
end
    
// Update the DSP output
always @(posedge clk_i or negedge rstn_i) begin    
    if (!rstn_i) begin
        dsp_output <= 0;
    end else if (dsp_valid_delay[1]) begin
        dsp_output <= dsp_temp;     // Update output only if the delayed valid signal is high
    end else begin
        dsp_output <= 0;
    end
end 

// DSP block instantiation
xbip_dsp48_macro_0 DSP_for_MAC (
    .CLK(clk_i),             // Clock input
    .CE(dsp_enable_i),       // DSP enable signal input
    .A(dsp_input_i),         // Data input A
    .B(dsp_weight_i),        // Weight input B
    .C(partial_sum),         // Partial sum input C
    .P(dsp_temp)             // DSP output
);

endmodule
