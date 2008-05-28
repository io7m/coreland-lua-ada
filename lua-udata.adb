-- Lua userdata handling

package body lua.udata is
  
  function lua_newuserdata (ls: lua.state_ptr_t; size: lua.ic.size_t)
    return system.address;
  pragma import (c, lua_newuserdata, "lua_newuserdata");

  function lua_touserdata  (ls: lua.state_ptr_t; index: lua.int_t)
    return system.address;
  pragma import (c, lua_touserdata, "lua_touserdata");

  procedure register (ls: lua.state_ptr_t) is
    dummy: boolean;
  begin
    lua.lib.open_library (ls, class_name, method_table, 0);
    dummy := lua.lib.new_metatable (ls, class_name);
    if not dummy then return; end if;
    lua.lib.open_library (ls, "", meta_table, 0);
    lua.push_string (ls, "__index");
    lua.push_value (ls, -3);
    lua.raw_set (ls, -3);
    lua.push_string (ls, "__metatable");
    lua.push_value (ls, -3);
    lua.raw_set (ls, -3);
    lua.pop (ls, 1);
  end register;
  
  procedure push (ls: lua.state_ptr_t; item: udata_t) is
    x: udata_ptr_t;
    error: lua.error_t;
  begin
    x := udata_ptr_t (convert.to_pointer
      (lua_newuserdata (ls, lua.ic.size_t (udata_t'size / 8))));

    x.all := item;
    lua.push_string (ls, class_name);
    lua.raw_get (ls, lua.registry_index);
    error := lua.set_metatable (ls, -2);
    if error /= lua.lua_error_none then return; end if;
  end push;

  function get (ls: lua.state_ptr_t; index: integer := 1) return udata_t is
    use system;
    sa: constant system.address := lua_touserdata (ls, lua.int_t (index));
  begin
    return convert.to_pointer (sa).all;
  end get;
  pragma inline (get);
  
end lua.udata;
