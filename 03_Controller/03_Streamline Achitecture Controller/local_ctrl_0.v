`timescale 1ns / 1ps

module local_ctrl_0 #(
    parameter   MAC_NUM            = 8,     // Default MAC Num
    parameter   ELEMENTS           = 32,    // Number of elements in matrix
    parameter   COLUMN             = 8
)(
    input wire              clk_i,
    input wire              rstn_i,
    input wire              start_i,
    
    output wire     [1:0]   din1_addr_o,   // Address output for din1
    output wire             din1_en_o,     // Enable output for din1
    output wire     [4:0]   din2_addr_o,   // Address output for din2
    output wire             din2_en_o,     // Enable output for din2

    output wire             pu_en_o,       // Processing unit enable
    output wire             pu_valid_o,    // Processing unit valid signal
    output wire             pu_clear_o,    // Processing unit clear signal
    output wire             pu2_en_o,
    output wire             done_o         // Done signal
);


// CYCLES: Total number of cycles required for computation
localparam CYCLES   = ELEMENTS / MAC_NUM;
localparam CNT      = (CYCLES + 2) * COLUMN + 1;
localparam CNT_ADDR     = $clog2(CNT) + 1;
localparam CNT_MAC_ADDR  = $clog2(CYCLES) + 1;

// State and counter registers
reg     [1:0]           present_state;
reg     [1:0]           next_state;

reg     [CNT_ADDR:0]        cnt;
reg     [CNT_MAC_ADDR:0]    cnt_mac;
reg                         done;

reg     [1:0]           din1_addr;
reg                     din1_en;

reg     [4:0]           din2_addr;
reg                     din2_en;

reg                     pu_en;
reg                     pu2_en;
reg                     pu_valid;
reg                     pu_clear;

localparam   IDLE    =   2'b00;
localparam   RUN     =   2'b01;
localparam   DONE    =   2'b11;

//assign  done_o          =   done;
assign  din1_addr_o     =   din1_addr;
assign  din1_en_o       =   din1_en;
assign  din2_addr_o     =   din2_addr;
assign  din2_en_o       =   din2_en;
assign  pu_en_o         =   pu_en;
assign  pu2_en_o        =   pu2_en;
assign  pu_valid_o      =   pu_valid;
assign  pu_clear_o      =   pu_clear;

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
                next_state  =   RUN; // Transition to RUN state on start signal
            end else begin
                next_state  =   IDLE; // Remain in IDLE state
            end
        end
        RUN : begin
            if (cnt == CNT) begin
                next_state  =   DONE; // Transition to DONE state when counter reaches total cycles
            end else begin
                next_state  =   RUN; // Remain in RUN state
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
        pu_en       <= 0;
        pu_valid    <= 0;
    end else begin
        case (present_state)
        IDLE : begin
            // Reset all counters and control signals in IDLE state
            cnt         <= 0;
            cnt_mac     <= 0;
            din1_addr   <= 0;
            din1_en     <= 0;
            din2_addr   <= 0;
            din2_en     <= 0;
            pu_en       <= 0;
            pu_valid    <= 0;
        end
        RUN : begin
            if (cnt == CNT) begin
                // Reset all control signals when count reaches CNT
                cnt         <= 0;
                cnt_mac     <= 0;
                din1_addr   <= 0;
                din1_en     <= 0;
                din2_addr   <= 0;
                din2_en     <= 0;
                pu_en       <= 0;
                pu_valid    <= 0;
            end else if (cnt_mac == CYCLES + 1) begin
                cnt_mac     <= 0;
            end else begin
                cnt <= cnt + 1;
                if (din1_en && din2_en) begin
                    pu_en   <= 1;                 // Enable MAC operation
                    cnt_mac <= cnt_mac + 1;
                    if (cnt_mac == CYCLES - 1) begin
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

                if (cnt_mac >= CYCLES - 1) begin
                    din1_en <= 0;
                    din2_en <= 0;
                end else begin
                    din1_en <= 1;
                    din2_en <= 1;
                end
                
                if (cnt_mac == CYCLES) begin
                    din2_addr   <= din2_addr + 1;
                    pu_valid    <= 1; // Set valid signal on the last cycle
                end else begin
                    pu_valid <= 0;
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
            pu_en       <= 0;
            pu_valid    <= 0;
        end
        default : begin
            // Default case: Reset all control signals
            cnt         <= 0;
            cnt_mac     <= 0;
            din1_addr   <= 0;
            din1_en     <= 0;
            din2_addr   <= 0;
            din2_en     <= 0;
            pu_en       <= 0;
            pu_valid    <= 0;
            
        end
        endcase
    end
end

// Additional control logic
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        done        <= 0;
        pu2_en      <= 0;
        pu_clear    <= 0;
    end
    else if(present_state == DONE) begin
        done        <= pu_valid_o;
        pu_clear    <= done;
    end else begin
        pu2_en      <= pu_valid_o;
        pu_clear    <= pu2_en;
    end
end

endmodule