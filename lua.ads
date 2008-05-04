-- Lua API

with interfaces.c;
with interfaces.c.strings;
with system;
with ada.strings.unbounded;

package lua is
  package ic renames interfaces.c;
  package ics renames interfaces.c.strings;
  package su renames ada.strings.unbounded;

  use type ics.chars_ptr;
  use type ic.int;

  --
  -- These types must match the integer types defined in your Lua implementation.
  --

  type lua_int is new ic.int;
  subtype lua_natural is lua_int range 0 .. lua_int'last;
  subtype lua_number is ic.double;

  type error_type is (
    lua_error_none,
    lua_error_runtime,
    lua_error_file,
    lua_error_syntax,
    lua_error_memory,
    lua_error_error,
    lua_exception
  );
  for error_type use (
    lua_error_none => 0,
    lua_error_runtime => 1,
    lua_error_file => 2,
    lua_error_syntax => 3,
    lua_error_memory => 4,
    lua_error_error => 5,
    lua_exception => 6
  );

  type error_message (length: natural) is
  record
    code: error_type;
    message: string (1 .. length);
  end record;

  no_error: constant error_message := (
    length => 0,
    code => lua_error_none,
    message => ""
  );

  type state is private;
  type debug_structure is private;

  state_error: constant state;

  registryindex: constant lua_int := -10000;
  environindex:  constant lua_int := -10001;
  globalsindex:  constant lua_int := -10002;
  multret:       constant lua_int := -1;

  registry_index: constant integer := -10000;
  environ_index:  constant integer := -10001;
  globals_index:  constant integer := -10002;
  mult_ret:       constant integer := -1;

  type user_function is access function (ls: state) return lua_int;
  pragma convention(c, user_function);
  type hook_procedure is access procedure (ls: state; d: debug_structure);
  pragma convention(c, hook_procedure);
  type chunk_reader is access function (ls: state; data: ics.chars_ptr; size: access ic.size_t) return ics.chars_ptr;
  pragma convention(c, chunk_reader);
  type chunk_writer is access function (ls: state; p: ics.chars_ptr; size: ic.size_t; data: ics.chars_ptr) return lua_int;
  pragma convention(c, chunk_writer);

  type lua_ttype is (
    t_none,
    t_nil,
    t_boolean,
    t_lightuserdata,
    t_number,
    t_string,
    t_table,
    t_function,
    t_userdata,
    t_thread
  );

  -- state manipulation
  function open return state;
  procedure close (ls: state);
  function at_panic (ls: state; panic_function: user_function) return user_function;

  -- stack manipulation
  function get_top (ls: state) return integer;
  procedure set_top (ls: state; index: integer);
  procedure push_value (ls: state; index: integer);
  procedure remove (ls: state; index: integer);
  procedure insert (ls: state; index: integer);
  procedure replace (ls: state; index: integer);
  function check_stack (ls: state; size:  integer) return integer;

  -- check functions (stack -> ada)
  function is_number (ls: state; index: integer) return boolean;
  function is_string (ls: state; index: integer) return boolean;
  function is_user_function (ls: state; index: integer) return boolean;
  function is_user_data (ls: state; index: integer) return boolean;
  function is_nil (ls: state; index: integer) return boolean;
  function is_equal (ls: state; index1, index2: integer) return boolean;
  function is_raw_equal (ls: state; index1, index2: integer) return boolean;
  function is_less_than (ls: state; index1, index2: integer) return boolean;

  function type_of (ls: state; index: integer) return lua_ttype;
  function type_name (ls: state; index: integer) return string;

  function to_number (ls: state; index: integer) return lua_number;
  function to_string (ls: state; index: integer) return string;
  function to_boolean (ls: state; index: integer) return boolean;
  function to_cfunction (ls: state; index: integer) return user_function;

  function objlen (ls: state; index: integer) return lua_int;
  function strlen (ls: state; index: integer) return lua_int;

  -- function to_user_function (ls: state; index: integer) return user_function;
  -- function to_user_data (ls: state; index: integer) return void;
  -- function to_thread (ls: state; index: integer) return state;

  -- push functions (ada -> stack)
  procedure push_nil (ls: state);
  procedure push_number (ls: state; n: lua_number);
  procedure push_boolean (ls: state; b: boolean);
  procedure push_string (ls: state; str: ics.chars_ptr);
  procedure push_string (ls: state; str: string);
  procedure push_string (ls: state; str: su.unbounded_string);
  procedure push_string (ls: state; address: system.address; amount: positive);
  procedure push_user_closure (ls: state; func: user_function; num_params: integer);
  procedure push_user_function (ls: state; func: user_function);

  -- new functions
  procedure new_table (ls: state);
   function new_thread (ls: state) return state;

  -- get functions (lua -> stack)
  procedure get_table (ls: state; index: integer);
   function get_metatable (ls: state; index: integer) return error_type;
  procedure raw_get (ls: state; index: integer);
  procedure raw_get_int (ls: state; index: integer; element: integer);
  procedure get_field (ls: state; index: integer; str: ics.chars_ptr);
  procedure get_field (ls: state; index: integer; str: string);
  procedure get_field (ls: state; index: integer; str: su.unbounded_string);
  procedure get_global (ls: state; str: ics.chars_ptr);
  procedure get_global (ls: state; str: string);
  procedure get_global (ls: state; str: su.unbounded_string);
  procedure get_fenv (ls: state; index: integer);

  -- set functions (stack -> lua)
  procedure set_table (ls: state; index: integer);
   function set_metatable (ls: state; index: integer) return error_type;
  procedure raw_set (ls: state; index: integer);
  procedure raw_set_int (ls: state; index: integer; element: integer);
  procedure set_field (ls: state; index: integer; str: ics.chars_ptr);
  procedure set_field (ls: state; index: integer; str: string);
  procedure set_field (ls: state; index: integer; str: su.unbounded_string);
  procedure set_global (ls: state; str: ics.chars_ptr);
  procedure set_global (ls: state; str: string);
  procedure set_global (ls: state; str: su.unbounded_string);
  function set_fenv (ls: state; index: integer) return error_type;

  -- load functions
  function load_buffer (ls: state; str: ics.chars_ptr; size: ic.size_t; name: string) return error_type;
  function load_buffer (ls: state; str: string; size: natural; name: string) return error_type;
  function load_buffer (ls: state; str: su.unbounded_string; name: string) return error_type;
  function load_file (ls: state; file: string) return error_type;
  function load_string (ls: state; str: string) return error_type;

  -- execute functions
  function exec_file (ls: state; file: string) return error_type;
  function exec_string (ls: state; str: string) return error_type;

  -- coroutines
  function resume (ls: state; num_args: integer) return error_message;
  function yield (ls: state; nresults: lua_int) return lua_int;
  pragma import(c, yield, "lua_yield");

  -- misc
  procedure concat (ls: state; n: natural);
  procedure register (ls: state; function_name: string; function_access: user_function);
  procedure pop (ls: state; count: integer);

  type object_reference is new integer;
  nil_reference: constant object_reference := -1;
  no_reference: constant object_reference := -2;

  function reference (ls: state; table: integer) return object_reference;
  procedure unreference (ls: state; table: integer; ref: object_reference);

  pragma import (c, reference, "luaL_ref");
  pragma import (c, unreference, "luaL_unref");

  function reference (ls: state) return object_reference;
  procedure unreference (ls: state; ref: object_reference);
  procedure dereference (ls: state; ref: object_reference);

  -- lua calls
  procedure call (ls: state; num_arguments: integer; num_results: integer);
  function pcall (ls: state; num_arguments, num_results, error_func: integer) return error_type;

  procedure error (ls: state);
  pragma no_return (error);

  -- versioning
  function version return string;
  function release return string;
  function version return integer;

  -- debug hooks
  type mask is mod 16;

  mask_none:   constant mask := 2#0000_0000#;
  mask_call:   constant mask := 2#0000_0001#;
  mask_return: constant mask := 2#0000_0010#;
  mask_line:   constant mask := 2#0000_0100#;
  mask_count:  constant mask := 2#0000_1000#;

  procedure set_hook (ls: state; func: hook_procedure; amask: mask; count: integer);
  function get_hook_mask (ls: state) return mask;

  private

  type state is new system.address;
  type debug_structure is new system.address;
  state_error: constant state := state (system.null_address);

  str_traceback: constant ics.chars_ptr := ics.new_string("_traceback");

  msg_err_none:      aliased string := "";
  msg_err_syntax:    aliased string := "syntax error: ";
  msg_error_runtime: aliased string := "runtime error: ";
  msg_err_memory:    aliased string := "memory error: ";
  msg_err_error:     aliased string := "error-handling error: ";
  msg_err_file:      aliased string := "file error: ";

  type stra is access all string;
  type stra_array is array (error_type) of stra;

  error_messages: stra_array := (
    lua_error_none    => msg_err_none'access,
    lua_error_runtime => msg_error_runtime'access,
    lua_error_memory  => msg_err_memory'access,
    lua_error_file    => msg_err_file'access,
    lua_error_syntax  => msg_err_syntax'access,
    lua_error_error   => msg_err_error'access,
    lua_exception     => msg_err_none'access
  );

end lua;
