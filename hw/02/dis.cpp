/*
 * dis.cpp -- A subset of a MIPS disassembler
 */

#include <iostream>
#include <string>

using namespace std;

void dis(unsigned int instruction);

int main(int argc, char **argv) {
  dis(0x2149ff9c); // addi $t1, $t2, -100
  dis(0x014b4820); // add  $t1, $t2, $t3
  // Probably add more test cases here.
  return 0;
}

/*
 * dis(instruction) -- Prints MIPS assembly language for
 * 'instruction', i.e. diassemble the instruction.
 */

static string op_table[] = {"j"
                            "jal"
                            "beq"
                            "bne"
                            "blez"
                            "bgtz"
                            "addi"
                            "addiu"
                            "slti"
                            "sltiu"
                            "andi"
                            "ori"
                            "xori"
                            "lui"};
static string func_table[] = {"sll"
                              ""
                              "srl"
                              "sra"
                              "sllv"
                              ""
                              "srlv"
                              "srav"
                              "jr"
                              "jalr"
                              "movz"
                              "movn"
                              "syscall"
                              "break"
                              ""
                              "sync"
                              "mfhi"
                              "mfhi"
                              "mflo"
                              "mflo"
                              ""
                              ""
                              ""
                              ""
                              "mult"
                              "multu"
                              "div"
                              "divu"
                              ""
                              ""
                              ""
                              ""
                              "add"
                              "addu"
                              "sub"
                              "subu"
                              "and"
                              "or"
                              "xor"
                              "nor"
                              ""
                              ""
                              "slt"
                              "sltu"
                              ""
                              ""};
static string reg_table[] = {"at"
                             "v0"
                             "v1"
                             "a0"
                             "a1"
                             "a2"
                             "a3"
                             "t0"
                             "t1"
                             "t2"
                             "t3"
                             "t4"
                             "t5"
                             "t6"
                             "t7"
                             "s0"
                             "s1"
                             "s2"
                             "s3"
                             "s4"
                             "s5"
                             "s6"
                             "s7"
                             "t8"
                             "t9"
                             "k0"
                             "k1"
                             "gp"
                             "sp"
                             "fp"
                             "ra"};

string lookup(string *table, unsigned int index) {
  size_t table_size = sizeof(table);
  // cout << "table size " << table_size << endl;
  string s;
  char buf[20];
  string t = table[index];
  t.copy(buf, 3, 3);
  return buf;
}

void dis(unsigned int instruction) {
  int op = (instruction >> 26) & 0x3f;
  int func = instruction & 0x3f;
  cout << "op:     " << op << lookup(op_table, op) << endl;
  cout << "func:   " << func << endl;
  return;
}
