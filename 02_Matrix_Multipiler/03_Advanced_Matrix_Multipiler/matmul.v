`timescale 1ns / 1ps

module matrix_multypiler #(
    parameter DATA_WIDTH = 8,
    parameter WEIGHT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 8,
    parameter MAC_NUM = 8
)(
    input wire rstn_i,
    input wire clk_i,
    input wire en_i,
    input wire clear,
    input wire valid_i,
    input wire [(DATA_WIDTH*MAC_NUM)-1:0] din_i, // Number of MACs * DATA_WIDTH = 64 bits
    input wire [WEIGHT_WIDTH-1:0] win_i,        // Width of weight input = 8 bits
    
    output wire done_o,
    output wire [(OUTPUT_WIDTH*MAC_NUM)-1:0] matmul_o    // OUTPUT_WIDTH * Number of MACs = 256 bits
);
    
    wire mac_done; // Wire for done signal from MACs
    reg done;      // Register to hold the done signal
    
    assign done_o = done; // Assign done signal to output
    
    // Update the done signal on the rising edge of the clock
    always @ (posedge clk_i) begin
        if (~rstn_i) begin
            done <= 0; // Reset done signal
        end else begin
            done <= mac_done; // Set done signal based on mac_done
        end
    end
    
    wire [OUTPUT_WIDTH-1:0] mac_outputs [MAC_NUM-1:0]; // Array to hold outputs from each MAC
    wire [OUTPUT_WIDTH-1:0] mac_output_slices [MAC_NUM-1:0]; // Sliced outputs for each MAC

    // Initialize each element in the array
    genvar i;
    generate
        for (i = 0; i < MAC_NUM; i = i + 1) begin: mac_gen
            // Instantiate the MAC module
            MAC my_mac (
                .clk_i(clk_i),
                .rstn_i(rstn_i),
                .clear_i(clear),
                .dsp_enable_i(en_i),
                .dsp_valid_i(valid_i),
                .dsp_valid_o(mac_done),
                .dsp_input_i(din_i[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),
                .dsp_weight_i(win_i),
                .dsp_output_o(mac_outputs[i])
            );
            // Extract the lower OUTPUT_WIDTH bits from each MAC output
            assign mac_output_slices[i] = mac_outputs[i][OUTPUT_WIDTH-1:0];
            // Assign the sliced output to the corresponding portion of matmul_o
            assign matmul_o[i*OUTPUT_WIDTH +: OUTPUT_WIDTH] = mac_output_slices[i];
        end
    endgenerate

endmodule
