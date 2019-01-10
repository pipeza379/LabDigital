
module shift(input [7:0]x ,func,output [7:0]LED,rgt);
    logic func0;
    initial func0 = 0;

    function logic shiftLR(input a,func);
        always_comb begin
            if (fucn == 2'b00) a=a;
            else if (func == 2'b01) a = (a >> 1) ; //| (a << 8 - 1); //shift left
            else a = (a << 1) ; // | (a >> 8 - 1); //shift right
        end
        return a
    endfunction
    function logic shiftCircular(input a,func);
        always_comb begin
            if (fucn == 2'b00) a=a;
            else if (func == 2'b01) a = (a >> 1) | (a << 8 - 1); //shift left
            else a = (a << 1) | (a >> 8 - 1); //shift right
        end
        return a
    endfunction
    
    rgt = shiftCircular(x,func) //2.1,2.2
    rgt0 = shiftCircular(x,func) //2.3
    #1 LED =rgt0; //2,3
    #1 LED =rgt; 

endmodule: shift

module rgt(input rgt_in,input logic clk,clr,load,output rgt_out);
    PLL pll_component(clk,clk_out);
    always_ff @(posedge clk_out) begin
        if (clr == 0 && load == 1) register = x;
        else if (clr == 0 && load == 0) rgt_out = rgt_in;
        else //(clear == 1) 
            rgt_out = 8'b0000_0000;
endmodule: rgt

module dataPath(input a,b,input logic clk,output logic [7:0]LED);
    logic sel,mux,inp;//mux
    logic func,register; //shift
    logic load,clr,oldRgt; //register

    initial begin
        sel = 0;
        // func = 2'b01;
        func = 1;
        oldRgt = mux8to1(a,b,sel);
    end

    function logic mux8to1(input a,b,input logic sel);
        logic o;
        always_comb begin
            if (sel == 0) o = a;
            else o = b;
        end
        return o;
    endfunction

    inp = mux8to1(a,b,sel);

    forever begin
       mux = mux8to1(inp,oldRgt)
       shift(mux,func,LED,register)
       rgt(.rgt_in(register), .rgt_out(oldRgt), .clk(clk), .clr(clr),.load(load))
    end    

endmodule: dataPath

module top:
    logic inp_a,inp_b,clk,[7:0]led;

    initial begin
        inp_a = 8'b1000_0000;
        inp_b = 8'b0000_0001;
        #100 $finish
    end

    dataPath(inp_a,inp_b,clk,led)
endmodule: top
