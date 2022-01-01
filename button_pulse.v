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

// This module is degigned with FSM (Finite States Machine) method.
    // It is recommended to search WHAT IS FSM.
// This module make button signal stabilized.
module button_pulse(fpga_clk, i_clk, button, button_edge);
    input fpga_clk;
    input i_clk;
    input button;
    output button_edge;
    
    reg [1:0] state = 00;
    wire [1:0] inputsignal;
    
    assign inputsignal[0] = button;
    assign inputsignal[1] = i_clk;
    
    always @(posedge fpga_clk) begin
        if(inputsignal == 2'b00)
            state <= 00;
        if(state == 00)
            case (inputsignal)
                2'b00 : state <= 2'b00;
                2'b01 : state <= 2'b00;
                2'b10 : state <= 2'b00;
                2'b11 : state <= 2'b01;
            endcase
        else if(state == 01)
            case (inputsignal)
                2'b00 : state <= 2'b00;
                2'b01 : state <= 2'b10;
                2'b10 : state <= 2'b10;
                2'b11 : state <= 2'b01;
            endcase
        else if(state == 10)
            case (inputsignal)
                2'b00 : state <= 2'b00;
                2'b01 : state <= 2'b10;
                2'b10 : state <= 2'b00;
                2'b11 : state <= 2'b10;
            endcase
        else if (state == 11)
            state = 2'b00;
    end
    
    assign button_edge = state[0];
    
endmodule
