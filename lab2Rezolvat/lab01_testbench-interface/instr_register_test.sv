/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

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

  //timeunit 1ns/1ns;
  import instr_register_pkg::*;
  int seed = 555;

  initial begin
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    myio.write_pointer  = 5'h00;         // initialize write pointer
    myio.read_pointer   = 5'h1F;         // initialize read pointer
    myio.load_en        = 1'b0;          // initialize load control line
    myio.reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge myio.clk) ;     // hold in reset for 2 clock cycles
    myio.reset_n        = 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge myio.clk) myio.load_en = 1'b1;  // enable writing to register
    repeat (3) begin
      @(posedge myio.clk) randomize_transaction;
      @(negedge myio.clk) print_transaction;
    end
    @(posedge myio.clk) myio.load_en = 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=0; i<=2; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @(posedge myio.clk) myio.read_pointer = i;
      @(negedge myio.clk) print_results;
    end

    @(posedge myio.clk) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  end

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    myio.operand_a     <= $random(seed)%16;                 // between -15 and 15
    myio.operand_b     <= $unsigned($random)%16;            // between 0 and 15
    myio.opcode        <= opcode_t'($unsigned($random)%8);  // between 0 and 7, cast to opcode_t type
    myio.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", myio.write_pointer);
    $display("  opcode = %0d (%s)", myio.opcode, myio.opcode.name);
    $display("  operand_a = %0d",   myio.operand_a);
    $display("  operand_b = %0d\n", myio.operand_b);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", myio.read_pointer);
    $display("  opcode = %0d (%s)", myio.instruction_word.opc, myio.instruction_word.opc.name);
    $display("  operand_a = %0d",   myio.instruction_word.op_a);
    $display("  operand_b = %0d\n", myio.instruction_word.op_b);
  endfunction: print_results

endmodule: instr_register_test
