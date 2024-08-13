`timescale 1ns / 1ps

module tb_top();

reg clk;
reg rstn;
reg start;
reg [31:0] din;
reg [31:0] win;
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
    @(posedge clk) din <= convert_to_fixed(4.75);       win <= {-8'd96,8'd54,8'd30,8'd30}; //8'd71,8'd9,8'd23,-8'd89,-8'd93
    @(posedge clk) din <= convert_to_fixed(1.0);        win <= {8'd104,8'd9,-8'd8,-8'd110}; //-8'd109,-8'd28,-8'd87,8'd29,-8'd9
    @(posedge clk) din <= convert_to_fixed(0.5625);     win <= {8'd2,-8'd127,-8'd104,-8'd9}; //8'd107,-8'd53,8'd41,8'd36,-8'd42
    @(posedge clk) din <= convert_to_fixed(-4.625);     win <= {8'd71,-8'd109,8'd107,8'd38};
    @(posedge clk) din <= convert_to_fixed(3.5);        win <= {8'd9,-8'd28,-8'd53,-8'd36};
    @(posedge clk) din <= convert_to_fixed(-0.75);      win <= {8'd23,-8'd87,8'd41,-8'd31};
    @(posedge clk) din <= convert_to_fixed(-2.6875);    win <= {-8'd89,8'd29,8'd36,-8'd121};
    @(posedge clk) din <= 0; win <= {-8'd93,-8'd9,8'd42,-8'd86};
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
