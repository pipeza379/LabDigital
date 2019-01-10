module plus(input logic [7:0]inp_a,inp_b,k1,clk,output logic [7:0]out);
    logic [7:0]a,b;
    initial begin
        a = inp_a;
        b = inp_b;
    end

    assign out = a+b;
    // always @(posedge clk) begin
    //     out <= (k1 == 0)? 8'b0:a+b;
    // end
endmodule

module led(input logic [7:0]inp,output logic [7:0]led);
    assign led = ~inp;
endmodule

module debound(input logic clk,s0,s1,k0,output logic [7:0]a,b);
    logic inp1,inp2,enable;
    logic [7:0]c0,c1;
    int count;
    initial count = 0;

    always_ff @(posedge clk) begin
        if (count < 7) begin
            if (k0==0) begin
                inp1 = s0;
                inp2 = s1;
				enable = 1;
            end else if (enable ==1 && k0 ==1) begin
                c1[count] = inp2;
                c0[count] = inp1;
                count+=1;
                enable = 0;
            end else begin
                inp1 = 0; 
                inp2 = 0;
            end
        end else begin
            a=c1;b=c0;
            count = 0;
        end
    end
endmodule

module adder(input logic s0,s1,k0,k1,clk,output logic [7:0]led);
    logic [7:0]a,b,out;

    function reset(input logic [7:0]x,input logic k1);
        if (k1 == 0) begin
            x = 8'b0;
        end else x = x;
        return x;
    endfunction

    always_ff @(posedge clk) begin
        a = reset(a,k1);
		b = reset(b,k1);
    end
    
    debound db(clk,s0,s1,k0,a,b);
    plus add(a,b,k1,clk,out);
    led l(out,led);
endmodule 

module top;
    logic s0,s1,k0,k1,clk;
    logic [7:0]led;
	
    adder main(s0,s1,k0,k1,clk,led);
endmodule
    
