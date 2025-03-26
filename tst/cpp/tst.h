#ifndef _tst_h
#define _tst_h

#include <iostream>

class Example
{
public:
  Example(int);
  ~Example();

public:
  void        Method();                       // Trailing comments
  void        Method(int);                    // can be aligned
  void        Method(void *);                 // in groups with SpacesBeforeTrailingComments
  void        Method(int, void *, double);    // .
  inline void Method(bool);                   // .

private:        // Another
  int    _a;    // Example
  void  *_p;    // Of comments
  float  _f;
  double _d;
};

class AnotherExample : public Example
{
public:
  AnotherExample();
  ~AnotherExample();

public:
  void Method(int, void *, double);

private:
  int   _i;
  void *_q;
  bool  _b;
};

inline void Example::Method(bool b)
{
  std::cout << (b ? "TRUE" : "FALSE") << std::endl;
}

#endif
