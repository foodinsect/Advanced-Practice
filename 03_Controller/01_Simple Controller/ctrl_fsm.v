`timescale 1ns / 1ps

module ctrl_fsm #(
    parameter   MAC_NUM     = 1,    // Default MAC Num
    parameter   ELEMENTS    = 8     // Number of elements in matrix
)(
    input wire              clk_i,
    input wire              rstn_i,
    input wire              start_i,
    
    output wire     [2:0]   din1_addr_o,
    output wire             din1_en_o,

    output wire     [2:0]   din2_addr_o,
    output wire             din2_en_o,

    output wire             pu_en_o,
    output wire             pu_valid_o,

    output wire             done_o
);

// CYCLES: Total number of cycles required for computation
localparam CYCLES   = ELEMENTS / MAC_NUM;
localparam CNT_MAC  = $clog2(CYCLES) + 1;

reg     [1:0]           present_state;
reg     [1:0]           next_state;

reg     [CNT_MAC:0]     cnt_mac;
reg                     done;

reg     [2:0]           din1_addr;
reg                     din1_en;

reg     [2:0]           din2_addr;
reg                     din2_en;

reg                     pu_en;
reg                     pu_valid;

localparam   IDLE    =   2'b00;
localparam   RUN     =   2'b01;
localparam   DONE    =   2'b11;

assign  done_o          = done;
assign  din2_addr_o     = din2_addr;
assign  din2_en_o       = din2_en;
assign  din1_addr_o     = din1_addr;
assign  din1_en_o       = din1_en;
assign  pu_en_o        = pu_en;
assign  pu_valid_o     = pu_valid;


// Present state logic
always @(posedge clk_i) begin
    if (!rstn_i) begin
        present_state <= IDLE;  // Set state to IDLE on reset
    end else begin
        present_state <= next_state; // Update state on clock edge
    end
end

// Next state logic
always @(*) begin
    case (present_state)
        IDLE : begin
            if (start_i) begin
                next_state = RUN; // Transition to RUN state on start signal
            end else begin
                next_state = IDLE; // Remain in IDLE state
            end
        end
        RUN : begin
            if (cnt_mac == CYCLES) begin
                next_state = DONE; // Transition to DONE state when counter reaches total cycles
            end else begin
                next_state = RUN; // Remain in RUN state
            end
        end
        DONE : begin
            next_state = DONE; // Remain in DONE state
        end
        default : begin
            next_state = IDLE; // Default to IDLE state
        end
    endcase
end

// Control signals and counter
always @(posedge clk_i) begin
    if (!rstn_i) begin
        cnt_mac <= 0;
        done <= 0;
        din2_addr <= 0;
        din2_en <= 0;
        din1_addr <= 0;
        din1_en <= 0;
        pu_en <= 0;
        pu_valid <= 0;
    end else begin
        case (present_state)
        IDLE : begin
            cnt_mac <= 0;
            done <= 0;
            din2_addr <= 0;
            din2_en <= 0;
            pu_valid <= 0;
            din1_addr <= 0;
            din1_en <= 0;
            pu_en <= 0;
        end
        RUN : begin
            if (cnt_mac == CYCLES) begin
                done <= 1; // Set done signal when computation is complete
                cnt_mac <= 0;
                din2_addr <= 0;
                din2_en <= 0;
                din1_addr <= 0;
                din1_en <= 0;
                pu_en <= 0;
                pu_valid <= 0;
            end else begin
                done <= 0;
                if (din1_en && din2_en) begin
                    pu_en <= 1; // Enable MAC operation
                    cnt_mac <= cnt_mac + 1;
                    if (cnt_mac == CYCLES - 1) begin
                        din1_addr <= din1_addr;
                        din2_addr <= din2_addr;
                        pu_valid <= 1; // Set valid signal on the last cycle
                    end else begin
                        pu_valid <= 0;
                        din1_addr <= din1_addr + 1;
                        din2_addr <= din2_addr + 1;
                    end
                end else begin
                    din1_addr <= 0;
                    din2_addr <= 0;
                    pu_en <= 0;
                    cnt_mac <= 0;
                end

                if (cnt_mac == CYCLES - 1) begin
                    din1_en <= 0;
                    din2_en <= 0;
                end else begin
                    din1_en <= 1;
                    din2_en <= 1;
                end
            end
        end
        DONE : begin
            done <= 0;
            cnt_mac <= 0;
            din2_addr <= 0;
            din2_en <= 0;
            din1_addr <= 0;
            din1_en <= 0;
            pu_valid <= 0;
            pu_en <= 0;
        end
        default : begin
            cnt_mac <= 0;
            done <= 0;
            din2_addr <= 0;
            pu_valid <= 0;
            din2_en <= 0;
            din1_addr <= 0;
            din1_en <= 0;
            pu_en <= 0;
        end
        endcase
    end
end

endmodule