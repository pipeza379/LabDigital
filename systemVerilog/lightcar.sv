typedef enum logic[2:0] {IDLE=3'b000,L1=3'b001,L2=3'b010,L3=3'b011,R1=3'b100,R2=3'b101,R3=3'b110,LR=3'b111} state_t;

module next_out_state(input logic clk,k, s0, s1,input state_t cs, output state_t ns,output logic l7,l6,l5,l2,l1,l0);
    always_comb begin
        if (k == 1) begin 
            ns = LR;
            if (clk == 0) {l7,l6,l5,l2,l1,l0}=6'b000_000;
            else {l7,l6,l5,l2,l1,l0}=6'b111_111;
            end
        else if (cs == L1 && s0 == 1) begin
            ns = L2;
            {l7,l6,l5,l2,l1,l0}=6'b001_000;
            end
        else if (cs == L2 && s0 == 1) begin
            ns = L3;
            {l7,l6,l5,l2,l1,l0}=6'b011_000; 
            end
        else if (cs == L3 && s0 == 1) begin
            ns = IDLE;
            {l7,l6,l5,l2,l1,l0}=6'b111_000;
            end
        else if (cs == R1 && s0 == 0 && s1 == 1) begin
            ns = R2;
            {l7,l6,l5,l2,l1,l0}=6'b000_100;
            end
        else if (cs == R2 && s0 == 0 && s1 == 1) begin
            ns = R3;
            {l7,l6,l5,l2,l1,l0}=6'b000_110;
            end
        else if (cs == R3 && s0 == 0 && s1 == 1) begin
            ns = IDLE;
            {l7,l6,l5,l2,l1,l0}=6'b000_111;
            end
        else begin
            ns = IDLE;
            {l7,l6,l5,l2,l1,l0}=6'b000_000;
            end
    end
endmodule

module d_flipflop(input logic d,clk,output logic q);
    always_ff @(posedge clk) begin
        q <= d;
    end    
endmodule

// module gen_output(input state_t cs,clk, output logic l7,l6,l5,l2,l1,l0);
//     always_comb begin
//         if (cs == LR)
//             if (clk == 0) {l7,l6,l5,l2,l1,l0}=6'b000_000;
//             else {l7,l6,l5,l2,l1,l0}=6'b111_111;
//         else:
//             case(cs)
//                 3'b000:{l7,l6,l5,l2,l1,l0}=6'b000_000
//                 3'b001:{l7,l6,l5,l2,l1,l0}=6'b001_000
//                 3'b010:{l7,l6,l5,l2,l1,l0}=6'b011_000
//                 3'b011:{l7,l6,l5,l2,l1,l0}=6'b111_000
//                 3'b100:{l7,l6,l5,l2,l1,l0}=6'b000_100
//                 3'b101:{l7,l6,l5,l2,l1,l0}=6'b000_110
//                 3'b110:{l7,l6,l5,l2,l1,l0}=6'b000_111
//             endcase
//     end
// endmodule

module fsm( input logic k,sw0,sw1, clk, output logic l7,l6,l5,l2,l1,l0);
    state_t cs,ns;

    //connect module
    next_out_state nxt (clk,k,sw0,sw1,cs,ns,l7,l6,l5,l2,l1,l0);

    // next_state nxt (.k(k), .sw0(sw0), .sw1(sw1), .cs(cs), .ns(ns));
    // gen_output out_comb ( .cs(cs),.clk(clk),.l7(l7),.l6(l6),.l5(l5),.l2(l2),.l1(l1),.l0(l0));
    d_flipflop b0 (.d(ns[0]), .clk(clk), .q(cs[0]));
    d_flipflop b1 (.d(ns[1]), .clk(clk), .q(cs[1]));
    d_flipflop b2 (.d(ns[2]), .clk(clk), .q(cs[2]));
endmodule

module setdefault (output logic k,s0,s1,clk_out);
	logic clk_in; 
    initial begin
        k = 0;
        s0 =0;
        s1 =0;
        #3 $finish;
    end
	 PLL pll_component(clk_in,clk_out);
endmodule

module car;
    logic k,sw0,sw1,l7,l6,l5,l2,l1,l0,clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end

    setdefault tb(k,sw0,sw1,clk);
    fsm fsm1( .k(k), .sw0(sw0), .sw1(sw1), .clk(clk),.l7(l7),.l6(l6),.l5(l5),.l2(l2),.l1(l1),.l0(l0));
endmodule