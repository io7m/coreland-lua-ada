-- Lua standard libraries

with lua;

package lua.lib is

  type reg is record
    name: su.unbounded_string;
    func: lua.user_func_t;
  end record;

  type reg_array is array (positive range <>) of reg;

  function  new_metatable (ls: lua.state_ptr_t; name: string) return boolean;
  procedure open_library  (ls: lua.state_ptr_t; name: string; funcs: reg_array; num_up: integer);

  procedure open_base   (ls: lua.state_ptr_t);
  procedure open_table  (ls: lua.state_ptr_t);
  procedure open_string (ls: lua.state_ptr_t);
  procedure open_io     (ls: lua.state_ptr_t);
  procedure open_math   (ls: lua.state_ptr_t);
  procedure open_debug  (ls: lua.state_ptr_t);

  procedure open_libs (ls: lua.state_ptr_t);
end lua.lib;
