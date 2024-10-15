/*
 * dis.cpp -- A subset of a MIPS disassembler
 */

#include <bitset>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

static bool DEBUG = false;

ostringstream debug_log;
ostringstream results_log;

enum instr_type { Register, ImmediateSigned, ImmediateUnsigned, Jump, OpUnary };

static const string instr_str[] = {"Register", "ImmediateSigned",
                                   "ImmediateUnsigned", "Jump", "OpUnary"};

static const string op_table[] = {
    "",     "",      "j",    "jal",   "beq",  "bne", "blez", "bgtz",
    "addi", "addiu", "slti", "sltiu", "andi", "ori", "xori", "lui"};

static const string func_table[] = {
    "sll",  "",      "srl",  "sra",  "sllv",    "",      "srlv", "srav",
    "jr",   "jalr",  "movz", "movn", "syscall", "break", "",     "sync",
    "mfhi", "mfhi",  "mflo", "mflo", "",        "",      "",     "",
    "mult", "multu", "div",  "divu", "",        "",      "",     "",
    "add",  "addu",  "sub",  "subu", "and",     "or",    "xor",  "nor",
    "",     "",      "slt",  "sltu", "",        ""};

static const string reg_table[] = {
    "zero", "at", "v0", "v1", "a0", "a1", "a2", "a3", "t0", "t1", "t2",
    "t3",   "t4", "t5", "t6", "t7", "s0", "s1", "s2", "s3", "s4", "s5",
    "s6",   "s7", "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra"};

string str_instr(vector<string> strs) {
  ostringstream res;
  res << setw(10) << left;
  for (string str : strs)
    res << str << setw(5) << left;
  return res.str();
}

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
  short immNum = instruction & 0xffff;
  unsigned short immNumUnsigned = instruction & 0xffff;
  unsigned short immuNum = instruction & 0xffff;

  string op = op_table[opNum];
  int opLastIndex = op_table[opNum].length() - 1;
  string rs = "$" + reg_table[rsNum];
  string rt = "$" + reg_table[rtNum];
  string rd = "$" + reg_table[rdNum];
  int other = otherNum;
  string func = func_table[funcNum];
  int imm = immNum;
  unsigned int immUnsigned = immuNum;

  instr_type it;

  if (op[opLastIndex] == 'i')
    it = ImmediateSigned;
  else if (op[opLastIndex - 1] == 'i' && op[opLastIndex] == 'u')
    it = ImmediateUnsigned;
  else if (func == "syscall" || op == "jal")
    it = OpUnary;
  else if (op[0] == 'j')
    it = Jump;
  else
    it = Register;

  bitset<32> instr_bin(instruction);
  bitset<11> imm_bin(instruction & 0x7ff);

  if (DEBUG) {
    debug_log << "========================================" << endl;
    debug_log << "instr:  " << instr_bin << endl;
    debug_log << "type:   " << instr_str[it] << endl;
    if (op != "") {
      debug_log << "op:     " << op << endl;
    } else {
      debug_log << "func:   " << func << endl;
    }
    if (it != OpUnary && it != Jump) {
      debug_log << "rd:     " << rd << endl;
      debug_log << "rs:     " << rs << endl;
    }
    if (it == Register) {
      debug_log << "rt:     " << rt << endl;
      debug_log << "other:  " << other << endl;
    }
    if (it == ImmediateSigned)
      debug_log << "imm:    " << imm << endl;
    if (it == ImmediateUnsigned)
      debug_log << "imm:    " << (unsigned short)imm << endl;
    if (it == Jump)
      debug_log << "pseudo: " << pseudo_address << endl;
  }

  results_log << setw(20) << instr_bin << " = ";
  string spc = " ";
  switch (it) {
  case ImmediateUnsigned:
    results_log << str_instr({op, rt, rs, to_string((unsigned short)imm)})
                << endl;
    break;
  case ImmediateSigned:
    results_log << str_instr({op, rt, rs, to_string(imm)}) << endl;
    break;
  case OpUnary:
    if (op == "")
      results_log << str_instr({func}) << endl;
    else
      results_log << str_instr({op}) << endl;
    break;
  case Jump:
    results_log << str_instr({op, to_string(pseudo_address)}) << endl;
    break;
  case Register:
    if (op == "")
      results_log << str_instr({func, rd, rs, rt}) << endl;
    else
      results_log << str_instr({op, rs, rt, rd}) << endl;
    break;
  default:
    throw invalid_argument("invalid instruction");
  }
}

int main(int argc, char **argv) {
  dis(0x2149ff9c);                         // addi  $t1, $t2, -100
  dis(0x014b4820);                         // add   $t1, $t2, $t3
  dis(0x014b4821);                         // addu  $t1, $t2, $t3
  dis(0b00110010001100010000000000000001); // andi 1
  dis(0b00000010011101110001000000100100); // and
  dis(0b00000010001100010000100000001000); // jr
  dis(0b00111110011101110001000000000111); // lui
  dis(0b00000010011101110001000000100111); // nor
  dis(0b00000010011101110001000000100101); // or
  dis(0b00101010011100111111111111111111); // slti
  dis(0b00101110011100111111111111111111); // sltiu
  dis(0x014b4822);                         // sub   $t1, $t2, $t3
  dis(0x014b4823);                         // subu  $t1, $t2, $t3
  dis(0b00000000000000000000000000001100); // syscall
  dis(0b00000010011101110001000000100110); // xor

  if (DEBUG) {
    cout << "========================================" << endl;
    cout << "|                DEBUG                 |" << endl;
    // cout << "========================================" << endl;
    cout << debug_log.str();
  }

  cout << "========================================" << endl;
  cout << "|               RESULTS                |" << endl;
  cout << "========================================" << endl;
  cout << results_log.str();
  return 0;
}
