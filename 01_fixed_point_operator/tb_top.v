`timescale 1ns / 1ps

module tb_top();

reg signed [31:0] din_1;
reg signed [31:0] din_2;
reg i_sel;
wire signed [31:0] dout;

// Instantiate the module under test
top uut (
    .din_1(din_1), 
    .din_2(din_2), 
    .i_sel(i_sel), 
    .dout(dout)
);

// Function to generate random values
function [31:0] random_value;
    input [31:0] min;
    input [31:0] max;
    begin
        random_value = min + ($random % (max - min + 1));
    end
endfunction

// Task to check the result and print the error
task check_result;
    input signed [31:0] expected;
    reg signed [31:0] error;
    begin
        error = dout > expected ? dout - expected : expected - dout;
        $display("Time = %d, i_sel = %b, din_1 = %h, din_2 = %h, dout = %h, Expected = %h, Error = %h", 
                  $time, i_sel, din_1, din_2, dout, expected, error);
    end
endtask

integer i;
initial begin
    // Monitor the values
    $monitor("Time = %d, i_sel = %b, din_1 = %h, din_2 = %h, dout = %h", 
              $time, i_sel, din_1, din_2, dout);

    for (i = 0; i < 8; i = i + 1) begin
        // Generate random values
        din_1 = random_value(-32'h00008000, 32'h00007FFF); // Small positive and negative values
        din_2 = random_value(-32'h00008000, 32'h00007FFF); // Small positive and negative values
        i_sel = i % 2; // 0 for addition, 1 for multiplication

        #10; // Wait time

        // Check and print the result
        if (i_sel == 0) begin
            // Expected value for addition
            check_result(din_1 + din_2);
        end else begin
            // Expected value for multiplication (Q16.16 multiplication)
            check_result((din_1 * din_2) >>> 16);
        end
    end

    // End the simulation
    $finish;
end

endmodule