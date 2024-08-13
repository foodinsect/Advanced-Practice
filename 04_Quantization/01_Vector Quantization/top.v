module top(
    input wire clk_i,                     // Clock input
    input wire rstn_i,                    // Active low reset input
    input wire start_i,                   // Start signal
    input wire signed [31:0] din_i,       // Data input
    output wire done_o,                   // Done signal
    output wire signed [31:0] dout_o      // Data output
);

wire quantize_done;                      // Signal indicating quantization is done
wire dequantize_done;                    // Signal indicating dequantization is done

wire signed [7:0] quantized_data;        // Quantized data (8-bit signed)
wire valid;                              // Valid signal

// Instantiate the Quantize module
Quantize quantize_module(
    .clk_i(clk_i),                        // Clock input
    .rstn_i(rstn_i),                      // Active low reset input
    .i_q_en(start_i),                     // Enable signal for quantization
    .din_i(din_i),                        // Data input
    .o_qvalid(valid),                     // Output valid signal
    .done_o(quantize_done),               // Done signal for quantization
    .o_qout(quantized_data)               // Quantized data output
);

// Instantiate the Dequantize module
Dequantize dequantize_module(
    .clk_i(clk_i),                        // Clock input
    .rstn_i(rstn_i),                      // Active low reset input
    .din_i(quantized_data),               // Quantized data input
    .valid_i(valid),                      // Valid input signal
    .done_o(dequantize_done),             // Done signal for dequantization
    .dout_o(dout_o)                       // Dequantized data output
);

assign done_o = dequantize_done ? 1 : 0; // Assign done signal based on dequantization done

endmodule
