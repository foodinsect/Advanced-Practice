`timescale 1ns / 1ps
module tb_top;
    reg clk;
    reg rstn;
    reg valid_i;
    reg en;
    reg rd_temp_en;
    reg wr_temp_en;
    reg [2:0] rd_temp_addr;
    reg [2:0] wr_temp_addr;
    reg [63:0] din; // 8bit x 8
    reg [7:0] win;
    reg [7:0] win_2;
    reg [1:0] mode;
    reg clear;
    wire done_o;
    wire [255:0] matmul;

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
        en = 0; valid_i = 0; din = 0; win = 0; win_2 = 0; wr_temp_addr = 3'b000; rd_temp_addr = 8'h00; wr_temp_en = 0; rd_temp_en = 0;
        #10 rstn = 1;
    end

    // Apply input stimuli
    initial begin
        #45
        wait(rstn);
        mode = 2'b01;
        // First set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h02; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b000;
        
        // Second set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h03; wr_temp_en = 1;
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 0; clear= 1;
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; clear= 0;
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h02; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b001;
        
        // Third set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h02; wr_temp_en = 1;
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h02; wr_temp_en = 0; clear= 1;
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; clear= 0;
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h03; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b010;
        
        // Fourth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 1;
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 0; clear= 1;
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h03; clear= 0;
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b011;
        
        // Fifth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 1;
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 0; clear= 1;
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; clear= 0;
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b100;
        
        // Sixth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 1;
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h02; wr_temp_en = 0;  clear= 1;
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h03; clear= 0;
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h02; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b101;
        
        // Seventh set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h02; wr_temp_en = 1;
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h03; wr_temp_en = 0; clear= 1;
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; clear= 0;
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b110;
        
        // Eighth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 1;
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; wr_temp_en = 0; clear= 1;
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; clear= 0;
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0; wr_temp_addr = 3'b111;
        
        #10 wr_temp_en = 1; 
        #10 wr_temp_en = 0; 
        
        // Apply win_2 stimuli
        #20 en = 1; rd_temp_en = 1; mode = 2'b10;
            win_2 = 8'h01; rd_temp_addr = 3'b000;
        #10 win_2 = 8'h02; rd_temp_addr = 3'b001; clear= 1;
        #10 win_2 = 8'h02; rd_temp_addr = 3'b010; clear= 0;
        #10 win_2 = 8'h01; rd_temp_addr = 3'b011;
        #10 win_2 = 8'h03; rd_temp_addr = 3'b100;
        #10 win_2 = 8'h02; rd_temp_addr = 3'b101;
        #10 win_2 = 8'h01; rd_temp_addr = 3'b110;
        #10 win_2 = 8'h02; rd_temp_addr = 3'b111;
        
        valid_i = 1; 
        #10 win_2 = 8'h00;
        valid_i = 0;
        en = 0; din = 0; win = 0; rd_temp_en = 0;
    end

    // Stop the simulation after some time
    initial begin
        #100
        wait(win == 0);
        #600
        $stop();
    end

    // Instantiate the top module
    top dut(
        .clk_i(clk),
        .rstn_i(rstn),
        .valid_i(valid_i),
        .en_i(en),
        .mode(mode),
        .clear(clear),
        .din1_i(din),
        .din2_i(win),
        .din3_i(win_2),
        .rd_temp_en(rd_temp_en),
        .wr_temp_en(wr_temp_en),
        .rd_temp_addr(rd_temp_addr),
        .wr_temp_addr(wr_temp_addr),
        .done_o(done_o),
        .matmul_o(matmul)
    );

endmodule
