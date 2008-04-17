-- Lua userdata handling

with system.address_to_access_conversions;
with lua;
with lua.lib;

generic
  class_name: string;
  type t is private;
  method_table: lua.lib.reg_array;
  meta_table: lua.lib.reg_array;

package lua.udata is

  type p is access all t;

  package convert is new system.address_to_access_conversions(t);

  procedure register (ls: lua.state);
  procedure push (ls: lua.state; item: t);
  function  get (ls: lua.state; index: integer := 1) return t;

end lua.udata;
