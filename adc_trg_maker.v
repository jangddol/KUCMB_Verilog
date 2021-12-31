`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/24 19:40:14
// Design Name: 
// Module Name: trg_pulse
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

module adc_trg_maker(fpga_clk, adc_en, adc_trg_out);
    input fpga_clk;
    input adc_en;
    output reg adc_trg_out;
    
    reg [19:0]counter;
    
    always @(negedge fpga_clk) begin
        if(~adc_en) begin
            counter <= 0;
            adc_trg_out <= 0;
        end
        
        if(adc_en) begin
            counter <= counter + 1;
        end
        
        if(counter == 50000) begin
            counter <= 1;
            adc_trg_out <= ~adc_trg_out;
        end
    end
    
endmodule
