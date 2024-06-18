module temp_bram #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 3
)(
    input wire                  clk_i,
    input wire                  rstn_i,
    input wire                  rd_temp_en,     // Read enable
    input wire [DATA_WIDTH-1:0] data_in,        // Data input
    input wire wr_temp_en,                      // Write enable
    input wire [ADDR_WIDTH-1:0] temp_addr,      // Address input
    output reg [DATA_WIDTH-1:0] data_out        // Data output
);
    // Internal BRAM storage
    reg [DATA_WIDTH-1:0] bram [(1 << ADDR_WIDTH)-1:0];
    integer i;
    
    // Sequential block: Handles reset, write and read operations
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            // Reset: Initialize all BRAM locations to 0
            for (i = 0; i < (1 << ADDR_WIDTH); i = i + 1) begin
                bram[i] <= 0;
            end
            data_out <= 0; 
        end 
        else if (wr_temp_en) begin
            // Write operation: Store data_in at the location specified by temp_addr
            bram[temp_addr] <= data_in;
        end
        else if (rd_temp_en) begin 
            // Read operation: Output data from the location specified by temp_addr
            data_out <= bram[temp_addr]; 
        end else begin
            // Default case: Output 0
            data_out <= 0;
        end
    end

endmodule
