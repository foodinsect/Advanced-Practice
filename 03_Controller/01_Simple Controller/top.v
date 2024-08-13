`timescale 1ns / 1ps

module top(
    input   wire                clk_i,
    input   wire                rstn_i,
    input   wire                start_i,
    
    output  wire                done_o,
    output  wire    [31:0]      acc_o
    );

    // Internal wires to connect submodules
    wire            w_done;
    wire    [31:0]  w_acc;

    wire    [2:0]   w_w_addr;
    wire            w_w_en;
    wire    [7:0]   w_w_data;

    wire    [2:0]   w_x_addr;
    wire            w_x_en;
    wire    [7:0]   w_x_data;

    wire            w_mac_en;
    wire            dsp_valid;
    
    // Assign outputs to internal signals
    assign  done_o  = w_done;
    assign  acc_o   = w_acc;

    // Instantiate the MAC module
    MAC mac (
        .clk_i            (clk_i),            
        .rstn_i           (rstn_i),
        .dsp_enable_i     (w_mac_en),
        .dsp_valid_i      (dsp_valid),
        .dsp_input_i      (w_x_data),
        .dsp_weight_i     (w_w_data),
        .dsp_output_o     (w_acc)
    );

    // Instantiate the control FSM
    ctrl_fsm ctrl_fsm (
        .clk_i            (clk_i),
        .rstn_i           (rstn_i),
        .start_i          (start_i),
        .pu_valid_o      (dsp_valid),
        .din2_addr_o         (w_w_addr),    
        .din2_en_o           (w_w_en),
        .din1_addr_o         (w_x_addr),
        .din1_en_o           (w_x_en),
        .pu_en_o         (w_mac_en),
        .done_o           (w_done)         
    );

    // Instantiate X BRAM
    xilinx_true_dual_port_no_change_1_clock_ram #(
        .RAM_WIDTH(8),                       // Specify RAM data width
        .RAM_DEPTH(8),                       // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"),     // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/a.txt") // Specify name/location of RAM initialization file if using one (leave blank if not)
    ) x_bram (
        .addra(w_x_addr),   // Port A address bus, width determined from RAM_DEPTH
        .addrb(),           // Port B address bus, width determined from RAM_DEPTH
        .dina(),            // Port A RAM input data, width determined from RAM_WIDTH
        .dinb(),            // Port B RAM input data, width determined from RAM_WIDTH
        .clka(clk_i),       // Clock
        .wea(),             // Port A write enable
        .web(),             // Port B write enable
        .ena(w_x_en),       // Port A RAM Enable, for additional power savings, disable port when not in use
        .enb(),             // Port B RAM Enable, for additional power savings, disable port when not in use
        .rsta(),            // Port A output reset (does not affect memory contents)
        .rstb(),            // Port B output reset (does not affect memory contents)
        .regcea(),          // Port A output register enable
        .regceb(),          // Port B output register enable
        .douta(w_x_data),   // Port A RAM output data, width determined from RAM_WIDTH
        .doutb()            // Port B RAM output data, width determined from RAM_WIDTH
    );

    // Instantiate W BRAM
    xilinx_true_dual_port_no_change_1_clock_ram #(
        .RAM_WIDTH(8),                       // Specify RAM data width
        .RAM_DEPTH(8),                       // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"),     // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/w.txt") // Specify name/location of RAM initialization file if using one (leave blank if not)
    ) w_bram (
        .addra(w_w_addr),   // Port A address bus, width determined from RAM_DEPTH
        .addrb(),           // Port B address bus, width determined from RAM_DEPTH
        .dina(),            // Port A RAM input data, width determined from RAM_WIDTH
        .dinb(),            // Port B RAM input data, width determined from RAM_WIDTH
        .clka(clk_i),       // Clock
        .wea(),             // Port A write enable
        .web(),             // Port B write enable
        .ena(w_w_en),       // Port A RAM Enable, for additional power savings, disable port when not in use
        .enb(),             // Port B RAM Enable, for additional power savings, disable port when not in use
        .rsta(),            // Port A output reset (does not affect memory contents)
        .rstb(),            // Port B output reset (does not affect memory contents)
        .regcea(),          // Port A output register enable
        .regceb(),          // Port B output register enable
        .douta(w_w_data),   // Port A RAM output data, width determined from RAM_WIDTH
        .doutb()            // Port B RAM output data, width determined from RAM_WIDTH
    );

endmodule
