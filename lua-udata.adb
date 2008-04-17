-- Lua userdata handling

package body lua.udata is
  
  function lua_newuserdata (ls: lua.state; size: lua.ic.size_t) return system.address;
  pragma import (c, lua_newuserdata, "lua_newuserdata");

  function lua_touserdata  (ls: lua.state; index: lua.lua_int) return system.address;
  pragma import (c, lua_touserdata, "lua_touserdata");

  procedure register (ls: lua.state) is
    dummy: boolean;
  begin
    lua.lib.open_library (ls, class_name, method_table, 0);
    dummy := lua.lib.new_metatable (ls, class_name);
    lua.lib.open_library (ls, "", meta_table, 0);
    lua.push_string (ls, "__index");
    lua.push_value (ls, -3);
    lua.raw_set (ls, -3);
    lua.push_string (ls, "__metatable");
    lua.push_value (ls, -3);
    lua.raw_set (ls, -3);
    lua.pop (ls, 1);
  end register;
  
  procedure push (ls: lua.state; item: t) is
    x: p; error: lua.error_type;
  begin
    x := p (convert.to_pointer (lua_newuserdata (ls, lua.ic.size_t (t'size / 8))));
    x.all := item;
    lua.push_string (ls, class_name);
    lua.raw_get (ls, lua.registry_index);
    error := lua.set_metatable (ls, -2);
  end push;

  function get (ls: lua.state; index: integer := 1) return t is
    use system;
    sa: constant system.address := lua_touserdata (ls, lua.lua_int (index));
  begin
    return convert.to_pointer (sa).all;
  end get;
  pragma inline (get);
  
end lua.udata;
