`timescale 1ns / 1ps

module MAC(
    input wire                  rstn_i,
    input wire                  clk_i,
    input wire                  dsp_enable_i,
    input wire                  dsp_valid_i,
    input wire                  clear_i,
    
    input wire signed   [7:0]   dsp_input_i,
    input wire signed   [7:0]   dsp_weight_i,

    output wire signed  [31:0]  dsp_output_o
);

reg signed  [30:0] partial_sum;    // Register to store the accumulated partial sum
reg signed  [31:0] dsp_output;     // Register to store the final DSP output
wire signed [31:0] dsp_temp;      // Wire to store the temporary DSP result

assign  dsp_output_o    = dsp_output;


// Update the DSP output
always @(posedge clk_i or negedge rstn_i) begin    
    if (!rstn_i) begin
        partial_sum <= 0;
        dsp_output  <= 0;
    end else if (dsp_valid_i) begin
        dsp_output  <= dsp_temp;     // Update output only if the delayed valid signal is high
    end else if (clear_i) begin
        partial_sum <= 0;
    end else begin
        partial_sum <= $signed({dsp_temp[31], dsp_temp[29:0]});
        dsp_output  <= 0;
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
