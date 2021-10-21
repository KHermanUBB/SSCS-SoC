// ---------------------------------------------------- //
//        	       FILTERS 
// ---------------------------------------------------- //  

// phase state: FIR 0-4 | IIR 5-10 | MAF 11-15

`define USE_POWER_PINS

module Filters  #(parameter N  = 16)
  ( 
    input         clk,
    input         rst,
    input          en,
    // --- FIR in/outs begin --- //
    input signed [N-1:0] X_fir,
    input signed [N-1:0] b0_fir,
    input signed [N-1:0] b1_fir,
    output signed [N-1:0]   Y_fir,
    // --- FIR in/outs end --- //

    // --- IIR in/outs begin --- //
    input signed [N-1:0] X_iir,
    input signed [N-1:0] a0_iir,
    input signed [N-1:0] a1_iir,
    input signed [N-1:0] a2_iir,
    input signed [N-1:0] b1_iir,
    input signed [N-1:0] b2_iir,
    output signed  [N-1:0] Y_iir,
    // --- IIR in/outs end --- //

    // --- MAF in/outs begin --- //
    input [N-1:0] X_maf,
    output [N-1:0] Y_maf 
    // --- MAF in/outs end --- //
    );


//circuit architecture
reg signed [N-1:0] mux_coeff;
reg signed [N-1:0] mux_xy;
wire signed [2*N-1:0] product;
wire [N-1:0] aritmetic_shift;
reg signed [N-1:0] add1;
reg signed [N-1:0] result;

//fir REGs
reg signed [N-1:0] X1_fir, X2_fir, X3_fir, Yt_fir;

//iir REGs
reg signed [N-1:0] X1_iir, X2_iir;
reg signed [N-1:0] Yt_iir, Y1_iir, Y2_iir;
 
//maf REGs
reg  [N-1:0] X1_maf, X2_maf, X3_maf, Yt_maf;

//out REGs 
assign Y_fir = Yt_fir;
assign Y_iir = Yt_iir;
assign Y_maf = (Yt_maf >> 2);



// -------  fir, iir and maf samples flow start ------- //
always@(posedge clk) begin
    if(rst) begin

        //output regs
        Yt_fir <= 0;
        Yt_iir <= 0;
        Yt_maf <= 0;

        //fir
        X1_fir <= 0;
        X2_fir <= 0;
        X3_fir <= 0;

        //iir
        Y1_iir <= 0;
        Y2_iir <= 0;
        X1_iir <= 0;
        X2_iir <= 0;

        //maf
        X1_maf <= 0;
        X2_maf <= 0;
        X3_maf <= 0;

    end

    else if(en == 1) begin
        //fir 
        X1_fir <= X_fir;
        X2_fir <= X1_fir;
        X3_fir <= X2_fir;



        //iir
        Y1_iir <= Yt_iir; 
        Y2_iir <= Y1_iir;
        X1_iir <= X_iir;
        X2_iir <= X1_iir;

        //maf
        X1_maf <= X_maf;
        X2_maf <= X1_maf;
        X3_maf <= X2_maf;
    end

   else if(phase == phase4)
        Yt_fir <= result;
   else if(phase == phase10)
        Yt_iir <= result;
   else if(phase == phase15)
        Yt_maf <= result; 

end

// -------  fir, iir and maf samples flow end ------- //



// ================== FSMs start ================== //

reg [4:0] phase; //state
reg [4:0] next_phase; //next_state

parameter phase0 = 0; parameter phase1 = 1;
parameter phase2 = 2; parameter phase3 = 3;
parameter phase4 = 4; parameter phase5 = 5;
parameter phase6 = 6; parameter phase7 = 7;
parameter phase8 = 8; parameter phase9 = 9;

parameter phase10 = 10; parameter phase11 = 11;
parameter phase12 = 12; parameter phase13 = 13;
parameter phase14 = 14;
parameter phase15 = 15;
parameter phase16 = 16;


always @(posedge clk) begin 
        if (rst) 
         phase <= phase0;
        else if(en == 1 )
           phase <= phase0;
        else 
           phase <= next_phase;
end

// ------- MUX's coeffs - Samples FIR/IIR start ------- //
always @(phase or en or aritmetic_shift or X1_maf or  X2_maf or X3_maf) begin



        case(phase)

        //fir Yt = X*b0 + X1*b1 + X2*b1 + X3*b0  
            phase0    : begin
                mux_coeff = b0_fir;
                mux_xy = X_fir;
                add1 = aritmetic_shift;
                next_phase = phase1;
            end

            phase1    : begin
                mux_coeff = b1_fir;
                mux_xy = X1_fir;
                add1 = aritmetic_shift; 
                next_phase = phase2;
            end

            phase2    : begin
                mux_coeff = b1_fir;
                mux_xy = X2_fir;
                add1 = aritmetic_shift;
                next_phase = phase3;   
            end

            phase3    : begin
                mux_coeff = b0_fir;
                mux_xy = X3_fir;
                add1 = aritmetic_shift;
                next_phase = phase4;
            end


            phase4    : begin 
                next_phase = phase5;
            end

             //iir  Y <= X*a0 + X1*a1 + X2*a2 - Y1*b1 - Y2*b2;
            phase5    : begin
                mux_coeff = a0_iir;
                mux_xy = X_iir;
                add1 = aritmetic_shift; 
                next_phase = phase6;
            end

            phase6    : begin
                mux_coeff = a1_iir;
                mux_xy = X1_iir;
                add1 = aritmetic_shift;
                next_phase = phase7;
            end  	

            phase7     : begin
                mux_coeff = a2_iir;
                mux_xy = X2_iir;
                add1 = aritmetic_shift;
                next_phase = phase8;
            end

            phase8    : begin
                mux_coeff = b1_iir;
                mux_xy = -Y1_iir;
                add1 = aritmetic_shift;
                next_phase = phase9;
            end

            phase9    : begin
                mux_coeff = b2_iir;
                mux_xy = -Y2_iir;
                add1 = aritmetic_shift;
                next_phase = phase10; 
            end

            phase10    : begin

                next_phase = phase11; 
            end

            //MAF
            phase11    : begin
                add1 = X_maf;
                next_phase = phase12;
            end

            phase12    : begin
                add1 = X1_maf;
                next_phase = phase13;
            end

            phase13    : begin
                add1 = X2_maf;
                next_phase = phase14;
            end

            phase14    : begin
                add1 = X3_maf;
                next_phase = phase15;
            end
            phase15    : begin
                next_phase = phase16;
            end

             default : begin
                add1 = aritmetic_shift;                
             end  
        endcase
end

// ------- MUX's coeffs - Samples FIR/IIR end ------- //


// ================== FSMs end ================== //


// ------- Math operations begin ------- //
assign product = mux_coeff * mux_xy;
assign aritmetic_shift = product >>> 15;
// ------- Math operations end ------- //


// ------ Acumulacion start -------- //

always @(posedge clk) begin

    if(rst ==1'b1) 
        begin
            result <= 0;
        end
    else  if (en == 1)
            result <= 0;
    else  if (phase == phase4) 
            result <= 0;
    else  if (phase == phase10) 
            result <= 0;
    else
    	result <= result + add1;  //acumulacion

end

// ------ Acumulacion end -------- //

endmodule
