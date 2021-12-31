`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/20 18:32:06
// Design Name: 
// Module Name: LED8_counter
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


module LED8_counter(
    input sys_init_ctrl,
    input fpga_clk,
    
    input sys_init,
    input trg,
    input rst,
    input wrk_stat,
    input pause_out,
    input adc_trg,
    input [3:0] rf_sw_out,
    
    output reg [3:0] led,
    output reg [8:0] cover_led
    );
      
    always @(posedge fpga_clk) begin
        if (sys_init_ctrl) begin
            led[3:0] <= 4'b0000;
            cover_led[8:0] <= 9'b0000_0000_0;
            end
        else begin
            led[3] <= sys_init;
            led[2] <= trg;
            led[1] <= rst;
            led[0] <= wrk_stat;
            cover_led[8:5] <= rf_sw_out;
            cover_led[4] <= adc_trg;
            cover_led[3] <= sys_init;
            cover_led[2] <= pause_out;
            cover_led[1] <= trg;
            cover_led[0] <= wrk_stat;
        end
    end 
    
    
endmodule
