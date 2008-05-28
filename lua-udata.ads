-- Lua userdata handling

with system.address_to_access_conversions;
with lua;
with lua.lib;

generic
  class_name: string;
  type udata_t is private;
  method_table: lua.lib.reg_array;
  meta_table: lua.lib.reg_array;

package lua.udata is
  type udata_ptr_t is access all udata_t;

  package convert is new system.address_to_access_conversions (udata_t);

  procedure register (ls: lua.state_ptr_t);
  procedure push (ls: lua.state_ptr_t; item: udata_t);
  function  get (ls: lua.state_ptr_t; index: integer := 1) return udata_t;
end lua.udata;
