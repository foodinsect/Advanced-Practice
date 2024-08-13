`timescale 1ns / 1ps

module top(
    input wire clk_i,
    input wire rstn_i,
    input wire en_i,
    input wire clear,
    input wire valid_i,
    input wire rd_temp_en,
    input wire wr_temp_en,
    input wire [1:0] mode,
    input wire [2:0] rd_temp_addr,
    input wire [2:0] wr_temp_addr,
    input wire [63:0] din1_i,
    input wire [7:0] din2_i,
    input wire [7:0] din3_i,
    output wire done_o,
    output wire [255:0] matmul_o
    );
    
    reg [63:0] input_data;
    reg [7:0] input_weight;
    wire [63:0] temp_o;
    wire [63:0] temp_bram_o;
    wire done;
    reg done_1,done_2;
   

    // Instantiate the first matrix multiplier module
    matrix_multypiler #(
        .DATA_WIDTH(8),
        .WEIGHT_WIDTH(8),
        .OUTPUT_WIDTH(8),
        .MAC_NUM(8) // Number of MAC units
    ) matmul1 (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .en_i(en_i),
        .clear(clear),
        .valid_i(valid_i),
        .din_i(din1_i),
        .win_i(din2_i),
        .done_o(done),
        .matmul_o(temp_o)
    );
    
    temp_bram #(
        .MAC_NUM(8),
        .DATA_WIDTH(64)
    ) temp_bram(
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .rd_temp_en(rd_temp_en),
        .wr_temp_en(wr_temp_en),
        .rd_temp_addr(rd_temp_addr),
        .wr_temp_addr(wr_temp_addr),
        .data_i(temp_o),
        .data_o(temp_bram_o)
    );
    
    // Instantiate the first matrix multiplier module
    matrix_multypiler #(
        .DATA_WIDTH(8),
        .WEIGHT_WIDTH(8),
        .OUTPUT_WIDTH(32),
        .MAC_NUM(8) // Number of MAC units
    ) matmul2 (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .en_i(en_i),
        .clear(clear),
        .valid_i(valid_i),
        .din_i(temp_bram_o),
        .win_i(din3_i),
        .done_o(done),
        .matmul_o(matmul_o)
    );
   
    
endmodule
