module shift(input [7:0]x input logic clear,load, output logic [7:0]LED);
    logic register;

    function register(input x,oldRgt,input logic clk,input int clear,load);
        logic register
        PLL pll_component(clk,clk_out);
        always_comb begin    
            always_ff @(posedge clk_out) begin
                if (clear == 0 && load == 1) register = x;
                else if (clear == 1) register = 0;
            end
            if (clear == 0 && load == 0) register = oldRgt;
        end
        return register;
    endfunction

    function shift(input a,input int func,output [7:0]LED);
        always_comb begin
            if (fucn == 00) a=a;
            else if (func == 01) a = (a >> 1) ; //| (a << 8 - 1); //shift left
            else a = (a << 1) ; // | (a >> 8 - 1); //shift right
            LED = a;
        end
    endfunction

    function shiftCircular(input func,a,output [7:0]LED);
        always_comb begin
            if (fucn == 00) a=a;
            else if (func == 01) a = (a >> 1) | (a << 8 - 1); //shift left
            else a = (a << 1) | (a >> 8 - 1); //shift right
            LED = a;
        end
    endfunction    

    initial begin
        register = 0;        
    end

    @(posedge clk) 
    

endmodule: shift

module top;
    logic x,clear,load,LED;

    shift(x,clear,load,LED);
endmodule