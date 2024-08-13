module top(
    input clk_i,
    input rstn_i,
    input start_i,
    output reg signed [63:0] result,
    output done_o
);

// Controller wire declarations
wire  mux_ctrl;

// MAC wire declarations
wire  pu_clear,  pu_en,  pu_valid;
reg signed  [63:0]  input_data;
reg signed  [7:0]   input_weight;


// din1-bram-wire declaration
wire [1:0]          din1_addr;
wire                din1_en;
wire signed [63:0]  din1_data_out;

// din2-bram-wire declaration

wire        [4:0]   din2_addr;
wire                din2_en; 
wire signed [7:0]   din2_data_out;

// din3-bram-wire declaration
wire        [2:0]   din3_addr;
wire                din3_en;
wire signed [7:0]   din3_data_out;

// temp_bram declaration
wire signed [63:0]  temp_o;
wire        [2:0]   temp_addr;
wire                temp_rd_en;
wire                temp_wr_en;
wire signed [63:0] temp_bram_output;

// Controller instance
controller controller(
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .start_i(start_i), // IDLE -> RUN_0

    .din1_addr_o(din1_addr), // din1 (x) address
    .din1_en_o(din1_en),
    .din2_addr_o(din2_addr), // din2 (w0) address
    .din2_en_o(din2_en),
    .din3_addr_o(din3_addr), // din3 (w1) address
    .din3_en_o(din3_en),

    .temp_rd_en_o(temp_rd_en), // temp_bram read enable
    .temp_wr_en_o(temp_wr_en), // temp_bram write enable
    .temp_addr_o(temp_addr), // temp_bram address

    .mux_ctrl_o(mux_ctrl),
    .pu_en_o(pu_en),
    .pu_valid_o(pu_valid),
    .pu_clear_o(pu_clear),
    .done_o(done_o)
);

// temp_bram instance
temp_bram temp_bram (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .wr_temp_en(temp_wr_en),
    .temp_addr(temp_addr),
    .rd_temp_en(temp_rd_en),
    .data_in(temp_o),
    .data_out(temp_bram_output)
);

// Result update
always @(*) begin
    if (done_o) begin
        result = temp_o;
    end else begin
        result = 0;
    end
end

// Weight MUX procedure
always @(*) begin
    if (mux_ctrl) begin
        input_weight = din3_data_out;
        input_data = temp_bram_output;
    end else begin
        input_weight = din2_data_out;
        input_data = din1_data_out;
    end
end

// Processing Unit instance
pu #(
    .DATA_WIDTH(8),
    .WEIGHT_WIDTH(8),
    .OUTPUT_WIDTH(8),
    .MAC_NUM(8)
) Processing_Unit (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .en_i(pu_en),
    .valid_i(pu_valid),
    .pu_clear(pu_clear),

    .din_i(input_data),
    .win_i(input_weight),

    .matmul_o(temp_o)
);

// din1 BRAM instance
xilinx_true_dual_port_no_change_1_clock_ram #(
    .RAM_WIDTH(64), // Specify RAM data width
    .RAM_DEPTH(4), // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/din1.txt") // Specify RAM initialization file
) din1_bram (
    .addra(din1_addr), // Port A address bus
    .addrb(), // Port B address bus
    .dina(), // Port A RAM input data
    .dinb(), // Port B RAM input data
    .clka(clk_i), // Clock
    .wea(), // Port A write enable
    .web(), // Port B write enable
    .ena(din1_en), // Port A RAM enable
    .enb(), // Port B RAM enable
    .rsta(), // Port A output reset
    .rstb(), // Port B output reset
    .regcea(), // Port A output register enable
    .regceb(), // Port B output register enable
    .douta(din1_data_out), // Port A RAM output data
    .doutb() // Port B RAM output data
);

// din2 BRAM instance
xilinx_true_dual_port_no_change_1_clock_ram #(
    .RAM_WIDTH(16), // Specify RAM data width
    .RAM_DEPTH(32), // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/din2.txt") // Specify RAM initialization file
) din2_bram (
    .addra(din2_addr), // Port A address bus
    .addrb(), // Port B address bus
    .dina(), // Port A RAM input data
    .dinb(), // Port B RAM input data
    .clka(clk_i), // Clock
    .wea(), // Port A write enable
    .web(), // Port B write enable
    .ena(din2_en), // Port A RAM enable
    .enb(), // Port B RAM enable
    .rsta(), // Port A output reset
    .rstb(), // Port B output reset
    .regcea(), // Port A output register enable
    .regceb(), // Port B output register enable
    .douta(din2_data_out), // Port A RAM output data
    .doutb() // Port B RAM output data
);

// din3 BRAM instance
xilinx_true_dual_port_no_change_1_clock_ram #(
    .RAM_WIDTH(8), // Specify RAM data width
    .RAM_DEPTH(8), // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("LOW_LATENCY"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("C:/Vivado_Practice/Advanced Practice 3/din3.txt") // Specify RAM initialization file
) din3_bram (
    .addra(din3_addr), // Port A address bus
    .addrb(), // Port B address bus
    .dina(), // Port A RAM input data
    .dinb(), // Port B RAM input data
    .clka(clk_i), // Clock
    .wea(), // Port A write enable
    .web(), // Port B write enable
    .ena(din3_en), // Port A RAM enable
    .enb(), // Port B RAM enable
    .rsta(), // Port A output reset
    .rstb(), // Port B output reset
    .regcea(), // Port A output register enable
    .regceb(), // Port B output register enable
    .douta(din3_data_out), // Port A RAM output data
    .doutb() // Port B RAM output data
);

endmodule