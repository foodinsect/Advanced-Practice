`timescale 1ns / 1ps
module controller(
input wire              clk_i,
input wire              rstn_i,
input wire              start_i,        // IDLE -> RUN_0

output wire             local_en_0,
output wire             local_en_1,

output wire             clear_local_0,
output wire             clear_local_1,

output wire             done_o
);

reg     [1:0]   present_state;
reg     [1:0]   next_state;

reg     [8:0]   cnt_mac;
reg             done;


reg             en_0;
reg             en_1;
reg             clear_0;
reg             clear_1;


localparam   IDLE    =   2'b00;
localparam   RUN   =   2'b01;
localparam   DONE   =   2'b11;


assign  done_o = done;

assign  local_en_0      =   en_0;
assign  local_en_1      =   en_1;

assign  clear_local_0      =   clear_0;
assign  clear_local_1      =   clear_1;

//present_state
always @(posedge clk_i) begin
    if (!rstn_i) begin
        present_state   <=  IDLE;
    end
    else begin
        present_state   <=  next_state;
    end
end


//next_state
always @(*) begin
    case (present_state)
        IDLE : begin
            if (start_i) begin
                next_state = RUN;
            end
            else begin
                next_state = IDLE;
            end
        end
        RUN :   begin
            if (cnt_mac == 52) begin
                next_state  =   DONE;
            end
            else begin
                next_state  =   RUN;
            end
        end
        DONE : begin
            next_state  =   DONE;
        end
        default : begin
            next_state  =   IDLE;
        end
    endcase
end


//
always @(posedge clk_i) begin
    if (!rstn_i) begin
        done    <=  0;
        en_0    <= 0;
        en_1    <= 0;
        clear_0 <= 0;
        clear_1 <= 0;
    end
    else begin
        case (present_state)
        IDLE    :   begin
            done    <=  0;
            en_0    <= 0;
            en_1    <= 0;
            clear_0 <= 0;
            clear_1 <= 0;

        end
        RUN     :   begin
            if (cnt_mac == 52) begin     // 
                done    <=  0;
                en_0    <= 1;
                en_1    <= 1;
                clear_0 <= 0;
                clear_1 <= 0;
            end
            else begin
                done    <=  0;
                if (en_0 && en_1) begin
                    cnt_mac <=  cnt_mac + 1; 
                end
                else begin
                    cnt_mac <= 0;
                end

                if (cnt_mac == 52) begin
                    clear_0 <= 1;
                    clear_1 <= 1;
                end
                else begin
                    en_0 <= 1;
                    en_1 <= 1;
                end
            end
        end
        DONE    :   begin
            if (cnt_mac == 0) begin
                cnt_mac <=  0;
                done    <=  0;
                en_0    <= 0;
                en_1    <= 0;
                clear_0 <= 0;
                clear_1 <= 0;
            end else begin
                done    <=  1;
                cnt_mac <=  0;
                en_0    <= 0;
                en_1    <= 0;
                clear_0 <= 1;
                clear_1 <= 1;
            end
        end
        default :   begin
            cnt_mac <=  0;
            done    <=  0;
            en_0    <= 0;
            en_1    <= 0;
            clear_0 <= 0;
            clear_1 <= 0;
        end
        endcase
    end
end

endmodule