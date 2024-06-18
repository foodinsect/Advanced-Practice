module Dequantize(
    input wire                  clk_i,          // Clock input
    input wire                  rstn_i,         // Active low reset input
    input wire signed   [7:0]   din_i,          // Data input (8-bit signed)
    input wire                  valid_i,        // Input valid signal
    output wire                 valid_o,        // Output valid signal
    output wire                 done_o,         // Done signal
    output wire signed  [31:0]  dout_o          // Dequantized output (32-bit signed)
);

    reg         [2:0]   rCnt;               // Counter for 8 cycles -> done
    reg signed  [31:0]  rScaled;            // Scaled result for dequantization

    reg     q_valid;                        // Signal indicating dequantization is in progress
    reg     q_done;                         // Signal indicating dequantization is complete

    // Scaling process
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rScaled <= 0;
        end else begin
            rScaled <= din_i * 2408;      // Dequantization scaling
        end
    end
    
    // Control valid and done signals
    always @(posedge clk_i) begin
        if (!rstn_i) begin
            q_valid <= 0;
        end else if (valid_i) begin
            q_valid <= 1;
        end
        if (rCnt == 6) begin
            q_done  <= 1;
        end else if (rCnt == 7) begin
            q_done  <= 0;
            q_valid <= 0;
        end 
    end
    
    // Counter for dequantization process
    always @(posedge clk_i) begin
        if (!rstn_i) begin
            rCnt    <= 0;
            q_done  <= 0;
        end else if (q_valid) begin
            rCnt <= rCnt + 1;
        end else begin
            rCnt <= 0;
        end
    end
    
    // Assign outputs
    assign done_o   = q_done;
    assign valid_o  = q_valid;
    assign dout_o   = rScaled;

endmodule
