-- Lua standard libraries

with lua;

package lua.lib is

  type reg is record
    name: su.unbounded_string;
    func: lua.user_function;
  end record;

  type reg_array is array (positive range <>) of reg;

  function  new_metatable (ls: lua.state; name: string) return boolean;
  procedure open_library  (ls: lua.state; name: string; funcs: reg_array; num_up: integer);

  procedure open_base   (ls: lua.state);
  procedure open_table  (ls: lua.state);
  procedure open_string (ls: lua.state);
  procedure open_io     (ls: lua.state);
  procedure open_math   (ls: lua.state);
  procedure open_debug  (ls: lua.state);

  procedure open_libs (ls: lua.state);

end lua.lib;
