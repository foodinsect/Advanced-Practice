`timescale 1ns / 1ps

module temp_bram #(
    parameter MAC_NUM = 8,
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = $clog2(MAC_NUM)
)(
    input wire clk_i,
    input wire rstn_i ,
    input wire rd_temp_en,              // Read_enable
    input wire wr_temp_en,
    input wire [ADDR_WIDTH-1:0] wr_temp_addr,
    input wire [ADDR_WIDTH-1:0] rd_temp_addr,
    
    input wire [DATA_WIDTH-1:0] data_i,  // Data input (concated data)

    output reg [DATA_WIDTH-1:0] data_o  // Data output (concating data for coulumn)
);
    // Internal BRAM storage
    reg [DATA_WIDTH-1:0] bram [0:MAC_NUM-1];
    integer i;

    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            for (i = 0; i < MAC_NUM; i = i + 1) begin
                bram[i] <= {DATA_WIDTH{1'b0}};
            end
            data_o <= {DATA_WIDTH{1'b0}};
        end 
        else begin
            if (wr_temp_en) begin
                bram[wr_temp_addr] <= data_i;
            end
            else if (rd_temp_en) begin 
                // concating data for coulumn
                data_o <= bram[rd_temp_addr]; 
            end 
        end
    end

endmodule
