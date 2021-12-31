module FSM3(fpga_clk, sys_init_ctrl, trg_ctrl, sw, pause_ctrl, wrk_stat, rot_en, adc_en, rf_sw, rot_count, pause_out);
	input fpga_clk;
	input sys_init_ctrl;
	input trg_ctrl;
	input [3:0] sw;
	input pause_ctrl;
	
	output reg wrk_stat = 0;
	output reg rot_en = 0;
	output reg adc_en = 0;
	output reg [3:0] rf_sw = 0;
	output reg [9:0] rot_count = 0;
	output pause_out;
	
	reg [31:0] prcs_count = 0;
	reg pause_able = 0;
	reg pause_command = 0;
	integer divider = 1000000;
	
	assign pause_out = (prcs_count != 0) && (~wrk_stat);
	
	always @(posedge fpga_clk) begin
		if (trg_ctrl) wrk_stat <= 1;
		
		if (pause_ctrl && wrk_stat) pause_command <= 1;
		
		if (pause_able & pause_command) begin
			wrk_stat <= 0;
			pause_command <= 0;
		end
		
		if (sys_init_ctrl) begin
			wrk_stat <= 0;
			rot_en <= 0;
			adc_en <= 0;
			rf_sw <= 0;
			prcs_count <= 0;
			rot_count <= 0;
			pause_able <= 0;
		end
		
		if (rot_count == 720) begin
			wrk_stat <= 0;
			pause_able <= 0;
		end
		
		if (wrk_stat) prcs_count <= prcs_count + 1;
		
		case (prcs_count)
			1 * divider : rot_en <= 1;
			6 * divider : begin
				rot_en <= 0;
				pause_able <= 1;
			end
			106 * divider : 
				if (sw == 0)       rf_sw <= 4'b0001;
				else if(sw == 1)  rf_sw <= 4'b0001;
				else if(sw == 2)  rf_sw <= 4'b0010;
				else if(sw == 3)  rf_sw <= 4'b0001;  
				else if(sw == 4)  rf_sw <= 4'b0100;
				else if(sw == 5)  rf_sw <= 4'b0001;
				else if(sw == 6)  rf_sw <= 4'b0010;  
				else if(sw == 7)  rf_sw <= 4'b0001;
				else if(sw == 8)  rf_sw <= 4'b1000;
				else if(sw == 9)  rf_sw <= 4'b0001;  
				else if(sw == 10) rf_sw <= 4'b0010;
				else if(sw == 11) rf_sw <= 4'b0001;
				else if(sw == 12) rf_sw <= 4'b0100;  
				else if(sw == 13) rf_sw <= 4'b0001;
				else if(sw == 14) rf_sw <= 4'b0010;
				else if(sw == 15) rf_sw <= 4'b0001; 
			109 * divider : begin
				adc_en <= 1;
				pause_able <= 0;
			end
			139 * divider : begin 
				adc_en <= 0;
				pause_able <= 1;
				if (sw == 0)       rf_sw <= 4'b0010;
				else if(sw == 1)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 2)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 3)  rf_sw <= 4'b0010;  
				else if(sw == 4)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 5)  rf_sw <= 4'b0100;
				else if(sw == 6)  rf_sw <= 4'b0100;  
				else if(sw == 7)  rf_sw <= 4'b0010;
				else if(sw == 8)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 9)  rf_sw <= 4'b1000;  
				else if(sw == 10) rf_sw <= 4'b1000;
				else if(sw == 11) rf_sw <= 4'b0010;
				else if(sw == 12) rf_sw <= 4'b1000;  
				else if(sw == 13) rf_sw <= 4'b0100;
				else if(sw == 14) rf_sw <= 4'b0100;
				else if(sw == 15) rf_sw <= 4'b0010; 
			end  
			142 * divider : begin
				adc_en <= 1;
				pause_able <= 0;
			end
			172 * divider : begin 
				adc_en <= 0;
				pause_able <= 1;
				if (sw == 0)       rf_sw <= 4'b0100;
				else if(sw == 3)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 5)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 6)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 7)  rf_sw <= 4'b0100;
				else if(sw == 9)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 10) begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 11) rf_sw <= 4'b1000;
				else if(sw == 12) begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 13) rf_sw <= 4'b1000;
				else if(sw == 14) rf_sw <= 4'b1000;
				else if(sw == 15) rf_sw <= 4'b0100;
			end 
			175 * divider : begin
				adc_en <= 1;
				pause_able <= 0;
			end
			205 * divider : begin 
				adc_en <= 0;
				pause_able <= 1;
				if (sw == 0)       rf_sw <= 4'b1000;
				else if(sw == 7)  begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 11) begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 13) begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 14) begin
					rf_sw <= 4'b0000;
					prcs_count <= 0;
					rot_count <= rot_count + 1; 
				end
				else if(sw == 15) rf_sw <= 4'b1000;
			end 
			208 * divider : begin
				adc_en <= 1;
				pause_able <= 0;
			end
			238 * divider : begin
				adc_en <= 0;
				rf_sw <= 4'b0000;
				prcs_count <= 0;
				rot_count <= rot_count + 1;
				pause_able <= 1;
			end
		endcase
	end


endmodule