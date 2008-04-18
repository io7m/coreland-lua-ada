#include <lua.h>
#include <lauxlib.h>

const char *
luext_version (void)
{
  return LUA_VERSION;
}

const char *
luext_release (void)
{
  return LUA_RELEASE;
}

LUA_INTEGER
luext_version_num (void)
{
  return LUA_VERSION_NUM;
}

const char *
luext_tostring (lua_State *ls, int index, size_t *len)
{
  size_t x;
  return lua_tolstring (ls, index, &x);
}
