`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/20 13:32:00
// Design Name: 
// Module Name: CMB_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CMB_top(
    input        clk100_in,
    input[3:0]   pb_in,
    input[3:0]   wb_in,
    input[3:0]   sw_in,
    input[3:0]   wsw_in,
    output[3:0]  led_out,
    output[8:0]  cover_led,
    output[3:0]  rf_sw_out,
    output       debug_out,
    output[9:0]  rot_count_out,
    output       rot_clk_out,
    output       stp_clk_out,
    output       adc_trg_out,
    output       scl,
    output       sda,
    output       VCC,
    output       VCC2
    );
    
    wire rst;
    wire sys_init;
    wire trg;
    wire pause;
    
    wire clk_25MHz;
    wire clk_1MHz;
    wire clk_1KHz;
    wire stp_clk;
    wire clk_1Hz;
    
    wire sys_init_ctrl;
    wire trg_ctrl;
    wire pause_ctrl;
    wire pause_out;
    
    wire wrk_stat;
    wire rot_en;
    wire adc_en;
    
    wire [15:0] bcd_int;
    assign sys_init = pb_in[3] | (~wb_in[3]);
    assign pause    = pb_in[2] | (~wb_in[2]);
    assign trg      = pb_in[1] | (~wb_in[1]);
    assign rst      = pb_in[0] | (~wb_in[0]);
    //assign sys_init = pb_in[3];
    //assign pause    = pb_in[2];
    //assign trg      = pb_in[1];
    //assign rst      = pb_in[0];
    assign VCC      = 1;
    assign VCC2     = 1;
    
    wire [3:0] sw_comb;
    assign sw_comb[3] = sw_in[3] | wsw_in[3];
    assign sw_comb[2] = sw_in[2] | wsw_in[2];
    assign sw_comb[1] = sw_in[1] | wsw_in[1];
    assign sw_comb[0] = sw_in[0] | wsw_in[0];
    
    
    assign debug_out = wrk_stat;
    assign rot_clk = rot_en & stp_clk;
    
    adc_trg_maker ADC_TRG_MAKER (.fpga_clk(clk100_in), .adc_en(adc_en), .adc_trg_out(adc_trg_out));
    
    assign rot_clk_out = rot_clk;
    assign stp_clk_out = stp_clk;
    
    clk_cntr_top   
    U0      (.fpga_clk(clk100_in), .rst(rst), 
            .clk_25MHz(clk_25MHz), .clk_1MHz(clk_1MHz), .clk_1KHz(clk_1KHz), .clk_100Hz(stp_clk), .clk_1Hz(clk_1Hz));
         
    button_pulse
    U1_1    (.fpga_clk(clk100_in), .i_clk(clk_1MHz), .button(sys_init), .button_edge(sys_init_ctrl));
    
    button_pulse
    U1_2    (.fpga_clk(clk100_in), .i_clk(clk_1MHz), .button(trg), .button_edge(trg_ctrl));

    button_pulse
    U1_3    (.fpga_clk(clk100_in), .i_clk(clk_1MHz), .button(pause), .button_edge(pause_ctrl));
    
    FSM3
    U2      (.fpga_clk(clk100_in), .sys_init_ctrl(sys_init_ctrl), .trg_ctrl(trg_ctrl), .sw(sw_comb),
             .pause_ctrl(pause_ctrl), .wrk_stat(wrk_stat), .rot_en(rot_en), .adc_en(adc_en), 
             .rf_sw(rf_sw_out), .rot_count(rot_count_out), .pause_out(pause_out));
             
    increment_angle_counter_for_7seg
    U3      (.sys_init_ctrl(sys_init_ctrl), .fpga_clk(clk100_in), .rot_clk(rot_clk), .rot_en(rot_en),
             .bcd_int(bcd_int));         

    tm1637_external_connect
    U4      (.clk25(clk_25MHz), .data(bcd_int), .scl(scl), .sda(sda));

    LED8_counter
    U5      (.sys_init_ctrl(sys_init_ctrl), .fpga_clk(clk100_in), .sys_init(sys_init), .trg(trg),
             .rst(rst), .wrk_stat(wrk_stat), .pause_out(pause_out), .adc_trg(adc_trg_out), 
             .rf_sw_out(rf_sw_out), .led(led_out), .cover_led(cover_led));  
             
endmodule
