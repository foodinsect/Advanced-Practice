`timescale 1ns / 1ps

module controller #(
    parameter   MAC_NUM            = 8,     // Default MAC Num
    parameter   ELEMENTS_LAYER1    = 32,    // Number of elements in matrix
    parameter   COLUMN             = 8,
    parameter   ELEMENTS_LAYER2    = 64     // Number of elements in matrix
)(
    input wire              clk_i,
    input wire              rstn_i,
    input wire              start_i,
    
    output wire     [1:0]   din1_addr_o,   // Address output for din1
    output wire             din1_en_o,     // Enable output for din1
    output wire     [4:0]   din2_addr_o,   // Address output for din2
    output wire             din2_en_o,     // Enable output for din2
    output wire     [2:0]   din3_addr_o,   // Address output for din3
    output wire             din3_en_o,     // Enable output for din3

    output wire             temp_rd_en_o,  // Read enable output for temp_bram
    output wire             temp_wr_en_o,  // Write enable output for temp_bram
    output wire     [2:0]   temp_addr_o,   // Address output for temp_bram

    output wire             mux_ctrl_o,    // Mux control signal
    output wire             pu_en_o,       // Processing unit enable
    output wire             pu_valid_o,    // Processing unit valid signal
    output wire             pu_clear_o,    // Processing unit clear signal
    output wire             done_o         // Done signal
);


// CYCLES: Total number of cycles required for computation
localparam CYCLES_LAYER1   = ELEMENTS_LAYER1 / MAC_NUM;
localparam CYCLES_LAYER2   = ELEMENTS_LAYER2 / MAC_NUM;

// Additional cycles and states
localparam CNT_1 = (CYCLES_LAYER1 + 2) * COLUMN + 1;

// State and counter registers
reg     [1:0]           present_state;
reg     [1:0]           next_state;

reg     [9:0]           cnt;
reg     [4:0]           cnt_mac;
reg                     done;

reg     [1:0]           din1_addr;
reg                     din1_en;

reg     [4:0]           din2_addr;
reg                     din2_en;

reg     [2:0]           din3_addr;
reg                     din3_en;

reg                     temp_rd_en;
reg                     temp_wr_en;
reg     [2:0]           temp_addr;

reg                     mux_ctrl;
reg                     pu_en;
reg                     pu_valid;
reg                     pu_clear;

localparam   IDLE    =   2'b00;
localparam   RUN_1   =   2'b01;
localparam   RUN_2   =   2'b10;
localparam   DONE    =   2'b11;

assign  done_o          =   done;
assign  din1_addr_o     =   din1_addr;
assign  din1_en_o       =   din1_en;
assign  din2_addr_o     =   din2_addr;
assign  din2_en_o       =   din2_en;
assign  din3_addr_o     =   din3_addr;
assign  din3_en_o       =   din3_en;
assign  pu_en_o         =   pu_en;
assign  pu_valid_o      =   pu_valid;
assign  pu_clear_o      =   pu_clear;
assign  mux_ctrl_o      =   mux_ctrl;
assign  temp_rd_en_o    =   temp_rd_en;
assign  temp_wr_en_o    =   temp_wr_en;
assign  temp_addr_o     =   temp_addr;

// Present state logic
always @(posedge clk_i) begin
    if (!rstn_i) begin
        present_state   <=  IDLE;  // Set state to IDLE on reset
    end else begin
        present_state   <=  next_state; // Update state on clock edge
    end
end

// Next state logic
always @(*) begin
    case (present_state)
        IDLE : begin
            if (start_i) begin
                next_state  =   RUN_1; // Transition to RUN state on start signal
            end else begin
                next_state  =   IDLE; // Remain in IDLE state
            end
        end
        RUN_1 : begin
            if (cnt == CNT_1) begin
                next_state  =   RUN_2; // Transition to DONE state when counter reaches total cycles
            end else begin
                next_state  =   RUN_1; // Remain in RUN state
            end
        end
        RUN_2 : begin
            if (cnt == CYCLES_LAYER2) begin
                next_state  =   DONE; // Transition to DONE state when counter reaches total cycles
            end else begin
                next_state  =   RUN_2; // Remain in RUN state
            end
        end
        DONE : begin
            next_state  =   DONE; // Remain in DONE state
        end
        default : begin
            next_state  =   IDLE; // Default to IDLE state
        end
    endcase
end

// Control signals and counter
always @(posedge clk_i) begin
    if (!rstn_i) begin
        // Initialize all control signals and counters on reset
        cnt         <= 0;
        cnt_mac     <= 0;
        din1_addr   <= 0;
        din1_en     <= 0;
        din2_addr   <= 0;
        din2_en     <= 0;
        din3_addr   <= 0;
        din3_en     <= 0;
        temp_addr   <= 0;
        temp_rd_en  <= 0;
        temp_wr_en  <= 0;
        mux_ctrl    <= 0;
        pu_en       <= 0;
        pu_valid    <= 0;
    end else begin
        case (present_state)
        IDLE : begin
            // Reset all counters and control signals in IDLE state
            cnt         <= 0;
            cnt_mac     <= 0;
            done        <= 0;
            din1_addr   <= 0;
            din1_en     <= 0;
            din2_addr   <= 0;
            din2_en     <= 0;
            din3_addr   <= 0;
            din3_en     <= 0;
            temp_rd_en  <= 0;
            temp_wr_en  <= 0;
            temp_addr   <= 7;
            mux_ctrl    <= 0;
            pu_en       <= 0;
            pu_valid    <= 0;
            pu_clear    <= 0;
        end
        RUN_1 : begin
            if (cnt == CNT_1) begin
                // Reset all control signals when count reaches CNT_1
                cnt         <= 0;
                cnt_mac     <= 0;
                din1_addr   <= 0;
                din1_en     <= 0;
                din2_addr   <= 0;
                din2_en     <= 0;
                din3_addr   <= 0;
                din3_en     <= 0;
                temp_rd_en  <= 0;
                temp_wr_en  <= 0;
                temp_addr   <= 0;
                mux_ctrl    <= 1;
                pu_en       <= 0;
                pu_valid    <= 0;
                pu_clear    <= 0;
            end else if (cnt_mac == CYCLES_LAYER1 + 1) begin
                cnt_mac     <= 0;
            end else begin
                cnt <= cnt + 1;
                if (din1_en && din2_en) begin
                    pu_en   <= 1;                 // Enable MAC operation
                    cnt_mac <= cnt_mac + 1;
                    if (cnt_mac == CYCLES_LAYER1 - 1) begin
                        din1_addr <= din1_addr;
                        din2_addr <= din2_addr;                        
                    end else begin
                        din1_addr <= din1_addr + 1;
                        din2_addr <= din2_addr + 1;
                    end
                end else begin
                    din1_addr   <= 0;
                    pu_en       <= 0;
                    cnt_mac     <= 0;
                end

                if (cnt_mac >= CYCLES_LAYER1 - 1) begin
                    din1_en <= 0;
                    din2_en <= 0;
                end else begin
                    din1_en <= 1;
                    din2_en <= 1;
                end
                
                if (cnt_mac == CYCLES_LAYER1) begin
                    din2_addr   <= din2_addr + 1;
                    pu_valid    <= 1; // Set valid signal on the last cycle
                    temp_addr   <= temp_addr + 1;
                end else begin
                    pu_valid <= 0;
                end
            end
        end
        RUN_2 : begin
            if (cnt == CYCLES_LAYER2) begin
                // Reset all control signals when count reaches CYCLES_LAYER2
                cnt         <= 0;
                cnt_mac     <= 0;
                din1_addr   <= 0;
                din1_en     <= 0;
                din2_addr   <= 0;
                din2_en     <= 0;
                din3_addr   <= 0;
                din3_en     <= 0;
                temp_rd_en  <= 0;
                temp_wr_en  <= 0;
                temp_addr   <= 0;
                mux_ctrl    <= 0;
                pu_en       <= 0;
                pu_valid    <= 1;
                pu_clear    <= 0;
            end else begin
                if (temp_rd_en && din3_en) begin
                    pu_en   <= 1; // Enable MAC operation
                    cnt     <= cnt + 1;
                    cnt_mac <= cnt_mac + 1;
                    if (cnt_mac == CYCLES_LAYER2 - 1) begin
                        temp_addr <= temp_addr;
                        din3_addr <= din3_addr;                        
                    end else begin
                        temp_addr <= temp_addr + 1;
                        din3_addr <= din3_addr + 1;
                    end
                end else begin
                    temp_addr   <= 0;
                    din3_addr   <= 0;
                    pu_en       <= 0;
                    cnt_mac     <= 0;
                end

                if (cnt_mac >= CYCLES_LAYER2 - 1) begin
                    temp_rd_en  <= 0;
                    din3_en     <= 0;
                end else begin
                    temp_rd_en  <= 1;
                    din3_en     <= 1;
                end
               
            end
        end
        DONE : begin
            // Reset all control signals in DONE state
            cnt         <= 0;
            cnt_mac     <= 0;
            din1_addr   <= 0;
            din1_en     <= 0;
            din2_addr   <= 0;
            din2_en     <= 0;
            din3_addr   <= 0;
            din3_en     <= 0;
            mux_ctrl    <= 0;
            pu_en       <= 0;
            pu_valid    <= 0;
            pu_clear    <= 0;
        end
        default : begin
            // Default case: Reset all control signals
            cnt         <= 0;
            cnt_mac     <= 0;
            din1_addr   <= 0;
            din1_en     <= 0;
            din2_addr   <= 0;
            din2_en     <= 0;
            din3_addr   <= 0;
            din3_en     <= 0;
            mux_ctrl    <= 0;
            pu_en       <= 0;
            pu_valid    <= 0;
            pu_clear    <= 0;
        end
        endcase
    end
end

// Additional control logic
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        done        <= 0;
        pu_clear    <= 0;
        temp_wr_en  <= 0;
    end
    else if(present_state == RUN_2 && cnt == 0) begin
        pu_clear    <= 1;
    end
    else if(present_state == DONE) begin
        done        <= pu_valid;
        pu_clear    <= done;
    end else begin
        temp_wr_en  <= pu_valid;
        pu_clear    <= temp_wr_en;
    end
end

endmodule