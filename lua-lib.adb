-- Lua standard libraries

package body lua.lib is

  function new_metatable (ls: lua.state; name: string) return boolean is
  begin
    lua.push_string(ls, name);
    lua.raw_get(ls, lua.registry_index);
    if lua.is_nil(ls, -1) = false then return false; end if;
    lua.pop(ls, 1);
    lua.new_table(ls);
    -- 1 metatable
    lua.push_string(ls, name);
    -- 1 metatable
    -- 2 name
    lua.push_value(ls, -2);
    -- 1 metatable
    -- 2 name
    -- 3 metatable
    lua.raw_set(ls, lua.registry_index);
    -- 1 metatable
    lua.push_value(ls, -1);
    -- 1 metatable
    -- 2 metatable
    lua.push_string(ls, name);
    -- 1 metatable
    -- 2 metatable
    -- 3 name
    lua.raw_set(ls, lua.registry_index);
    -- 1 metatable
    return true;
  end new_metatable;

  procedure open_library (ls: lua.state; name: string; funcs: reg_array; num_up: integer) is
  begin
    if name /= "" then
      lua.push_string (ls, name);
      lua.get_table (ls, lua.globals_index);
      if lua.is_nil (ls, -1) then
        lua.pop (ls, 1);
        lua.new_table (ls);
        lua.push_string (ls, name);
        lua.push_value (ls, -2);
        lua.set_table (ls, lua.globals_index);
      end if;
      lua.insert(ls, - (num_up + 1));
    end if;

    for i in funcs'first .. funcs'last loop
      lua.push_string (ls, funcs (i).name);
      for j in 1 .. num_up loop
        lua.push_value(ls, - (num_up + 1));
      end loop;
      lua.push_user_closure (ls, funcs (i).func, num_up);
      lua.set_table (ls, - (num_up + 3));
    end loop;

    lua.pop (ls, num_up);
  end open_library;

  procedure lua_openbase (ls: lua.state);
  pragma import (c, lua_openbase, "luaopen_base");

  procedure open_base (ls: lua.state) is
  begin
    lua_openbase(ls);
  end open_base;

  procedure lua_opentable (ls: lua.state);
  pragma import (c, lua_opentable, "luaopen_table");

  procedure open_table (ls: lua.state) is
  begin
    lua_opentable(ls);
  end open_table;

  procedure lua_openstring (ls: lua.state);
  pragma import (c, lua_openstring, "luaopen_string");

  procedure open_string (ls: lua.state) is
  begin
    lua_openstring(ls);
  end open_string;

  procedure lua_openio (ls: lua.state);
  pragma import (c, lua_openio, "luaopen_io");

  procedure open_io (ls: lua.state) is
  begin
    lua_openio(ls);
  end open_io;

  procedure lua_openmath (ls: lua.state);
  pragma import (c, lua_openmath, "luaopen_math");

  procedure open_math (ls: lua.state) is
  begin
    lua_openmath(ls);
  end open_math;

  procedure lua_opendebug (ls: lua.state);
  pragma import (c, lua_opendebug, "luaopen_debug");

  procedure open_debug (ls: lua.state) is
  begin
    lua_opendebug(ls);
  end open_debug;

  procedure lual_openlibs (ls: lua.state);
  pragma import (c, lual_openlibs, "luaL_openlibs");

  procedure open_libs (ls: lua.state) is
  begin
    lual_openlibs (ls);
  end open_libs;

end lua.lib;
