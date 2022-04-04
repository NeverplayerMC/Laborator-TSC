/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter:
 * User-defined type definitions
 **********************************************************************/
package instr_register_pkg;
  //timeunit 1ns;

  typedef enum logic [3:0] {
  	ZERO,
    PASSA, //valoarea a
    PASSB, //valoarea b
    ADD,   //signed add
    SUB,   //signed substract
    MULT,  //signed mult
    DIV,   //signed div
    MOD    //signed modulo
  } opcode_t;

  typedef logic signed [31:0] operand_t;
  typedef logic signed [63:0] operand_r;
  
  typedef logic [4:0] address_t;
  
  typedef struct {
    opcode_t  opc;
    operand_t op_a;
    operand_t op_b;
	operand_t result;
  } instruction_t;

endpackage: instr_register_pkg
