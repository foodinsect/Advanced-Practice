module top(
    input wire signed [31:0] din_1,
    input wire signed [31:0] din_2,
    input wire i_sel,

    output wire signed [31:0] dout
    );

    // Instance of the fixed-point operator
    fp_operator fp_op_instance (
        .din_1(din_1),
        .din_2(din_2),
        .i_sel(i_sel),
        .dout(dout)
    );

endmodule