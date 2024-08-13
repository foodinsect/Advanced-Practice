/*

Dequantize #(
    .WIDTH_INPUT(), // Q16.16 fixed-point value 
    .WIDTH_OUTPUT(), 
    .SCALIING_FACTOR_X(), 
    .SCALIING_FACTOR_Y(),
    .NUM_COUNTER_BIT(), // Size of counter,  2^(NUM_COUNTER_BIT) > NUM_CALCULATE
    .NUM_CALCULATE() 
) dequantize_inst (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .din_i(din_i),
    .valid_i(valid_i),
    .valid_o(valid_o),
    .done_o(done_o),
    .dout_o(dout_o)
);

*/

module Dequantize
#(
    parameter WIDTH_INPUT       = 32,
    parameter WIDTH_OUTPUT      = 32,
    parameter SCALIING_FACTOR_X = 2408,  // Q16.16 representation of 0.03675
    parameter SCALIING_FACTOR_Y = 134,   // Q16.16 representation of 0.002045
    parameter NUM_COUNTER_BIT   = 3,
    parameter NUM_CALCULATE     = 4
)
(
    input wire  clk_i,                              // Clock input
    input wire  rstn_i,                             // Active low reset input
    input wire signed   [WIDTH_INPUT-1:0]   din_i,  // Data input
    input wire  valid_i,                            // Input valid signal
    output wire valid_o,                            // Output valid signal
    output wire done_o,                             // Done signal
    output wire signed  [WIDTH_OUTPUT-1:0]  dout_o  // Dequantized output
);

    reg         [NUM_COUNTER_BIT-1:0]   rCnt;           // Counter for NUM_CALCULATE cycles
    reg signed  [WIDTH_OUTPUT-1:0]      rScaled;        // Scaled result for dequantization
    reg         q_done;                                 // Signal indicating dequantization is complete
    reg [1:0]   valid_delay;                            // Delay register for valid signal
    
    // Scaling process
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rScaled <= 0;
        end else begin
            rScaled <= din_i * SCALIING_FACTOR_X * SCALIING_FACTOR_Y; 
        end
    end

    // Control done signal
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            q_done <= 0;
        end else if (rCnt == NUM_CALCULATE-2) begin
            q_done <= 1;
        end else if (rCnt == NUM_CALCULATE-1) begin
            valid_delay[1] <= 0;
            q_done <= 0;
        end
    end

    // Counter for dequantization process
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rCnt <= 0;
        end else if (valid_o) begin
            rCnt <= rCnt + 1;
        end
    end
    
    // Delay valid signal
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            valid_delay <= 0;
        end else begin
            valid_delay[0] <= valid_i;
            valid_delay[1] <= valid_delay[0];
        end
    end

    // Assign outputs
    assign done_o = q_done;
    assign valid_o = valid_delay[1];
    assign dout_o = rScaled;

endmodule
