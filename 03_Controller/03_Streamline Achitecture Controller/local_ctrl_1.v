`timescale 1ns / 1ps

module local_ctrl_1 #(
    parameter   MAC_NUM            = 8,     // Default MAC Num
    parameter   ELEMENTS           = 32,    // Number of elements in matrix
    parameter   COLUMN             = 8
)(
    input wire              clk_i,
    input wire              rstn_i,
    input wire              start_i,
    input  wire             pu_en_o,
    
    output wire     [2:0]   din3_addr_o,
    output wire             din3_en_o,

    output wire             pu_valid_o,
    output wire             pu_clear_o,
    
    output wire             done_o
);

reg     [1:0]           present_state;
reg     [1:0]           next_state;

reg     [7:0]           cnt;
reg                     done;

reg     [2:0]           din3_addr;
reg                     din3_en;

reg                     valid;

reg                     pu_clear;

localparam   IDLE    =   2'b00;
localparam   RUN     =   2'b01;
localparam   DONE    =   2'b11;

assign  done_o          = done;
assign  din3_addr_o     = din3_addr;
assign  din3_en_o       = din3_en;
assign  pu_valid_o      = valid;
assign  pu_clear_o      = pu_clear;


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
            if (cnt == 52) begin
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
        cnt         <= 0;
        done        <= 0;
        din3_addr   <= 0;
        din3_en     <= 0;
        valid       <= 0;
    end else begin
        case (present_state)
        IDLE : begin
            cnt         <= 0;
            done        <= 0;
            valid       <= 0;
            din3_addr   <= 0;
            din3_en     <= 0;
        end
        RUN : begin
            if (cnt == 52) begin
                done        <= 1; // Set done signal when computation is complete
                cnt         <= 0;
                din3_addr   <= 0;
                din3_en     <= 0;
            end else begin
                done <= 0;
                cnt  <= cnt + 1;
                if (din3_en) begin
                    din3_addr  <=  din3_addr;
                    if (pu_en_o) begin
                        din3_addr <= din3_addr;
                        valid     <= 1; 
                    end else if(pu_clear) begin
                        din3_addr <= din3_addr + 1;
                    end else begin
                        valid     <= 0;
                    end
                end else begin
                    din3_addr <= 0;
                end

                if (cnt == 51) begin
                    din3_en <= 0;
                end else begin
                    din3_en <= 1;
                end
            end
        end
        DONE : begin
            done        <= 0;
            cnt         <= 0;
            din3_addr   <= 0;
            din3_en     <= 0;
            valid       <= 0;
        end
        default : begin
            cnt         <= 0;
            done        <= 0;
            valid       <= 0;
            din3_addr   <= 0;
            din3_en     <= 0;
        end
        endcase
    end
end

always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        pu_clear <= 0;
    end
    else begin
        pu_clear <= valid;
    end
end

endmodule