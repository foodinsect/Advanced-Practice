`timescale 1ns / 1ps
module tb_matmul();
    reg clk;
    reg rstn;
    reg valid_i;
    reg en;
    reg [63:0] din; // 8bit x 8
    reg [7:0] win;

    wire done_o;
    wire [63:0] matmul;

    // Generate clock signal with a period of 10 ns (100 MHz)
    initial begin
        clk = 0;
        forever
            #5 clk = ~clk;
    end

    // Initialize and reset the system
    initial begin
        rstn = 1;
        #20 rstn = 0;
        en = 0; valid_i = 0; din = 0; win = 0;
        #10 rstn = 1;
    end

    // Apply input stimuli
    initial begin
        #40
        wait(rstn);

        // Column 1
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        // Column 2
        #10 en = 1; din = {8'h02, 8'h08, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h01, 8'h05, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h03, 8'h04, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h01, 8'h04, 8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        // Column 3
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h01, 8'h02, 8'h05, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h09, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h04, 8'h02, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        // Column 4
        #10 en = 1; din = {8'h04, 8'h09, 8'h04, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        // Column 5
        #10 en = 1; din = {8'h05, 8'h03, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        // Column 6
        #10 en = 1; din = {8'h06, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        // Column 7
        #10 en = 1; din = {8'h07, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        // Column 8
        #10 en = 1; din = {8'h08, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
        #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
        #10 en = 1; din = {8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06}; win = 8'h03;
        #10 en = 1; din = {8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h04;

        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
    end

    // Stop the simulation after some time
    initial begin
        #100
        wait(win == 0);
        #20
        $stop();
    end

    // Instantiate the matrix multiplier module
    Matrix_Multiplier #(
        .DATA_WIDTH(8),
        .WEIGHT_WIDTH(8),
        .OUTPUT_WIDTH(8),
        .MAC_NUM(8)
    ) dut(
        .clk_i(clk),
        .rstn_i(rstn),
        .valid_i(valid_i),
        .en_i(en),
        .din_i(din),
        .win_i(win),
        .done_o(done_o),
        .matmul_o(matmul)
    );

endmodule
