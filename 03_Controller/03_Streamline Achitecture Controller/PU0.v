`timescale 1ns / 1ps

module PU0 #(
    parameter DATA_WIDTH = 8,       // Number of bits per element in x input matrix
    parameter WEIGHT_WIDTH = 8,     // Number of bits in w input
    parameter OUTPUT_WIDTH = 32,    // Number of bits per element in output matrix
    parameter MAC_NUM = 8           // Number of MACs: number of rows in x input matrix
)(
    input wire  rstn_i,
    input wire  clk_i,
    input wire  en_i,
    input wire  valid_i,
    input wire  pu_clear,
    input wire  pu_done,
    input wire  signed [(DATA_WIDTH*MAC_NUM)-1:0]    din_i,     // MAC_CNT * 8 = 64 bits
    input wire  signed [WEIGHT_WIDTH-1:0]            win_i,     // w input bit width = 8 bits

    output wire signed [(OUTPUT_WIDTH*MAC_NUM)-1:0]  matmul_o   // 32 bits * MAC_CNT = 256 bits
);
    
    // Intermediate wires for MAC outputs
    wire signed [OUTPUT_WIDTH-1:0] mac_outputs [MAC_NUM-1:0];
    wire signed [OUTPUT_WIDTH-1:0] mac_output_slices [MAC_NUM-1:0];

    // Generate MAC instances
    genvar i;
    generate
        for (i = 0; i < MAC_NUM; i = i + 1) begin: mac_gen
            // Instantiate MAC module
            MAC my_mac (
                .clk_i(clk_i),
                .rstn_i(rstn_i),
                .dsp_enable_i(en_i),
                .dsp_valid_i(valid_i),
                .clear_i(pu_clear),
                
                .dsp_input_i(din_i[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),
                .dsp_weight_i(win_i),

                .dsp_output_o(mac_outputs[i])
            );
            
            // Extract the lower OUTPUT_WIDTH bits of each MAC output
            assign mac_output_slices[i] = mac_outputs[i][OUTPUT_WIDTH-1:0];
            // Concatenate the sliced outputs into the final matmul_o output
            assign matmul_o[i*OUTPUT_WIDTH +: OUTPUT_WIDTH] = mac_output_slices[i];
        end
    endgenerate

endmodule
