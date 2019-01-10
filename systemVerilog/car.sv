typedef enum logic[1:0] {A=2'b00,B=2'b01,C=2'b10} state_t;

module next_state(input logic a, res, state_t cs, output state_t ns);
    always_comb begin
        if (res)
        ns = A;
        else if (cs == A)
            if (a == 0) ns = A;
            else ns = B;
        else if (cs == B)
            if (a == 0) ns = C;
            else ns = B;
        else if (cs == C) ns = A;
    end
endmodule

module d_flipflop(input logic d,clk,output logic q);
    always_ff @(posedge clk) begin
        q <= d;
    end    
endmodule

module gen_output(input state_t cs, output logic o);
    assign o = (cs == B) ? 1 : 0;
    // A : i=0,o=0 i=1,o=0 B:i=0,o=1 i=1,o=1 i=1/0 o=0
endmodule

module fsm( input logic in, clk, res, output logic out);
    state_t cs,ns;

    //connect module
    next_state nxt (.a(in), .res(res), .cs(cs), .ns(ns));
    d_flipflop b0 (.d(ns[0]), .clk(clk), .q(cs[0]));
    d_flipflop b1 (.d(ns[1]), .clk(clk), .q(cs[1]));
    gen_output out_comb ( .cs(cs), .o(out));
endmodule

module testbench (input logic fsm_out, output logic fsm_in,clk,res);
    initial begin
        fsm_in = 0;
        res = 1;
        #1 res = 0;
        #2 fsm_in = 1;
        #5 fsm_in = 0;
        #6 fsm_in = 1;
        #8 $finish;
    end

    initial begin
        clk = 0;
        forever #1 clk = ~clk;
        end
endmodule

module top;
    logic fsm_in, fsm_out, clk, res;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end

    testbench tb( .fsm_in(fsm_in), .fsm_out(fsm_out), .clk(clk), .res(res));
    fsm fsm1( .in(fsm_in), .out(fsm_out), .clk(clk), .res(res));
endmodule