`timescale 1ns / 1ps

module MAC(
    input wire rstn_i,
    input wire clk_i,
    input wire dsp_enable_i,
    input wire dsp_valid_i,
    input wire dsp_valid_o,
    input wire signed [7:0] dsp_input_i,
    input wire signed [7:0] dsp_weight_i,
    output wire valid_o_d,
    output reg done_o,
    output wire signed [31:0] dsp_output_o
);


reg signed [30:0] partial_sum;    // 누적 합계를 저장할 부분합계 레지스터
reg signed [31:0] dsp_output;
wire signed [31:0] dsp_temp;

reg [1:0] dsp_valid_delay;
reg [1:0] valid_o_delay;


assign dsp_output_o = dsp_output;
assign dsp_valid_o = dsp_valid_delay[0];
assign valid_o_d = dsp_valid_delay[1];

// DSP 입력 신호를 레지스터에 저장합니다.
always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        partial_sum <= 0;
    end else if (valid_o_d) begin
        partial_sum <= 0;
    end else begin
        partial_sum <= $signed ({dsp_temp[31],dsp_temp[29:0]});
    end 
end

always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        dsp_valid_delay <=0;
    end
    else begin
        valid_o_delay[0] <= dsp_valid_o;
        valid_o_delay[1] <= valid_o_delay[0];
        dsp_valid_delay[0] <= dsp_valid_i;
        dsp_valid_delay[1] <= dsp_valid_delay[0];
    end
end
    
always @(posedge clk_i or negedge rstn_i) begin    
    if(!rstn_i) begin
        dsp_output <= 0;
    end
    else if (dsp_valid_o) begin
        dsp_output <= dsp_temp;
        done_o <= 1;
    end
    else begin
        dsp_output <=0;
        done_o <= 0;
    end
end 

xbip_dsp48_macro_0 DSP_for_MAC (
    .CLK(clk_i),             // 클록 입력
    .CE(dsp_enable_i),       // DSP 활성화 신호 입력
    .A(dsp_input_i),         // 데이터 입력 A
    .B(dsp_weight_i),        // 가중치 입력 B
    .C(partial_sum),         // 부분합계 입력 C
    .P(dsp_temp)             // DSP 출력
);

endmodule
