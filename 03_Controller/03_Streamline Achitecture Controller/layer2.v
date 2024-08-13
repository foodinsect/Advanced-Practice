module layer2 (
    input   wire    clk_i,                  // Clock input
    input   wire    rstn_i,                 // Active low reset input
    input   wire    start_i,                // Start signal input
    input   wire    local1_en,              // Local enable signal input
    
    input   wire    pu2_en,                 // Enable signal from previous processing unit
    input   wire    signed [63:0] temp_o,   // Data input from previous layer
    
    output  wire    done_o,                 // Done signal output
    output  wire    signed [63:0] result    // Result output
);

    // din3 - Bram wire declarations
    wire        [2:0]   din3_addr;       // Address for din3 BRAM
    wire                din3_en;         // Enable signal for din3 BRAM
    wire signed [7:0]   din3_data_out;   // Data output from din3 BRAM

    wire    pu2_valid;                   // Valid signal for processing unit 2
    wire    pu2_clear;                   // Clear signal for processing unit 2

    // Processing Unit 1 instance
    PU1 #(
        .DATA_WIDTH(8),                // Data width
        .WEIGHT_WIDTH(8),              // Weight width
        .OUTPUT_WIDTH(8),              // Output width
        .MAC_NUM(8)                    // Number of MAC units
    ) PU_2 (
        .clk_i(clk_i),                 // Clock input
        .rstn_i(rstn_i),               // Active low reset input
        .en_i(pu2_en),                 // Enable input
        .valid_i(pu2_valid),           // Valid input
        .pu_clear(pu2_clear),          // Clear input
        .pu_done(done_o),              // Done input
        .din_i(temp_o),                // Data input from previous layer
        .win_i(din3_data_out),         // Weight input from din3 BRAM
        .matmul_o(result)              // Output of matrix multiplication
    );

    // Local control unit instance
    local_ctrl_1 layer2_ctrl(
        .clk_i(clk_i),                 // Clock input
        .rstn_i(rstn_i),               // Active low reset input
        .start_i(local1_en),           // Start signal input
    
        .din3_addr_o(din3_addr),       // Output address for din3 BRAM
        .din3_en_o(din3_en),           // Output enable signal for din3 BRAM
    
        .pu_en_o(pu2_en),              // Output enable signal for processing unit 2
        .pu_valid_o(pu2_valid),        // Output valid signal for processing unit 2
        .pu_clear_o(pu2_clear),        // Output clear signal for processing unit 2
        .done_o(done_o)                // Done output
    );    

    // din3 BRAM instance
    xilinx_true_dual_port_no_change_1_clock_ram #(
        .RAM_WIDTH(8),                 // RAM data width
        .RAM_DEPTH(8),                 // RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"), // RAM performance mode
        .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/din3.txt") // Initialization file
    ) din3_bram (
        .addra(din3_addr),             // Port A address bus
        .addrb(),                      // Port B address bus (not used)
        .dina(),                       // Port A input data (not used)
        .dinb(),                       // Port B input data (not used)
        .clka(clk_i),                  // Clock input
        .wea(),                        // Port A write enable (not used)
        .web(),                        // Port B write enable (not used)
        .ena(din3_en),                 // Port A enable signal
        .enb(),                        // Port B enable signal (not used)
        .rsta(),                       // Port A output reset (not used)
        .rstb(),                       // Port B output reset (not used)
        .regcea(),                     // Port A output register enable (not used)
        .regceb(),                     // Port B output register enable (not used)
        .douta(din3_data_out),         // Port A output data
        .doutb()                       // Port B output data (not used)
    );

endmodule
