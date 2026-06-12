module wave_gen (

   input logic clk, rst_n,
   input logic mode, //waveform selection, 0-sawtooth, 1-triangle
   input logic [2:0] inc, //sawtooth and triangle incline
   output logic [4:0] dac_value
);

logic [4+4:0] dac_sawtooth;
logic [4+4:0] dac_triangle;
logic [4:0] dac_next;

logic [5:0] period_cnt;
logic [4:0] half_period = 5'd31;
logic up_down;

assign dac_next = (mode == 1'd0) ? dac_sawtooth[8:4] : dac_triangle[8:4];

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
		dac_sawtooth <= {5'd0, 4'd0};
	else
		if (period_cnt == half_period || period_cnt == 2*half_period)
			dac_sawtooth <= {5'd0, 4'd0};
		else
			dac_sawtooth <= dac_sawtooth + (1 << (inc < 4 ? inc : 4));

always_ff@(posedge clk, negedge rst_n)
	if(!rst_n)
		up_down <= 1'b1;
	else
		if(period_cnt == half_period - 1)
			up_down <= 1'b0;
			else if(period_cnt >= 2*half_period - 1)
				up_down <= 1'b1;

always_ff @(posedge clk, negedge rst_n)
	if(!rst_n)
		dac_triangle <= 9'd0;
	else
		if (period_cnt == 2*half_period)
			dac_triangle <= 9'd0;
		else
			if (up_down)
				dac_triangle <= dac_triangle + (1 << (inc < 4 ? inc : 4));
			else
				dac_triangle <= dac_triangle - (1 << (inc < 4 ? inc : 4));
endmodule
