`timescale 1ns / 1ps

module layer1(
    input wire      clk_i,              // Clock input
    input wire      rstn_i,             // Active low reset input
    input wire      start_i,            // Start signal input
    input wire      local0_en,          // Local enable signal input
    
    output wire     pu2_en,             // Enable signal output for processing unit 2
    output wire signed [63:0] temp_o    // Signed output data
    );
    
    // MAC (Multiply-Accumulate) wire declarations
    wire        pu1_clear;                 // Signal to clear the processing unit
    wire        pu1_en;                    // Enable signal for processing unit 1
    wire        pu1_valid;                 // Valid signal for processing unit 1
    
    // xbram wire declarations
    wire        [1:0]   din1_addr;          // Address for din1 BRAM
    wire                din1_en;            // Enable signal for din1 BRAM
    wire signed [63:0]  din1_data_out;      // Data output from din1 BRAM
    
    // w0bram wire declarations
    wire        [4:0]   din2_addr;          // Address for din2 BRAM
    wire                din2_en;            // Enable signal for din2 BRAM
    wire signed [7:0]   din2_data_out;      // Data output from din2 BRAM
    
    // Processing Unit 0 instance
    PU0 #(
        .DATA_WIDTH(8),             // Data width
        .WEIGHT_WIDTH(8),           // Weight width
        .OUTPUT_WIDTH(8),           // Output width
        .MAC_NUM(8)                 // Number of MAC units
    ) PU_1 (
        .clk_i(clk_i),              // Clock input
        .rstn_i(rstn_i),            // Active low reset input
        .en_i(pu1_en),              // Enable Signal
        .valid_i(pu1_valid),        // Valid Signal
        .pu_clear(pu1_clear),       // Clear Signal
        .pu_done(pu2_en),           // Enable Layer2 Calc Signal
        .din_i(din1_data_out),      // Data input from din1 BRAM
        .win_i(din2_data_out),      // Weight input from din2 BRAM
        .matmul_o(temp_o)           // Output of matrix multiplication
    );
    
    // Local control unit instance
    local_ctrl_0 layer1_ctrl(
        .clk_i(clk_i),              // Clock input
        .rstn_i(rstn_i),            // Active low reset input
        .start_i(local0_en),        // Start signal input
    
        .din1_addr_o(din1_addr),    // Output address for din1 BRAM
        .din1_en_o(din1_en),        // Output enable signal for din1 BRAM
        .din2_addr_o(din2_addr),    // Output address for din2 BRAM
        .din2_en_o(din2_en),        // Output enable signal for din2 BRAM
    
        .pu_en_o(pu1_en),           // Output enable signal for processing unit 1
        .pu_valid_o(pu1_valid),     // Output valid signal for processing unit 1
        .pu_clear_o(pu1_clear),     // Output clear signal for processing unit 1
        .pu2_en_o(pu2_en),          // Output enable signal for processing unit 2
        .done_o()                   // Done output (not used)
    );
    
    // din1 BRAM instance
    xilinx_true_dual_port_no_change_1_clock_ram #(
        .RAM_WIDTH(64),             // RAM data width
        .RAM_DEPTH(4),              // RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // RAM performance mode
        .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/din1.txt") // Initialization file
    ) din1_bram (
        .addra(din1_addr),          // Port A address bus
        .addrb(),                   // Port B address bus (not used)
        .dina(),                    // Port A input data (not used)
        .dinb(),                    // Port B input data (not used)
        .clka(clk_i),               // Clock input
        .wea(),                     // Port A write enable (not used)
        .web(),                     // Port B write enable (not used)
        .ena(din1_en),              // Port A enable signal
        .enb(),                     // Port B enable signal (not used)
        .rsta(),                    // Port A output reset (not used)
        .rstb(),                    // Port B output reset (not used)
        .regcea(),                  // Port A output register enable (not used)
        .regceb(),                  // Port B output register enable (not used)
        .douta(din1_data_out),      // Port A output data
        .doutb()                    // Port B output data (not used)
    );

    // din2 BRAM instance
    xilinx_true_dual_port_no_change_1_clock_ram #(
        .RAM_WIDTH(8),              // RAM data width
        .RAM_DEPTH(32),             // RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // RAM performance mode
        .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/din2.txt") // Initialization file
    ) din2_bram (
        .addra(din2_addr),          // Port A address bus
        .addrb(),                   // Port B address bus (not used)
        .dina(),                    // Port A input data (not used)
        .dinb(),                    // Port B input data (not used)
        .clka(clk_i),               // Clock input
        .wea(),                     // Port A write enable (not used)
        .web(),                     // Port B write enable (not used)
        .ena(din2_en),              // Port A enable signal
        .enb(),                     // Port B enable signal (not used)
        .rsta(),                    // Port A output reset (not used)
        .rstb(),                    // Port B output reset (not used)
        .regcea(),                  // Port A output register enable (not used)
        .regceb(),                  // Port B output register enable (not used)
        .douta(din2_data_out),      // Port A output data
        .doutb()                    // Port B output data (not used)
    );

endmodule
