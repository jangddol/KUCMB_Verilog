`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/06 13:06:31
// Design Name: 
// Module Name: clock_counter
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

module clock_counter
    #(
    parameter from = 100, // 100Hz
    parameter to = 1,      // 1Hz
    parameter reverse_clk = 0  //if reverse_clk = 1, then reverse the o_clk
    )(
    input i_clk, rst,
    output wire o_clk
    );
    
    localparam integer countnum = from / to / 2;
    
    reg [31:0] cnt = 1;
    
    reg clk_out = 0;
    
    if (reverse_clk == 0)
        assign o_clk = clk_out;
    else
        assign o_clk = ~clk_out;
    
    always @(posedge i_clk) begin
        if (rst == 1) begin
            cnt <= 1;
            clk_out <= 0;
            end
        
        if (cnt == countnum) begin
            clk_out <= ~clk_out;
            cnt <= 1;
            end
        else
            cnt <= cnt + 1;
    end
endmodule


//module clock_counter
//    #(
//    parameter from = 100, // 100Hz
//    parameter to = 1,      // 1Hz
//    parameter reverse_clk = 0  //if reverse_clk = 1, then reverse the o_clk
//    )(
//    input i_clk, rst,
//    output reg o_clk
//    );
    
//    localparam integer N = from / to;
//    localparam void = 0;
//    localparam integer MSB = MSB_calc(void);
    
//    localparam ZERO = 1 & reverse_clk;
//    localparam ONE = ~(1 & reverse_clk);
//    reg [MSB - 1 : 0] cnt;
    
//    always @(posedge i_clk) begin
//        if(rst || cnt == (N - 1)) cnt <= 0;
//        else cnt <= cnt + 1;
//    end
	 
//	 always @ (posedge i_clk) begin
//        if(rst || cnt <= (N/2 - 1)) o_clk <= ONE;
//        else if(cnt <= (N - 1)) o_clk <= ZERO;
//        else o_clk <= ONE;
//    end
    
////-----------------------------------------------------------    
//    function automatic integer MSB_calc(input redundant);   //?? function input ?¡Æ ??.
//    integer n;
//    begin   
//        MSB_calc = 0;
//        for(n = N;  n;  n = n/2)        // n = N : copying parameter N to n
//            MSB_calc = MSB_calc + 1; 
//    end
//    endfunction
    
    
//// ---- another way to get MSB of N ----    
////    parameter MSB = N >> 4 ? (N >> 4 ? (N >> 4 ? (N >> 4 ? (N >> 4 ? (N >> 4 ? (N >> 4 ? (N >> 4 ? 
////    36 : 32) : 28) : 24) : 20) : 16) : 12) : 8) : 4;    // Find the maximum possible number of bits up to N < 2**36
//endmodule

