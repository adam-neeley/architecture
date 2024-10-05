/*
 * dis.cpp -- A subset of a MIPS disassembler
 */

#include <bitset>
#include <iomanip>
#include <iostream>
#include <regex>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

static string ops[] = {"",     "",     "j",    "jal",   "beq",  "bne",
                       "blez", "bgtz", "addi", "addiu", "slti", "sltiu",
                       "andi", "ori",  "xori", "lui"};

static string funcs[] = {
    "sll",  "",      "srl",  "sra",  "sllv",    "",      "srlv", "srav",
    "jr",   "jalr",  "movz", "movn", "syscall", "break", "",     "sync",
    "mfhi", "mfhi",  "mflo", "mflo", "",        "",      "",     "",
    "mult", "multu", "div",  "divu", "",        "",      "",     "",
    "add",  "addu",  "sub",  "subu", "and",     "or",    "xor",  "nor",
    "",     "",      "slt",  "sltu", "",        ""};

static string regs[] = {"zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
                        "t0",   "t1", "t2", "t3", "t4", "t5", "t6", "t7",
                        "s0",   "s1", "s2", "s3", "s4", "s5", "s6", "s7",
                        "t8",   "t9", "k0", "k1", "gp", "sp", "fp", "ra"};

using uint = unsigned int;
using sint = signed int;

static vector<string> tokenize(string expr) {
  vector<string> tokens;
  stringstream ss(expr);
  string token;
  while (getline(ss, token, ' '))
    tokens.push_back(token);
  return tokens;
}

class Instruction {
private:
  string type;
  string expr;
  uint code;
  vector<string> tokens;
  string op, rs, rt, rd, func, imms, immu, pseudo, first;
  bool debug = true;

  uint sum_pows_2(uint n) {
    if (n == 0)
      return 1;
    return (2 << (n - 1)) + sum_pows_2(n - 1);
  }

  uint get_part(uint shift, uint bits) {
    return (code >> shift) & sum_pows_2(bits);
  }

  void print_debug() {
    //
    uint w = 10;
    cout << setw(w) << "first: " << first << endl;
    cout << setw(w) << "type: " << type << endl;
    cout << setw(w) << "code: " << code << endl;
    cout << setw(w) << "op: " << op << endl;
    cout << setw(w) << "rs: " << rs << endl;
    cout << setw(w) << "rt: " << rt << endl;
    cout << setw(w) << "rd: " << rd << endl;
    cout << setw(w) << "func: " << func << endl;
    cout << setw(w) << "imms: " << imms << endl;
    cout << setw(w) << "immu: " << immu << endl;
    cout << setw(w) << "pseudo: " << pseudo << endl;
  }

public:
  Instruction(uint code, bool debug = false) : code{code}, debug{debug} {
    op = ops[get_part(26, 6)];
    rs = regs[get_part(21, 5)];
    rt = regs[get_part(16, 5)];
    rd = regs[get_part(11, 5)];
    func = funcs[get_part(0, 6)];
    // imms = to_string(get_part_signed(0, 16));
    immu = to_string(get_part(0, 16));
    pseudo = to_string(get_part(0, 26));
    first = op != "" ? op : func;

    if (false)
      cout << "tye: ";
    else if (regex_search(first, regex("ui$")))
      type = "ImmediateUnsigned";
    else if (regex_search(first, regex("u$")))
      type = "RegisterUnsigned";
    else if (regex_search(first, regex("i$")))
      type = "Immediate";
    else
      type = "Register";

    if (debug)
      print_debug();
    print();
  };

  Instruction(string expr) {
    tokens = tokenize(expr);
    for (string token : tokens)
      cout << token << " ";
    cout << endl;
  }

  void print() { cout << first << endl; }

  unsigned int eval(string expr) {
    // switch ()
    //
    return 0;
  }
};

void ass(string instr_str) {
  cout << "ass(" << instr_str << ")" << endl;
  Instruction *instr = new Instruction(instr_str);
  delete instr;
}

void dis(uint instr_code, bool debug = false) {
  cout << "dis(" << instr_code << ")" << endl;
  Instruction *instr = new Instruction(instr_code, debug);
  delete instr;
}

int main(int argc, char **argv) {
  dis(0x2149ff9c, true); // addi  $t1, $t2, -100
  dis(0x014b4820, true); // add   $t1, $t2, $t3
  dis(0x014b4821, true); // addu  $t1, $t2, $t3
  // dis(0b00110010001100010000000000000001); // andi 1
  // dis(0b00000010011101110001000000100100); // and
  // dis(0b00000010001100010000100000001000); // jr
  // dis(0b00111110011101110001000000000111); // lui
  // dis(0b00000010011101110001000000100111); // nor
  // dis(0b00000010011101110001000000100101); // or
  // dis(0b00101010011100111111111111111111); // slti
  // dis(0b00101110011100111111111111111111); // sltiu
  // dis(0x014b4822);                         // sub   $t1, $t2, $t3
  // dis(0x014b4823);                         // subu  $t1, $t2, $t3
  // dis(0b00000000000000000000000000001100); // syscall
  // dis(0b00000010011101110001000000100110); // xor
  return 0;
}
