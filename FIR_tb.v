`timescale 1ns/1ps
module FIR_tb  #(parameter width = 16, stimulus_num =10,NUM_TAPS=4) ();
	reg		                             arst_n_TB;
	reg		                                clk_TB;
    reg   signed   [width-1:0]               Xn_TB;
    wire  signed   [width-1:0]               Yn_TB;
  // reg  signed   [width-1:0]               Yn_TB;

reg signed [width-1:0] input_stimulus  [0:stimulus_num-1] ;
reg signed [width-1:0] expected_output [0:stimulus_num-1] ;

integer i;

//Initial 
initial
 begin

// System Functions
 $dumpfile("FIR_DUMP.vcd") ;       
 $dumpvars;

//initialization
initialize() ;

//read input txt 
$readmemh("Weighting_filter_input.txt",input_stimulus) ;

//read output txt 
$readmemh("Weighting_filter_output.txt",expected_output) ;

//Reset the design
reset();

// Run test cases
    for (i = 0; i < stimulus_num; i = i + 1) begin
      Xn_TB = input_stimulus[i];
       repeat(NUM_TAPS-1)@(negedge clk_TB);
      if(Yn_TB != expected_output[i])

      	$display("Test %d Failed @time %0t", i ,$time);
      else
      	$display("Test %d Passed @time %0t", i ,$time);
     end

  repeat(1000)@(negedge clk_TB) $stop ;

end 




////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
 begin
  clk_TB    = 1'b0 ; 
  i         = 1'b0 ;

 end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
   arst_n_TB = 1'b1  ;             // rst is deactivated
  @(negedge clk_TB);
   arst_n_TB = 1'b0  ;            // rst is activated
  @(negedge clk_TB);
   arst_n_TB = 1'b1  ;  
 end
endtask

////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #5 clk_TB = ~clk_TB ;


////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////
FIR DUT(
  .clk     (clk_TB),
  .arst_n(arst_n_TB),
  .Xn       (Xn_TB),
  .Yn_reg      (Yn_TB)
);
endmodule 