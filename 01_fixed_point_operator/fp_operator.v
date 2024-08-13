module fp_operator #(
    parameter DATA_WIDTH = 32, // Width of the input data
    parameter FRACTIONAL_BITS = 16 // Number of fractional bits in the fixed-point representation
)(
    input wire signed [DATA_WIDTH-1:0] din_1,
    input wire signed [DATA_WIDTH-1:0] din_2,
    input wire i_sel,       // Selection signal for operation: 0 for addition, 1 for multiplication
    
    output reg signed [DATA_WIDTH-1:0] dout
);

    // Temporary variable to store the 64-bit extended result for fixed-point multiplication
    reg signed [2*DATA_WIDTH-1:0] mult_result;
    
    always @(*) begin
        case(i_sel)
            1'b0: dout = din_1 + din_2; // Fixed-point addition
            1'b1: begin
                // Extend to 2*DATA_WIDTH bits for multiplication
                mult_result = din_1 * din_2;
                
                // Adjust result by shifting right by the number of fractional bits (Q format)
                dout = mult_result >>> FRACTIONAL_BITS; // '>>>' is an arithmetic shift
            end
            default: dout = {DATA_WIDTH{1'b0}}; // Undefined operation (Prevents latch inference)
        endcase
    end

endmodule
