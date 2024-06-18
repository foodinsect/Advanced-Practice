module top(
    input wire                  clk_i,          // Clock input
    input wire                  rstn_i,         // Active low reset input
    input wire                  start_i,        // Start signal
    input wire signed   [31:0]  vector_x_i,     // Input vector
    input wire signed   [31:0]  quant_w_i,      // Quantized weight input
    output wire                 done_o,         // Done signal
    output wire signed  [31:0]  dout_o          // Data output
);

wire quantize_done;                       // Signal indicating quantization is done
wire dequantize_done;                     // Signal indicating dequantization is done

wire signed [7:0]   quantized_data;         // Quantized data (8-bit signed)
wire signed [31:0]  mac_out [3:0];          // MAC output for each instance
reg signed  [31:0]  mac_o [3:0];            // Register to store MAC output
wire valid;                               // Valid signal from quantize module
wire mac_done;                            // Signal indicating MAC operation is done
reg q_valid;                              // Signal indicating dequantization is in progress
reg [31:0] q_in;                          // Input to dequantize module

// Instantiate the Quantize module
Quantize #(
    .WIDTH_INPUT(32), 
    .WIDTH_OUTPUT(8),
    .NUM_CALCULATE(8),                    // Counter number
    .SCALIING_FACTOR(2408),               // Input INTEGER Q[WIDTH_INPUT/2].[WIDTH_INPUT/2] format
    .QUANTIZE_BIT(8) 
) quantize_inst (
    .clk_i(clk_i),                        // Clock input
    .rstn_i(rstn_i),                      // Active low reset input
    .i_q_en(start_i),                     // Enable signal for quantization
    .din_i(vector_x_i),                   // Data input
    .o_qout(quantized_data),              // Quantized data output
    .o_qvalid(valid),                     // Output valid signal
    .done_o(quantize_done)                // Done signal for quantization
);

// Generate 4 instances of the MAC module
genvar i;
generate 
    for (i = 0; i < 4; i = i + 1) begin : mac_gen
        MAC mymac(
            .clk_i(clk_i),                // Clock input
            .rstn_i(rstn_i),              // Active low reset input
            .dsp_enable_i(valid),         // DSP enable signal
            .dsp_valid_i(quantize_done),  // DSP valid input signal
            .dsp_input_i(quantized_data), // DSP input data
            .dsp_weight_i(quant_w_i[32-1-8*i:32-8*(i+1)]), // DSP weight data
            .done_o(mac_done),            // Done signal for MAC operation
            .dsp_output_o(mac_out[i])     // DSP output data
        );
        always @(posedge clk_i or negedge rstn_i) begin
            if (!rstn_i) begin
                mac_o[i] <= 0;            // Reset MAC output
            end else if (mac_done) begin
                mac_o[i] <= mac_out[i];   // Store MAC output
            end
        end
    end
endgenerate

// Instantiate the Dequantize module
Dequantize #(
    .WIDTH_INPUT(32),                     // Q16.16 fixed-point value 
    .WIDTH_OUTPUT(32), 
    .SCALIING_FACTOR_X(2408), 
    .SCALIING_FACTOR_Y(134),
    .NUM_COUNTER_BIT(3),                  // Size of counter, 2^(NUM_COUNTER_BIT) > NUM_CALCULATE
    .NUM_CALCULATE(4) 
) dequantize_inst (
    .clk_i(clk_i),                        // Clock input
    .rstn_i(rstn_i),                      // Active low reset input
    .din_i(q_in),                         // Data input
    .valid_i(q_valid),                    // Input valid signal
    .done_o(dequantize_done),             // Done signal for dequantization
    .dout_o(dout_o)                       // Dequantized data output
);

reg [1:0] qCnt;                           // Counter for dequantization process

// Counter for dequantization process
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        qCnt <= 0;                        // Reset qCnt
    end else if (q_valid) begin
        qCnt <= qCnt + 1;                 // Increment qCnt when q_valid is active
    end
end

// Control q_valid signal
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        q_valid <= 0;                     // Reset q_valid
    end else if (mac_done) begin
        q_valid <= 1;                     // Set q_valid when mac_done is active
    end else if (qCnt == 3) begin
        q_valid <= 0;                     // Reset q_valid when qCnt reaches 3
    end
end

// Input to dequantize module
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        q_in <= 0;                        // Reset q_in
    end else if (q_valid) begin
        q_in <= mac_o[qCnt];              // Provide MAC output to dequantize module
    end else begin
        q_in <= 0;                        // Reset q_in when q_valid is not active
    end
end

assign done_o = dequantize_done ? 1 : 0;  // Assign done_o based on dequantize_done signal

endmodule
