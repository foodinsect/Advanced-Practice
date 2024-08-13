module top(
    input wire                  clk_i,          // Clock input
    input wire                  rstn_i,         // Active low reset input
    input wire                  start_i,        // Start signal
    input wire signed   [31:0]  vector_x_i,     // Input vector
    input wire signed   [7:0]   quant_w_i,      // Quantized weight input
    output wire                 done_o,         // Done signal
    output wire signed  [31:0]  dout_o          // Data output
);


wire quantize_done;                        // Signal indicating quantization is done
wire dequantize_done;                      // Signal indicating dequantization is done

wire signed [7:0] quantized_data;          // Quantized data (8-bit signed)
wire signed [31:0] mac_out;                // MAC output
wire valid;                                // Valid signal
wire mac_done;                             // Signal indicating MAC operation is done

// Instantiate the Quantize module
Quantize quantize_module(
    .clk_i(clk_i),                         // Clock input
    .rstn_i(rstn_i),                       // Active low reset input
    .i_q_en(start_i),                      // Enable signal for quantization
    .din_i(vector_x_i),                    // Data input
    .o_qvalid(valid),                      // Output valid signal
    .done_o(quantize_done),                // Done signal for quantization
    .o_qout(quantized_data)                // Quantized data output
);

// Instantiate the MAC module
MAC MAC(
    .clk_i(clk_i),                         // Clock input
    .rstn_i(rstn_i),                       // Active low reset input
    .dsp_enable_i(valid),                  // DSP enable signal
    .dsp_valid_i(quantize_done),           // DSP valid input signal
    .dsp_input_i(quantized_data),          // DSP input data
    .dsp_weight_i(quant_w_i),              // DSP weight data
    .done_o(mac_done),                     // Done signal for MAC operation
    .dsp_output_o(mac_out)                 // DSP output data
);

// Instantiate the Dequantize module
Dequantize dequantize_module(
    .clk_i(clk_i),                         // Clock input
    .rstn_i(rstn_i),                       // Active low reset input
    .din_i(mac_out),                       // MAC output data
    .valid_i(mac_done),                    // Valid input signal
    .done_o(dequantize_done),              // Done signal for dequantization
    .dout_o(dout_o)                        // Dequantized data output
);

// Assign done signal based on dequantization done signal
assign done_o = dequantize_done ? 1 : 0;

endmodule
