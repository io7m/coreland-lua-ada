-- Lua userdata handling

package body lua.udata is

  use type system.address;

  package cbinds is
    function new_user_data
     (state : lua.state_t;
      size  : lua.ic.size_t) return system.address;
    pragma import (c, new_user_data, "lua_newuserdata");

    function to_user_data
     (state : lua.state_t;
      index : lua.int_t) return system.address;
    pragma import (c, to_user_data, "lua_touserdata");
  end cbinds;

  procedure register (state : lua.state_t) is
    dummy : boolean;
  begin
    lua.lib.open_library (state, class_name, method_table, 0);
    dummy := lua.lib.new_metatable (state, class_name);
    if not dummy then return; end if;
    lua.lib.open_library (state, "", meta_table, 0);
    lua.push_string (state, "__index");
    lua.push_value (state, -3);
    lua.raw_set (state, -3);
    lua.push_string (state, "__metatable");
    lua.push_value (state, -3);
    lua.raw_set (state, -3);
    lua.pop (state, 1);
  end register;

  procedure push
   (state : lua.state_t;
    item  : udata_t)
  is
    x     : udata_access_t;
    error : lua.error_t;
  begin
    x := udata_access_t (convert.to_pointer
      (cbinds.new_user_data (state, lua.ic.size_t (udata_t'size / 8))));

    x.all := item;
    lua.push_string (state, class_name);
    lua.raw_get (state, lua.registry_index);
    error := lua.set_metatable (state, -2);
    if error /= lua.lua_error_none then return; end if;
  end push;

  function get
   (state : lua.state_t;
    index : integer := 1) return udata_t
  is
    sa : constant system.address := cbinds.to_user_data (state, lua.int_t (index));
  begin
    return convert.to_pointer (sa).all;
  end get;

end lua.udata;
