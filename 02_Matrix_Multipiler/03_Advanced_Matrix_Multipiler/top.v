`timescale 1ns / 1ps

module top(
    input wire  clk_i,
    input wire  rstn_i,
    input wire  en_i,
    input wire  valid_i,
    input wire  [63:0]  din1_i,
    input wire  [7:0]   din2_i,
    input wire  [7:0]   din3_i,
    output wire done_o,
    output wire [255:0] matmul_o
    );
    
    wire [63:0] matmul_temp_o;
    wire        done_1;
   
    // Register array to store 8 sets of 64-bit data
    (* ram_style = "distributed" *) reg [63:0] result1[7:0];
    reg [2:0]   index; // Index to track current position in result1 array
    reg         index_full;  // Flag to indicate when result1 array is full
    reg [63:0]  temp; // Temporary register to hold data from result1 array
    reg [3:0]   i;     // Index for accessing result1 array during transfer to temp
    
    // Always block to manage result1 array and temp register
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            // Reset all registers
            result1[0] <= 0;
            result1[1] <= 0;
            result1[2] <= 0;
            result1[3] <= 0;
            result1[4] <= 0;
            result1[5] <= 0;
            result1[6] <= 0;
            result1[7] <= 0;
            i <= 0;
            temp <= 0;
        end else if (index_full && i < 8 ) begin
            // Transfer data from result1 array to temp register
            temp <= result1[i][63:0];
            i <= i + 1;
        end else if (i == 8) begin
            // Clear temp register after all data is transferred
            temp <= 0;
        end
    end
    
    // Always block to update index and index_full flag
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            index <= 0;
            index_full <= 0;
        end else if (done_1 && !index_full) begin
            // Store matmul_temp_o in result1 array and update index
            result1[index] <= matmul_temp_o;
            if (index == 7) begin
                index_full <= 1;
            end else begin
                index <= index + 1;
            end        
        end
    end
    
    // Instantiate the first matrix multiplier module
    Matrix_Multiplier #(
        .DATA_WIDTH(8),
        .WEIGHT_WIDTH(8),
        .OUTPUT_WIDTH(8),
        .maccnt(8) // Number of MAC units
    ) matmul1 (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .en_i(en_i),
        .valid_i(valid_i),
        .din_i(din1_i),
        .win_i(din2_i),
        .done_o(done_1),
        .matmul_o(matmul_temp_o)
    );
    
    // Instantiate the second matrix multiplier module
    Matrix_Multiplier #(
        .DATA_WIDTH(8),
        .WEIGHT_WIDTH(8),
        .OUTPUT_WIDTH(32),
        .maccnt(8)
    ) matmul2 (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .en_i(en_i),
        .valid_i(valid_i),
        .din_i(temp), // Input from temp register
        .win_i(din3_i),
        .done_o(done_o),
        .matmul_o(matmul_o)
    );
    
endmodule
