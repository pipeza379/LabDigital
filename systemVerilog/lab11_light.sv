module light(input logic x1,x2,clk_in, inout logic f);
    logic clk_out;
    integer counter1, counter2;

    initial begin
        counter1 = 512;
        counter2 = {x2,x1};
        f=0;
    end    
    
    PLL pll_component(clk_in,clk_out);
    always_ff @(posedge clk_out) begin
        if(counter1 != 0)
            counter1 = counter1 - 1;
        else begin
            counter1 = 512;
            if(counter2 == 0) begin
            f = ~f;
            counter2 = {x2,x1};
            end
            else
                counter2 = counter2 - 1;
        end
    end
endmodule: light