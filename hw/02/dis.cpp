/*
 * dis.cpp -- A subset of a MIPS disassembler
 */

#include <bitset>
#include <iostream>
#include <string>

using namespace std;

static bool DEBUG = false;

enum InstructionType { Register = 0, Immediate = 1, Jump = 2, Op = 3 };

string to_string(InstructionType it) {
  switch (it) {
  case Register:
    return "Register";
    break;
  case Op:
    return "Op";
    break;
  case Immediate:
    return "Immediate";
    break;
  case Jump:
    return "Jump";
    break;
  }
  throw invalid_argument("Invalid InstructionType");
}

void dis(unsigned int instruction);

/*
 * dis(instruction) -- Prints MIPS assembly language for
 * 'instruction', i.e. diassemble the instruction.
 */

static string op_table[] = {"",     "",     "j",    "jal",   "beq",  "bne",
                            "blez", "bgtz", "addi", "addiu", "slti", "sltiu",
                            "andi", "ori",  "xori", "lui"};
static string func_table[] = {
    "sll",  "",      "srl",  "sra",  "sllv",    "",      "srlv", "srav",
    "jr",   "jalr",  "movz", "movn", "syscall", "break", "",     "sync",
    "mfhi", "mfhi",  "mflo", "mflo", "",        "",      "",     "",
    "mult", "multu", "div",  "divu", "",        "",      "",     "",
    "add",  "addu",  "sub",  "subu", "and",     "or",    "xor",  "nor",
    "",     "",      "slt",  "sltu", "",        ""};
static string reg_table[] = {"zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
                             "t0",   "t1", "t2", "t3", "t4", "t5", "t6", "t7",
                             "s0",   "s1", "s2", "s3", "s4", "s5", "s6", "s7",
                             "t8",   "t9", "k0", "k1", "gp", "sp", "fp", "ra"};

void dis(unsigned int instruction) {
  // R: [  op   | rs  | rt  | rd  |other| func ]
  // I: [  op   | rs  | rt  |       imm        ]
  // J: [  op   |       pseudo-address         ]
  int opNum = (instruction >> 26) & 0x3f;
  int rsNum = (instruction >> 21) & 0x1f;
  int rtNum = (instruction >> 16) & 0x1f;
  int rdNum = (instruction >> 11) & 0x1f;
  int otherNum = (instruction >> 6) & 0x1f;
  int funcNum = instruction & 0x3f;
  int pseudo_address = instruction & 0x1fffff;
  short immNum = (instruction) & 0xffff;
  unsigned short immuNum = (instruction) & 0xffff;

  string op = op_table[opNum];
  int opLastIndex = op_table[opNum].length() - 1;
  string rs = reg_table[rsNum];
  string rt = reg_table[rtNum];
  string rd = reg_table[rdNum];
  int other = otherNum;
  string func = func_table[funcNum];
  int imm = immNum;

  InstructionType it;

  if (op[opLastIndex] == 'i')
    it = Immediate;
  else if (func == "syscall" || op == "jal")
    it = Op;
  else if (op[0] == 'j')
    it = Jump;
  else
    it = Register;

  bitset<32> instr_bin(instruction);
  if (DEBUG) {
    cout << "DEBUG" << endl;
    cout << "=====" << endl;
    cout << "instr:  " << instr_bin << endl;
    cout << "type:   " << to_string(it) << endl;
    cout << "op:     " << op << endl;
    cout << "rd:     " << rd << endl;
    cout << "rs:     " << rs << endl;
    cout << "rt:     " << rt << endl;
    cout << "imm:    " << imm << endl;
    cout << "other:  " << other << endl;
    cout << "func:   " << func << " " << funcNum << endl;
    cout << "ps_add: " << pseudo_address << endl;
  }

  cout << "RESULT: \t";
  string spc = " ";
  switch (it) {
  case Immediate:
    cout << op << spc << rt << spc << rs << spc << imm << endl;
    break;
  case Op:
    if (op == "")
      cout << func << endl;
    else
      cout << op << endl;
    break;
  case Jump:
    cout << op << spc << pseudo_address << endl;
    break;
  case Register:
    if (op == "")
      cout << func << spc << rd << spc << rs << spc << rt << endl;
    else
      cout << op << spc << rs << spc << rt << spc << rd << endl;
    break;
  default:
    throw invalid_argument("invalid instruction");
  }
  cout << endl;
}

int main(int argc, char **argv) {
  dis(0x2149ff9c);                         // addi $t1, $t2, -100
  dis(0x014b4820);                         // add  $t1, $t2, $t3
  dis(0x014b4822);                         // sub  $t1, $t2, $t3
  dis(0b00000000000000000000000000001100); // syscall
  dis(0b00000010001100010000100000001000); // jr
  dis(0b00110010001100010000000000000001); // andi 1
  dis(0b00101010011100110000000000000001); // slti
  dis(0b00000010011101110001000000100100); // and
  dis(0b00000010011101110001000000100101); // or
  dis(0b00000010011101110001000000100110); // xor
  dis(0b00000010011101110001000000100111); // nor
  // + sltiu
  // + lui
  // + addu
  // + subu
  return 0;
}
