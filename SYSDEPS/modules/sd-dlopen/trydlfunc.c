#include <dlfcn.h>

int main()
{
  void *h = 0;
  dlfunc_t f;

  f = dlfunc(h, "symbol");
  return 0;
}
