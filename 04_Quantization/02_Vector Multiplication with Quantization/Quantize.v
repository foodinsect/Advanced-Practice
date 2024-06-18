module Quantize(
    input wire                  clk_i,       // Clock input
    input wire                  rstn_i,      // Active low reset input
    input wire                  i_q_en,      // Quantize enable signal
    input wire signed   [31:0]  din_i,       // Data input
    
    output wire signed  [7:0]   o_qout,      // Quantized output
    output wire                 o_qvalid,    // Output valid signal
    output wire                 done_o       // Done signal
);
    
    reg         [2:0]   rCnt;               // Counter for 8 cycles -> done
    reg signed  [31:0]  rScaled;            // Scaled result for quantization
    reg signed  [7:0]   rClipped;           // Clipped result to 8-bit integer
    
    reg     rEn_delay;                      // Delayed version of i_q_en

    reg     q_valid;                        // Signal indicating quantization is in progress
    reg     q_done;                         // Signal indicating quantization is complete

    // Delay the enable signal
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rEn_delay <= 0;
        end else begin
            rEn_delay <= i_q_en;
        end
    end
    
    // Scaling process
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rScaled <= 0;
        end else if (din_i >= 0) begin
            rScaled <= (din_i + 1204) / 2408;  // Round up for positive values
        end else begin
            rScaled <= (din_i - 1204) / 2408;  // Round up for negative values
        end
    end
    
    // Clipping the scaled result
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rClipped <= 0;
        end else if (q_valid || rEn_delay) begin
            case (rScaled[8:7])
                2'b01: rClipped     <= 8'h7f;  // Positive saturation
                2'b10: rClipped     <= 8'h80;  // Negative saturation
                default: rClipped   <= rScaled[7:0];  // Normal clipping
            endcase
        end else begin
            rClipped <= 0;
        end
    end    
    
    // Control valid and done signals
    always @(posedge clk_i) begin
        if (!rstn_i) begin
            q_valid <= 0;
        end else if (rEn_delay) begin
            q_valid <= 1;
        end else if (rCnt == 6) begin
            q_done  <= 1;
        end else if (rCnt == 7) begin
            q_done  <= 0;
            q_valid <= 0;
        end
    end
    
    // Counter for quantization process
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
    assign o_qvalid = q_valid;
    assign done_o   = q_done;
    assign o_qout   = rClipped;
    
endmodule
