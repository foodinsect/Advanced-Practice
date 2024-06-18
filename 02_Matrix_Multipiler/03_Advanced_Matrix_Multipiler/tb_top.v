`timescale 1ns / 1ps
module tb_top;
    reg clk;
    reg rstn;
    reg valid_i;
    reg en;
    reg [63:0]  din; // 8bit x 8
    reg [7:0]   win;
    reg [7:0]   win_2;
    
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
        en = 0; valid_i = 0; din = 0; win = 0; win_2 = 0;
        #10 rstn = 1;
    end

    // Apply input stimuli
    initial begin
        #45
        wait(rstn);
        
        // First set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h02; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
        
        // Second set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h03; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h02; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
        
        // Third set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h02; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h02; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h03; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
        
        // Fourth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h03; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
        
        // Fifth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
        
        // Sixth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h02; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h03; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h02; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
        
        // Seventh set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h02; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h03; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        
        valid_i = 1;
        #10 en = 0; din = 0; win = 0;
        valid_i = 0;
        #10 en = 0; din = 0; win = 0;
        
        // Eighth set of inputs
        #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h02, 8'h03, 8'h01, 8'h02, 8'h02, 8'h01, 8'h03, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h03, 8'h02, 8'h01, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01}; win = 8'h01; 
        #10 en = 1; din = {8'h01, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02}; win = 8'h01; 
        #10 din = 0; win = 0;
        
        en = 1;
        valid_i = 1;
        #10 din = 0; win = 0;
        valid_i = 0;
        en = 0; din = 0; win = 0;
        
        #20 
        // Apply win_2 stimuli
        #10 en = 1; win_2 = 8'h01;
        #10 win_2 = 8'h02;
        #10 win_2 = 8'h02;
        #10 win_2 = 8'h01;
        #10 win_2 = 8'h03;
        #10 win_2 = 8'h02;
        #10 win_2 = 8'h01;    
        #10 win_2 = 8'h02;
        valid_i = 1; 
        #10 win_2 = 8'h00;
        valid_i = 0;
        en = 0; din = 0; win = 0;
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
        .din1_i(din),
        .din2_i(win),
        .din3_i(win_2),
        .done_o(done_o),
        .matmul_o(matmul)
    );

endmodule
