// ---------------------------------------------------- //
//        	  MEAN AVERAGE FILTER
//          Mauricio Montanares, 2021
// ---------------------------------------------------- //     


module MAF_FILTER #(parameter N=16)
(
  input wire clk,
  input wire rst,
  input wire we,
  input wire [N-1:0] data_in,
  output reg [N-1:0] data_out 
);

reg [2*N-1:0] acumulador = 0;
reg [2:0] phase = 0; 


always @(posedge clk) begin
    if (rst) begin
        acumulador <= 0;
        phase <= 3'b000;
    end

    else begin 
        if (we) begin
            if (phase <= 3) begin
                acumulador <= acumulador + data_in;
                phase <= phase + 1;
            end

            if (phase == 3) begin
                    data_out <= (acumulador >> 2); //average
            end

            if (phase == 4) begin
                    acumulador <= 0;
                    phase <= 0; 
            end  
        end     
    end
end

endmodule
// ------ TOP MODULE END ------- //
