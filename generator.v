module wave_gen (

   input logic clk, rst_n,
   input logic mode, //waveform selection, 0-sawtooth, 1-triangle
   input logic [2:0] saw, //sawtooth and triangle incline
   input logic [4:0] half_period,

   output logic [4:0] dac_value
);

logic [4+5:0] dac_sawtooth;
logic [4+5:0] dac_triangle;
logic [4:0] dac_next;

logic [5:0] period_cnt;

always_comb begin
    case(mode)
        1'd0: dac_next = dac_sawtooth[4+4:4];
        default: dac_next = dac_triangle[4+4:4];
    endcase
end

always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
		dac_value <= 5'd0;
	else
		dac_value <= dac_next;

always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
		period_cnt <= 0;
	else
		if(period_cnt >= 2*half_period)
			period_cnt <= 0;
		else
			period_cnt <= period_cnt + 1;

always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
		dac_sawtooth <= {5'd0, 5'd0};
	else
		if (period_cnt == half_period || period_cnt == 0)
			dac_sawtooth <= {5'd0, 5'd0};
		else
			if (dac_sawtooth[4+5:5] >= 6'd63)
				dac_sawtooth <= 6'd63<<5;
			else
				dac_sawtooth <= dac_sawtooth + (1 << (saw < 5 ? saw : 5));


always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
		dac_triangle <= 5'd0;
	else
		if (period_cnt < half_period && dac_triangle < 6'd63)
			dac_triangle <= dac_triangle + 1;
		else
			if (period_cnt < half_period && dac_triangle == 6'd63)
				dac_triangle <= 6'd63;
			else
				if ( period_cnt >= half_period && dac_triangle > offset)
					dac_triangle <= dac_triangle - 1;
				else
					dac_triangle <= dac_triangle;

endmodule
