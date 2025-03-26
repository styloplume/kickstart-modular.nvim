// In case of warnings/errors with fixes available : <leader>ca for code actions

// Includes can be preserved, sorted, by blocks, or merged.
#include "tst.h"
#include <array>
#include <cstddef>
#include <iostream>

// Constructor initializers can be auto-aligned
Example::Example(int var)
: _a(0),
  _p(NULL),
  _f(0.),
  _d(0.)
{
}

AnotherExample::AnotherExample()
: Example(0),
  _b(false),
  _i(0),
  _q(NULL)
{
}

// Functions on a single line can be allowed but also affect inlines so let's
// avoid that.
Example::~Example()
{
}

// Clangd should alert upon unused or uninitialized variables, but isn't. Why ?
void Example::Method()
{
  int unused_var = 0, uninitialized_var;
  std::cout << __FUNCTION__ << std::endl;
}

void Example::Method(int input)
{
  std::cout << input << std::endl;
}

// BinPackParameters breaks everything so can't get these aligned :/
void Example::Method(int iInteger, void *iPointer, double iDouble)
{
}

// By the way, use ColumnLimit to define a max width.

// Assignments can be aligned
int    z = 0;
float  x = -2.;
double c = 300;
void  *v = NULL;
// Through empty lines/comments, or not.
bool ultimate_test = false;
char b[15];

template <int i> void a()
{
  a<i + 1>();
}

void foo()
{
  a<0>();
}

int main()
{
  std::cout << "Ok\n";
  std::cout << "Hello clangd\n";
  std::array<int, 3> my_array;

  char a[10];
  a[10] = 0;

  // Single line ifs are allowed
  if (1)
    std::cout << "Hurra!\n";

  if (0)    // however
  {
    std::cout << "then\n";
    int var = 10;
  }

  void *ptr = NULL;

  for (int idx = 0; idx <= 10; idx++)
  {
    std::cout << idx << std::endl;
  }

  return 0;
}
