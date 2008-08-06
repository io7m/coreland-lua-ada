-- Lua standard libraries

with lua;

package lua.lib is

  type reg is record
    name : su.unbounded_string;
    func : lua.user_func_t;
  end record;

  type reg_array is array (positive range <>) of reg;

  function new_metatable
   (state : lua.state_ptr_t;
    name  : string) return boolean;

  procedure open_library
   (state  : lua.state_ptr_t;
    name   : string;
    funcs  : reg_array; 
    num_up : integer);

  procedure open_base   (state : lua.state_ptr_t);
  procedure open_table  (state : lua.state_ptr_t);
  procedure open_string (state : lua.state_ptr_t);
  procedure open_io     (state : lua.state_ptr_t);
  procedure open_math   (state : lua.state_ptr_t);
  procedure open_debug  (state : lua.state_ptr_t);

  procedure open_libs (state : lua.state_ptr_t);
end lua.lib;
