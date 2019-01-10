module lightFlow (input logic clk_in,output logic LED7,LED6,LED5,LED4,LED3,LED2,LED1,LED0);
	logic clk_out;
	logic [7:0] a;
	integer counter;
	
	initial begin
		counter = 2400;
		a = 8'b0111_1111;
		{LED7,LED6,LED5,LED4,LED3,LED2,LED1,LED0} = a;
	end
	
	PLL pll_component(clk_in,clk_out);
	always_ff @(posedge clk_out) begin
		if(counter != 0)
			counter = counter - 1;
		else begin
		   counter = 2400;
			a = (a >> 1) | (a << 8 - 1);
			{LED7,LED6,LED5,LED4,LED3,LED2,LED1,LED0} = a;
			end
		end
endmodule: lightFlow
	
	
		