/*
 * wc.cpp -- Simple version of the Unix 'wc' (word-count) utility
 */

#include <iostream>
#include <fstream>
#include <sstream>
using namespace std;

typedef struct {
  int num_lines;
  int num_words;
  int num_bytes;
} WcResult;

bool is_space(char c)
{
  return (
    c == '\t' || c == '\n' || c == '\r' || c == '\v' || c == '\f' || c == ' '
  );
}


void wc_impl(const char *text, WcResult *result)
{
  int c;
  bool inside_word = false;

  result->num_lines = 0;
  result->num_words = 0;
  result->num_bytes = 0;

  while ((c = *text++) != '\0') {
    result->num_bytes++;

    if (c == '\n')
      result->num_lines++;

    if (inside_word) {
      if (is_space(c))
        inside_word = false;
    } else { /* else we're between words */
      if (!is_space(c)) {
        /* between words, a non-space means "start a new word" */
        result->num_words++;
        inside_word = true;
      }
    }
  }
}

int main(int argc, char** argv)
{
  if (argc != 2) {
    cerr << "usage: wc filename" << endl;
    return 1;
  }

  ifstream textfile(argv[1]);
  std::stringstream buffer;
  buffer << textfile.rdbuf();
  
  WcResult result;
  wc_impl(buffer.str().c_str(), &result);
  cout << "lines: " << result.num_lines << endl;
  cout << "words: " << result.num_words << endl;
  cout << "chars: " << result.num_bytes << endl;
  return 0;
}
