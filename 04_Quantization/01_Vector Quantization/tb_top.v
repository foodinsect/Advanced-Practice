`timescale 1ns / 1ps

module tb_top();

reg clk;
reg rstn;
reg start;
reg [31:0] din;
wire done;
wire [31:0] dout;

// Instantiate the top module
top top_module(
    .clk_i(clk),
    .rstn_i(rstn),
    .start_i(start),
    .din_i(din),
    .done_o(done),
    .dout_o(dout)
);

initial begin
    clk = 0;
    forever #5 clk <= ~clk;
end

initial begin
    rstn = 1;
    @(posedge clk) rstn <= 0;
    @(posedge clk) rstn <= 1;
end

initial begin
    start = 0;
    @(posedge rstn);
    @(posedge clk) start <= 1;
    @(posedge clk) start <= 0;
end

initial begin
    start = 0;
    @(posedge rstn) din <= 0;
    @(posedge start);
    @(posedge clk) din <= convert_to_fixed(-1.3125);
    @(posedge clk) din <= convert_to_fixed(4.75);
    @(posedge clk) din <= convert_to_fixed(1.0);
    @(posedge clk) din <= convert_to_fixed(0.5625);
    @(posedge clk) din <= convert_to_fixed(-4.625);
    @(posedge clk) din <= convert_to_fixed(3.5);
    @(posedge clk) din <= convert_to_fixed(-0.75);
    @(posedge clk) din <= convert_to_fixed(-2.6875);
    @(posedge clk) din <= 0;
end

always @(posedge clk) begin
    if (done) begin
        $stop;
    end
end
// Convert real value to Q16.16 fixed-point representation
function [31:0] convert_to_fixed;
    input real value;
    begin
        convert_to_fixed = value * 65536; // Multiply by 2^16 to convert to fixed-point
    end
endfunction

// Stop the simulation when done signal is asserted
always @(posedge clk) begin
    if (done) begin
        // Check the dout value against expected results here if needed
        $display("Test completed. dout = %d", dout);
        $stop;
    end
end

endmodule
