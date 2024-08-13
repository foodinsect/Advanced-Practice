`timescale 1ns / 1ps

module tb_top();

reg clk;
reg rstn;
reg start;
reg [31:0] din;
reg [7:0] win;
wire done;
wire [31:0] dout;

// Instantiate the top module
top top_module(
    .clk_i(clk),
    .rstn_i(rstn),
    .start_i(start),
    .vector_x_i(din),
    .quant_w_i(win),
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
    @(posedge rstn) din <= 0 ; win <= 0;
    @(posedge start);
    @(posedge clk) din <= convert_to_fixed(-1.3125); 
    @(posedge clk) din <= convert_to_fixed(4.75);       win <= 8'd35;
    @(posedge clk) din <= convert_to_fixed(1.0);        win <= 8'd7;
    @(posedge clk) din <= convert_to_fixed(0.5625);     win <= - 8'd8;
    @(posedge clk) din <= convert_to_fixed(-4.625);     win <= 8'd10;
    @(posedge clk) din <= convert_to_fixed(3.5);        win <= - 8'd18;
    @(posedge clk) din <= convert_to_fixed(-0.75);      win <= - 8'd2;
    @(posedge clk) din <= convert_to_fixed(-2.6875);    win <= 8'd10;
    @(posedge clk) din <= 0;                            win <= 8'd4;
    @(posedge clk) win <= 0;
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
