typedef enum logic[1:0] {S0=2'b00,S1=2'b01} state_f;

module shift(input [7:0]x ,input state_f func,output rgt);
    function logic shiftLR(input state_f func,a);
        if (func == S0) a=a;
        else if (func == S1) a = (a >> 1) ; //| (a << 8 - 1); //shift left
        else a = (a << 1) ; // | (a >> 8 - 1); //shift right
        return a;
    endfunction
    function logic shiftCircular(input a,state_f func);
        if (func == S0) a = a;
        else if (func == S1) a = (a >> 1) | (a << 8 - 1); //shift left
        else a = (a << 1) | (a >> 8 - 1); //shift right
        return a;
    endfunction
    
    assign rgt = shiftLR(x,func); //1.3
    // #1 LED =rgt; 

endmodule: shift

module rgt(input rgt_in,input logic clr,load,output rgt_out);
	 reg inp;
	 initial inp = rgt_in;
	 always_comb begin
        if (clr == 0 && load == 1) rgt_out = inp;
        else if (clr == 0 && load == 0) rgt_out = rgt_in;
        else //(clear == 1) 
            rgt_out = 'b0000_0000;
	    end
endmodule: rgt

module dataPath(input a,b,input state_f func,input logic clk_in,sel1,sel2,output logic out);
    logic muxs,inp;//,sel//mux
    logic register; //,func//shift
    logic load,clr,oldRgt; //register

    function logic mux8to1(input a,b,input logic sel);
        logic o;
        if (sel == 0) o = a;
        else o = b;
        return o;
    endfunction
	initial begin
		inp = mux8to1(a,b,sel1);
      oldRgt = inp;
	end
	
    PLL pll_component(clk_in,clk_out);
    always_ff @(posedge clk_out) begin
       muxs = mux8to1(inp,oldRgt,sel2);
       shift(muxs,func,register);
       rgt(.rgt_in(register), .rgt_out(oldRgt), .clr(clr),.load(load));
       out = oldRgt;
    end    

	 endmodule

module top;
    logic inp_a,inp_b,clk,out,select1,select2;
    state_f func;
    initial begin
        inp_a = 8'b1000_0000;
        inp_b = 8'b0000_0001;
        #100 $finish;
    end

    dataPath(inp_a,inp_b,func,clk,select1,select2,out);

endmodule: top
