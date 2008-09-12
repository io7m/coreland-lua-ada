-- Lua standard libraries

with lua;

package lua.lib is

  type register_t is record
    name : su.unbounded_string;
    func : lua.user_func_t;
  end record;
  type register_access_t is access all register_t;
  type register_array_t is array (positive range <>) of register_t;

  function new_metatable
   (state : lua.state_t;
    name  : string) return boolean;

  procedure open_library
   (state  : lua.state_t;
    name   : string;
    funcs  : register_array_t; 
    num_up : integer);

  procedure open_base (state : lua.state_t);
  pragma import (c, open_base, "luaopen_base");

  procedure open_table (state : lua.state_t);
  pragma import (c, open_table, "luaopen_table");

  procedure open_string (state : lua.state_t);
  pragma import (c, open_string, "luaopen_string");

  procedure open_io (state : lua.state_t);
  pragma import (c, open_io, "luaopen_io");

  procedure open_math (state : lua.state_t);
  pragma import (c, open_math, "luaopen_math");

  procedure open_debug (state : lua.state_t);
  pragma import (c, open_debug, "luaopen_debug");

  procedure open_libs (state : lua.state_t);
  pragma import (c, open_libs, "luaL_openlibs");

end lua.lib;
