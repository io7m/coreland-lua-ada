#include <dlfcn.h>

int main()
{
  void *h;

  h = dlopen("dummy.so", RTLD_LAZY);
  return 0;
}
