typedef enum logic[1:0] {S0=2'b00,S1=2'b01} state_f;

// module shift(input [7:0]x ,input state_f func,output rgt);
//     function logic shiftLR(input state_f func,a);
//         if (func == S0) a=a;
//         else if (func == S1) a = (a >> 1) ; //| (a << 8 - 1); //shift left
//         else a = (a << 1) ; // | (a >> 8 - 1); //shift right
//         return a;
//     endfunction
//     function logic shiftCircular(input a,state_f func);
//         if (func == S0) a = a;
//         else if (func == S1) a = (a >> 1) | (a << 8 - 1); //shift left
//         else a = (a << 1) | (a >> 8 - 1); //shift right
//         return a;
//     endfunction
    
//     assign rgt = shiftLR(x,func); //1.3
//     // #1 LED =rgt; 

// endmodule: shift

module rgt(input logic rgt_in,clk, clr,load,output logic out);
	integer counter;
	logic [7:0]register;
	initial begin
		counter = 600;
		register = 8'b0000_0000;
	end
    PLL pll_component(clk_in,clk_out);
	always_ff @(posedge clk_out) begin
        if (counter !=0) counter -=1;
		else begin
        counter = 600;
			if (clr == 0 && load == 1) register = register;
            else if (clr == 0 && load == 0) register = rgt_in;
            else //(clear == 1) 
                register = 8'b0000_0000;
        end
    end
endmodule: rgt

    // function logic rgt(input logic rgt_in,rgt0,clk,_in,clr,load);
	//     integer counter;
    //     counter = 600;
    //     PLL pll_component(clk_in,clk_out);
	//     always_ff @(posedge clk_out) begin
    //         if (counter !=0) counter -=1;
	// 			else begin
    //             counter = 600;
	// 				 if (clr == 0 && load == 1) return rgt0;
    //             else if (clr == 0 && load == 0) return rgt_in;
    //             else //(clear == 1) 
    //                 return 'b0000_0000;
    //         end
    //     end
	// endfunction


module dataPath(input logic a,b,clk_in,sel1,sel2,input state_f func,output logic [7:0]out);
    logic inp,inp2;//,sel//mux
    logic register; //,func//shift
    logic load,clr,oldRgt; //register

    function logic mux8to1(input logic a,b,sel);
        logic o;
        if (sel == 0) return a;
        else return b;
    endfunction

    function logic shiftLR(input state_f func,input logic inp);
        if (func == S0) return inp;
        else if (func == S1) return inp >> 1 ; //| (a << 8 - 1); //shift left
        else return a << 1 ; // | (a >> 8 - 1); //shift right
    endfunction

    initial begin
        register = 'b0000_0000;
        oldRgt = 'b0000_0000;
    end

    rgt(.rgt_in(register), .out(oldRgt), .clk_in(clk), .clr(clr),.load(load));
 
	forever begin
        inp = mux8to1(a,b,sel1); //choose input for first time
        oldRgt = inp2;
        inp2 = mux8to1(inp,oldRgt,sel2);
        register = shiftLR(func,inp2);
        out = oldRgt;
    end    

	endmodule

module top;
    logic inp_a,inp_b,clk,select1,select2;
    logic [7:0]out;
    state_f func;
    initial begin
        inp_a = 8'b1000_0000;
        inp_b = 8'b0000_0001;
        #100 $finish;
    end

    dataPath(inp_a,inp_b,clk,select1,select2,func,out);

endmodule: top
