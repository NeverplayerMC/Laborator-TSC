/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/
//DE RULAT CU 10 SEEDS
module instr_register_test (tb_ifc myio);
  //import instr_register_pkg::*;  // user-defined types //are defined in instr_register_pkg.sv
  //(input  logic          clk,
  // output logic          load_en,
  // output logic          reset_n,
  //output operand_t      operand_a,
  //output operand_t      operand_b,
  //output opcode_t       opcode,
  //output address_t      write_pointer,
  //output address_t      read_pointer,
  //input  instruction_t  instruction_word
  //);
	//inafara de initial begin, tot intra in clasa(functii,taskuri, if)
	//DEFINIRE CLASA:
	//class nume
	//virtual interface(tb_ifc.tb)
	//..metode
	//endclass
  //timeunit 1ns/1ns;
  import instr_register_pkg::*;
  //seedul este valoarea initiala cu care incepe randomizarea

class main_class;
  virtual tb_ifc.tb myio;
  covergroup my_cov;
		coverpoint myio.cb.instruction_word.op_a{
			bins op_a_values_neg={[-15:-1]};
			bins op_a_values_zero={0};
			bins op_a_values_pos={[1:15]};
		}
		coverpoint myio.cb.instruction_word.op_b{
			bins op_b_values_zero={0};
			bins op_b_values={[1:15]};
		}
		coverpoint myio.cb.instruction_word.opc{
			bins op_code_values={[0:7]};
		}
		coverpoint myio.cb.instruction_word.result{
			bins res_values_neg={[-255:-1]};
			bins res_values_zero={0};
			bins res_values_pos={[1:255]};
		}
		//COVER POINT PENTRU RESULT TEMA!!!
	endgroup
  //int seed = 555;
  //parameter number_of_op <= 100;
  function new(virtual tb_ifc.tb manio);
	myio=manio;
	my_cov=new();
  endfunction;
  
  task run();
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");
    $display(    "********************FIRST HEADER***************************");
    $display("\nReseting the instruction register...");
    myio.cb.write_pointer <= 5'h00;         // initialize write pointer
    myio.cb.read_pointer  <= 5'h1F;         // initialize read pointer
    myio.cb.load_en       <= 1'b0;          // initialize load control line
    myio.cb.reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge myio.cb) ;        // hold in reset for 2 clock cycles
    myio.cb.reset_n       <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge myio.cb) myio.cb.load_en <= 1'b1;  // enable writing to register
    repeat (50) begin
      @(posedge myio.cb) randomize_transaction;
      @(negedge myio.cb) print_transaction;
	  my_cov.sample();
    end
    @(posedge myio.cb) myio.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=49; i>=0; i--) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @(posedge myio.cb) myio.cb.read_pointer <= i;
      @(negedge myio.cb) print_results;
	  my_cov.sample();
    end
	repeat (50) begin
      @(posedge myio.cb) myio.cb.read_pointer <= $unsigned($random)%10;;
      @(negedge myio.cb) print_results;
	  
    end


    @(posedge myio.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  endtask

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    // In funcite nu putem avea instructiuni temporale, in task da
    static int temp = 0;
    myio.cb.operand_a     <= $urandom%16;                 // between -15 and 15
    myio.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    myio.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    myio.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing at time: %0d nanoseconds", $time);
    $display("Writing to register location %0d: ", myio.cb.write_pointer);
    $display("  opcode = %0d (%s)", myio.cb.opcode, myio.cb.opcode.name);
    $display("  operand_a = %0d",   myio.cb.operand_a);
    $display("  operand_b = %0d\n", myio.cb.operand_b);
  endfunction: print_transaction

  function void print_results;
    //displaying time
    $display("Printing at time: %0d nanoseconds", $time);
    $display("Read from register location %0d: ", myio.cb.read_pointer);
    $display("  opcode = %0d (%s)", myio.cb.instruction_word.opc, myio.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   myio.cb.instruction_word.op_a);
    $display("  operand_b = %0d", myio.cb.instruction_word.op_b);
	$display("  result    = %0d\n", myio.cb.instruction_word.result);
	if(myio.cb.instruction_word.opc==PASSA)
	begin
		if(myio.cb.instruction_word.op_a==myio.cb.instruction_word.result)
		begin
			$display("VERIFICATION OF  PASSA operand_a = %0d and result = %0d is true",   myio.cb.instruction_word.op_a, myio.cb.instruction_word.result);
		end
		else
		begin
			$display("VERIFICATION OF  PASSA operand_a = %0d and result = %0d is false",   myio.cb.instruction_word.op_a, myio.cb.instruction_word.result);
		end
	end
  endfunction: print_results

	

endclass

initial begin
		main_class test_cl;
		test_cl=new(myio);
		test_cl.run();
	end

endmodule: instr_register_test
