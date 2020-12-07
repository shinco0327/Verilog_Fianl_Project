module LFSR_5bit(clk, prn, rst, easy_t, normal_t, extreme_t);
    input clk, rst;
    output [4:0] prn;
    output easy_t, normal_t, extreme_t;
 

    reg [9:0] D123456789 = 10'd1; //NEVER 000000

    assign prn[0] = D123456789[9];
    assign prn[1] = D123456789[1];
    assign prn[2] = D123456789[5];
    assign prn[3] = D123456789[3];
    assign prn[4] = D123456789[2];

    assign easy_t = prn[2] & prn[0]; 
    assign normal_t = prn[1] | prn[2];
    assign extreme_t = prn[1] | prn[2] | prn[4];
    

    always @ (posedge rst or posedge clk)
    if (rst)
        begin
            D123456789 <= 10'd88;
        end
    else
        begin
            D123456789[1] <= D123456789[0];
            D123456789[2] <= D123456789[1];
            D123456789[3] <= D123456789[2];
            D123456789[4] <= D123456789[3];
            D123456789[5] <= D123456789[4];
            D123456789[6] <= D123456789[5];
            D123456789[7] <= D123456789[6];
            D123456789[8] <= D123456789[7];
            D123456789[9] <= D123456789[8];
            D123456789[0] <= D123456789[9]^ D123456789[8];
        end

  
endmodule
