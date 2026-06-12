`timescale 100us/10us

module tb;

reg clk, rst_n;
reg [2:0] inc;
reg mode;
wire [4:0] dac_value;
wave_gen dut (.clk(clk), .rst_n(rst_n), .inc(inc), .mode(mode), .dac_value(dac_value));

always #10 clk = ~clk;

initial begin
    $dumpfile("wave_gen.vcd");  
    $dumpvars(0, tb);

    clk = 0;
    rst_n = 1;
	mode = 0;
    inc = 4;

    #2 rst_n = 0;
    #4 rst_n = 1;
    #2000;

    for(int i = 3; i>=0; i--)begin
        inc = i;
        #2000;
    end
    

    mode = 1;
    inc = 4;
    #2 rst_n = 0;
    #4 rst_n = 1;
    #4000;
    for(int i = 3; i>=0; i--)begin
        inc = i;
        #4000;
    end

    $finish;
end

endmodule