`timescale 1ns / 1ps

module PU1 #(
    parameter DATA_WIDTH = 8,       // Number of bits per element in x input matrix
    parameter WEIGHT_WIDTH = 8,     // Number of bits in w input
    parameter OUTPUT_WIDTH = 32,    // Number of bits per element in output matrix
    parameter MAC_NUM = 8           // Number of MACs: number of rows in x input matrix
)(
    input wire  rstn_i,             // Active low reset input
    input wire  clk_i,              // Clock input
    input wire  en_i,               // Enable input
    input wire  valid_i,            // Valid input
    input wire  pu_clear,           // Clear signal input for processing unit
    input wire  pu_done,            // Done signal input for processing unit
    input wire  signed [(DATA_WIDTH*MAC_NUM)-1:0] din_i,        // Data input (64 bits)
    input wire  signed [WEIGHT_WIDTH-1:0] win_i,                // Weight input (8 bits)

    output wire signed [(OUTPUT_WIDTH*MAC_NUM)-1:0] matmul_o    // Matrix multiplication output (256 bits)
);

    wire signed [OUTPUT_WIDTH-1:0] mac_outputs [MAC_NUM-1:0];       // MAC outputs
    wire signed [OUTPUT_WIDTH-1:0] mac_output_slices [MAC_NUM-1:0]; // Slices of MAC outputs
    reg signed  [OUTPUT_WIDTH-1:0] accumulators [MAC_NUM-1:0];      // Accumulators for each MAC
    reg signed  [(OUTPUT_WIDTH*MAC_NUM)-1:0] matmul;                // Final matrix multiplication result

    // Generate MAC instances
    genvar i;
    generate
        for (i = 0; i < MAC_NUM; i = i + 1) begin: mac_gen
            // Instantiate MAC module
            MAC my_mac (
                .clk_i(clk_i),                                           // Clock input
                .rstn_i(rstn_i),                                         // Active low reset input
                .dsp_enable_i(en_i),                                     // DSP enable input
                .dsp_valid_i(valid_i),                                   // DSP valid input
                .clear_i(en_i),                                          // Clear input
                
                .dsp_input_i(din_i[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),    // DSP data input
                .dsp_weight_i(win_i),                                    // DSP weight input

                .dsp_output_o(mac_outputs[i])                            // DSP output
            );
            
            // Extract the lower OUTPUT_WIDTH bits of each MAC output
            assign mac_output_slices[i] = mac_outputs[i][OUTPUT_WIDTH-1:0];

            // Update accumulators
            always @(posedge clk_i or negedge rstn_i) begin
                if (!rstn_i) begin
                    accumulators[i] <= 0;       // Reset accumulators on reset
                end else if (pu_clear) begin    // Clear accumulators on clear signal
                    accumulators[i] <= accumulators[i] + mac_output_slices[i];
                end
            end

            // Update matmul output
            always @(posedge clk_i or negedge rstn_i) begin
                if (!rstn_i) begin
                    matmul[i*OUTPUT_WIDTH +: OUTPUT_WIDTH] <= 0; // Reset matmul on reset
                end else if (pu_done) begin
                    matmul[i*OUTPUT_WIDTH +: OUTPUT_WIDTH] <= accumulators[i]; // Update matmul on done signal
                end
            end
        end
    endgenerate

    assign matmul_o = matmul; // Assign the final matmul output
endmodule
