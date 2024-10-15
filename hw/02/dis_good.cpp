#include <iostream>

using namespace std;

void dis(unsigned int instruction);

int main(int argc, char **argv) {
  dis(0x2041ff9c); // addi $at, $v0, -100
  dis(0x24830001); // addiu $v1, $a0, 1
  dis(0x28c50020); // slti $a1, $a2, 0x20
  dis(0x2d0703e8); // sltiu $a3, $t0, 1000
  dis(0x3149003f); // andi $t1, $t2, 0x3f
  dis(0x358b08e0); // ori $t3, $t4, 0x08e0
  dis(0x39cd0040); // xori $t5, $t6, 0x40
  dis(0x3c0f0400); // lui $t7, 0x0400
  dis(0x02328020); // add $s0, $s1, $s2
  dis(0x02959821); // addu $s3, $s4, $s5
  dis(0x0017b022); // sub $s6, $zero, $s7
  dis(0x033ac023); // subu $t8, $t9, $k0
  dis(0x039dd824); // and $k1, $gp, $sp
  dis(0x03e9f025); // or $fp, $ra, $t1
  dis(0x00858026); // xor $s0, $a0, $a1
  dis(0x00c78827); // nor $s1, $a2, $a3
  // cout << "hi" << endl;
  // dis(0xAC690000); // sw $t1, 0($t3)
  // dis(0x8D410000); // lw $t1, 0($t2)
}
const char *I_table[] = {"addi", "addiu", "slti", "sltiu",
                         "andi", "ori",   "xori", "lui"};
unsigned int LUI = 15; // Opcode for LUI instruction
const char *R_table[] = {"add", "addu", "sub", "subu",
                         "and", "or",   "xor", "nor"};
const char *regs[] = {"$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
                      "$t0",   "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
                      "$s0",   "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
                      "$t8",   "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"};
/*
 * disassemble(instruction) -- Prints MIPS assembly language for instruction.
 */
void dis(unsigned int instruction) {
  unsigned int op = (instruction & 0xfc000000) >> 26;
  unsigned int rs = (instruction & 0x03e00000) >> 21;
  unsigned int rt = (instruction & 0x001f0000) >> 16;
  if (0x08 <= op && op <= 0x0f) { // if I-format instruction
    short imm = instruction & 0x0000ffff;
    cout << I_table[op - 8] << '\t' << regs[rt];
    if (op != LUI)
      cout << ", " << regs[rs];
    cout << ", " << imm << endl;
  } else if (op == 0x00) { // else R-format instruction
    unsigned int rd = (instruction & 0x0000f800) >> 11;
    unsigned int funct = instruction & 0x3f;
    cout << R_table[funct - 32] << '\t' << regs[rd] << ", " << regs[rs] << ", "
         << regs[rt] << endl;
  }
}
