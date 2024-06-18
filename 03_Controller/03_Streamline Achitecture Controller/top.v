module top(
    input clk_i,                    // Clock input
    input rstn_i,                   // Active low reset input
    input start_i,                  // Start signal input
    output signed [63:0] result,    // Result output
    output done_o                   // Done signal output
);

// temp_bram wire declaration
wire signed [63:0] temp_o;          // Temporary data wire

wire local0_en;                     // Local enable signal for layer1
wire local1_en;                     // Local enable signal for layer2
wire pu2_en;                        // Enable signal for processing unit 2
wire done_2;                        // Done signal for layer2

// Controller instance
controller Global_Ctrl(
    .clk_i(clk_i),                  // Clock input
    .rstn_i(rstn_i),                // Active low reset input
    .start_i(start_i),              // Start signal input
    .local_en_0(local0_en),         // Local enable signal for layer1
    .local_en_1(local1_en),         // Local enable signal for layer2
    .clear_local_0(),               // Clear signal for layer1 (not used)
    .clear_local_1(),               // Clear signal for layer2 (not used)
    .done_o(done_o)                 // Done signal output
);   

// Layer1 instance
layer1 Layer1(
  .clk_i(clk_i),                    // Clock input
  .rstn_i(rstn_i),                  // Active low reset input
  .start_i(start_i),                // Start signal input
  .local0_en(local0_en),            // Local enable signal for layer1
  .pu2_en(pu2_en),                  // Enable signal for processing unit 2
  .temp_o(temp_o)                   // Temporary data output
);

// Layer2 instance
layer2 Layer2(
  .clk_i(clk_i),                    // Clock input
  .rstn_i(rstn_i),                  // Active low reset input
  .start_i(start_i),                // Start signal input
  .local1_en(local1_en),            // Local enable signal for layer2
  .pu2_en(pu2_en),                  // Enable signal for processing unit 2
  .temp_o(temp_o),                  // Temporary data input
  .done_o(done_2),                  // Done signal output for layer2
  .result(result)                   // Result output
);

endmodule
