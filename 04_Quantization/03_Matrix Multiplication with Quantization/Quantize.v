/*   

Quantize #(
    .WIDTH_INPUT(), 
    .WIDTH_OUTPUT(),
    .NUM_CALCULATE(), // Counter number
    .SCALIING_FACTOR(), // Input INTEGER Q[WIDTH_INPUT/2].[WIDTH_INPUT/2] format.
    .QUANTIZE_BIT() 
) quantize_inst (
    .clk_i(),
    .rstn_i(),
    .i_q_en(),
    .din_i(),
    .o_qout(),
    .o_qvalid(),
    .done_o()
);

*/

module Quantize
#(
    parameter WIDTH_INPUT       = 32, 
    parameter WIDTH_OUTPUT      = 8,
    parameter NUM_CALCULATE     = 8,
    parameter SCALIING_FACTOR   = 2408, 
    parameter QUANTIZE_BIT      = 8
)
(
    input wire                              clk_i,          // Clock input
    input wire                              rstn_i,         // Active low reset input
    input wire                              i_q_en,         // Quantize enable signal
    input wire signed   [WIDTH_INPUT-1:0]   din_i,          // Data input
    
    output wire signed  [WIDTH_OUTPUT-1:0]  o_qout,         // Quantized output
    output wire                             o_qvalid,       // Output valid signal
    output wire                             done_o          // Done signal
);

    localparam LOCAL_COUNTER = $clog2(NUM_CALCULATE); // Local counter size

    reg         [LOCAL_COUNTER-1:0] rCnt;               // Counter for NUM_CALCULATE cycles
    reg signed  [WIDTH_INPUT-1:0]   rScaled;            // Scaled result for quantization
    reg signed  [WIDTH_OUTPUT-1:0]  rClipped;           // Clipped result to WIDTH_OUTPUT bits
    reg     rEn_delay;                                  // Delayed version of i_q_en
    reg     q_valid;                                    // Signal indicating quantization is in progress
    reg     q_done;                                     // Signal indicating quantization is complete
    
    // Delay the enable signal
    always @(posedge clk_i) begin
        if (!rstn_i) begin
            rEn_delay <= 0;                       // Reset rEn_delay
        end else begin
            rEn_delay <= i_q_en;                  // Delay i_q_en signal
        end
    end
    
    // Scaling process
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rScaled = 0;                          // Reset rScaled
        end else if(din_i >= 0) begin
            rScaled = (din_i + SCALIING_FACTOR / 2) / SCALIING_FACTOR; // Rounding up for positive values
        end else begin
            rScaled = (din_i - SCALIING_FACTOR / 2) / SCALIING_FACTOR; // Rounding up for negative values
        end
    end
    
    // Control valid and done signals
    always @(posedge clk_i) begin
        if (!rstn_i) begin
            q_valid <= 0;                         // Reset q_valid
        end else if (rEn_delay) begin
            q_valid <= 1;                         // Set q_valid when rEn_delay is active
        end else if (rCnt == NUM_CALCULATE-2) begin
            q_done  <= 1;                          // Set q_done when rCnt is NUM_CALCULATE-2
        end else if (rCnt == NUM_CALCULATE-1) begin
            q_done  <= 0;                          // Reset q_done when rCnt is NUM_CALCULATE-1
            q_valid <= 0;                         // Reset q_valid when rCnt is NUM_CALCULATE-1
        end
    end
    
    // Counter for quantization process
    always @(posedge clk_i) begin
        if (!rstn_i) begin
            rCnt    = 0;                             // Reset rCnt
            q_done  = 0;                           // Reset q_done
        end else if(q_valid) begin
            rCnt = rCnt + 1;                      // Increment rCnt when q_valid is active
        end else begin
            rCnt = 0;                             // Reset rCnt when q_valid is not active
        end
    end

    // Clipping the scaled result
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            rClipped = 0;                         // Reset rClipped
        end else if (q_valid | rEn_delay) begin
            case(rScaled[QUANTIZE_BIT:QUANTIZE_BIT-1])
                2'b01:  begin
                    rClipped = {(QUANTIZE_BIT-1){1'b1}}; // Positive saturation
                end
                2'b10:  begin
                    rClipped = {1'b1,{(QUANTIZE_BIT-1){1'b0}}}; // Negative saturation
                end
                default:    begin
                    rClipped = rScaled[QUANTIZE_BIT-1:0]; // Normal clipping
                end
            endcase
        end else begin
            rClipped = 0;                         // Reset rClipped when q_valid and rEn_delay are not active
        end
    end    
    
    // Assign outputs
    assign o_qvalid = q_valid;                    // Assign q_valid to o_qvalid
    assign done_o   = q_done;                       // Assign q_done to done_o
    assign o_qout   = rClipped;                     // Assign rClipped to o_qout

endmodule
