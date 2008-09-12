-- Lua userdata handling

with system.address_to_access_conversions;
with lua;
with lua.lib;

generic
  type udata_t is private;
  class_name   : string;
  method_table : lua.lib.reg_array;
  meta_table   : lua.lib.reg_array;

package lua.udata is
  package convert is new system.address_to_access_conversions (udata_t);

  type udata_access_t is access all udata_t;

  procedure register (state : lua.state_t);

  procedure push
   (state : lua.state_t;
    item  : udata_t);

  function get
   (state : lua.state_t;
    index : integer := 1) return udata_t;

end lua.udata;
