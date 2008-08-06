-- Lua standard libraries

package body lua.lib is

  function new_metatable (state : lua.state_ptr_t; name : string) return boolean is
  begin
    lua.push_string (state, name);
    lua.raw_get (state, lua.registry_index);
    if lua.is_nil (state, -1) = false then return false; end if;
    lua.pop (state, 1);
    lua.new_table (state);
    -- 1 metatable
    lua.push_string (state, name);
    -- 1 metatable
    -- 2 name
    lua.push_value (state, -2);
    -- 1 metatable
    -- 2 name
    -- 3 metatable
    lua.raw_set (state, lua.registry_index);
    -- 1 metatable
    lua.push_value (state, -1);
    -- 1 metatable
    -- 2 metatable
    lua.push_string (state, name);
    -- 1 metatable
    -- 2 metatable
    -- 3 name
    lua.raw_set (state, lua.registry_index);
    -- 1 metatable
    return true;
  end new_metatable;

  procedure open_library (state : lua.state_ptr_t; name : string; funcs : reg_array;
    num_up : integer) is
  begin
    if name /= "" then
      lua.push_string (state, name);
      lua.get_table (state, lua.globals_index);
      if lua.is_nil (state, -1) then
        lua.pop (state, 1);
        lua.new_table (state);
        lua.push_string (state, name);
        lua.push_value (state, -2);
        lua.set_table (state, lua.globals_index);
      end if;
      lua.insert (state, - (num_up + 1));
    end if;

    for i in funcs'first .. funcs'last loop
      lua.push_string (state, funcs (i).name);
      for j in 1 .. num_up loop
        lua.push_value (state, - (num_up + 1));
      end loop;
      lua.push_user_closure (state, funcs (i).func, num_up);
      lua.set_table (state, - (num_up + 3));
    end loop;

    lua.pop (state, num_up);
  end open_library;

  procedure lua_openbase (state : lua.state_ptr_t);
  pragma import (c, lua_openbase, "luaopen_base");

  procedure open_base (state : lua.state_ptr_t) is
  begin
    lua_openbase (state);
  end open_base;

  procedure lua_opentable (state : lua.state_ptr_t);
  pragma import (c, lua_opentable, "luaopen_table");

  procedure open_table (state : lua.state_ptr_t) is
  begin
    lua_opentable (state);
  end open_table;

  procedure lua_openstring (state : lua.state_ptr_t);
  pragma import (c, lua_openstring, "luaopen_string");

  procedure open_string (state : lua.state_ptr_t) is
  begin
    lua_openstring (state);
  end open_string;

  procedure lua_openio (state : lua.state_ptr_t);
  pragma import (c, lua_openio, "luaopen_io");

  procedure open_io (state : lua.state_ptr_t) is
  begin
    lua_openio (state);
  end open_io;

  procedure lua_openmath (state : lua.state_ptr_t);
  pragma import (c, lua_openmath, "luaopen_math");

  procedure open_math (state : lua.state_ptr_t) is
  begin
    lua_openmath (state);
  end open_math;

  procedure lua_opendebug (state : lua.state_ptr_t);
  pragma import (c, lua_opendebug, "luaopen_debug");

  procedure open_debug (state : lua.state_ptr_t) is
  begin
    lua_opendebug (state);
  end open_debug;

  procedure lual_openlibs (state : lua.state_ptr_t);
  pragma import (c, lual_openlibs, "luaL_openlibs");

  procedure open_libs (state : lua.state_ptr_t) is
  begin
    lual_openlibs (state);
  end open_libs;

end lua.lib;
