module FIR #(parameter width = 16 ,  NUM_TAPS=4) ( 
	input  wire 		                             arst_n,
	input  wire 		                                clk,
    input  wire  signed    [width-1:0]                   Xn,
    output reg   signed    [width-1:0]                   Yn_reg
	
);

//internal registers 
reg signed  [width-1:0] delayed_reg [NUM_TAPS-1:0] ;
wire signed [width-1:0] Yn; 
integer i,d;

always @(posedge clk or negedge arst_n) begin 
	if(~arst_n) begin

			 for (i = 0; i < NUM_TAPS; i=i+1) begin
                 delayed_reg [i] <=0;
             end
			         Yn_reg      <=0;
		
	end else begin
	     	     for (d= NUM_TAPS-1; d >0 ; d=d-1) begin     //x(n-1) = x(n)
                     delayed_reg [d] <= delayed_reg [d-1];
                        end
                      delayed_reg[0] <= Xn;
                       Yn_reg        <= Yn ;                            //output registering
	end      
end

//output assigned with arithematic shift having H=[1 0.5 0.25 0.125]
assign Yn = (Xn + (delayed_reg[1]>>>1) + (delayed_reg[2]>>>2) + (delayed_reg[3]>>>3) ) >>>2  ;

endmodule   