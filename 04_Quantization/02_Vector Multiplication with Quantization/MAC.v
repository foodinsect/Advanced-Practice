`timescale 1ns / 1ps

module MAC(
    input wire rstn_i,                    // Active low reset input
    input wire clk_i,                     // Clock input
    input wire dsp_enable_i,              // DSP enable signal
    input wire dsp_valid_i,               // DSP valid input signal
    input wire dsp_valid_o,               // DSP valid output signal (not used)
    input wire signed [7:0] dsp_input_i,  // DSP input data
    input wire signed [7:0] dsp_weight_i, // DSP weight data
    output wire valid_o_d,                // Delayed valid output signal
    output reg done_o,                    // Done signal
    output wire signed [31:0] dsp_output_o // DSP output data
);

    reg signed [30:0] partial_sum;        // Register to store partial sum
    reg signed [31:0] dsp_output;         // DSP output register
    wire signed [31:0] dsp_temp;          // Temporary wire for DSP output

    reg [1:0] dsp_valid_delay;            // Delay register for dsp_valid signal
    reg [1:0] valid_o_delay;              // Delay register for valid_o signal

    assign dsp_output_o = dsp_output;     // Assign DSP output
    assign dsp_valid_o = dsp_valid_delay[0]; // Assign delayed dsp_valid signal
    assign valid_o_d = dsp_valid_delay[1]; // Assign second delayed dsp_valid signal

    // Register partial sum
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            partial_sum <= 0;
        end else if (valid_o_d) begin
            partial_sum <= 0;
        end else begin
            partial_sum <= $signed({dsp_temp[31], dsp_temp[29:0]});
        end
    end

    // Delay the valid signals
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            dsp_valid_delay <= 0;
        end else begin
            valid_o_delay[0] <= dsp_valid_o;
            valid_o_delay[1] <= valid_o_delay[0];
            dsp_valid_delay[0] <= dsp_valid_i;
            dsp_valid_delay[1] <= dsp_valid_delay[0];
        end
    end

    // Output DSP result and handle done signal
    always @(posedge clk_i or negedge rstn_i) begin    
        if (!rstn_i) begin
            dsp_output <= 0;
            done_o <= 0;
        end else if (dsp_valid_o) begin
            dsp_output <= dsp_temp;
            done_o <= 1;
        end else begin
            dsp_output <= 0;
            done_o <= 0;
        end
    end 

    // Instantiate DSP block
    xbip_dsp48_macro_0 DSP_for_MAC (
        .CLK(clk_i),           // Clock input
        .CE(dsp_enable_i),     // DSP enable signal
        .A(dsp_input_i),       // Data input A
        .B(dsp_weight_i),      // Weight input B
        .C(partial_sum),       // Partial sum input C
        .P(dsp_temp)           // DSP output
    );

endmodule
