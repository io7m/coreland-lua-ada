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

  type int_t is new ic.int;
  subtype natural_t is int_t range 0 .. int_t'last;
  subtype number_t is ic.double;

  type error_t is (
    lua_error_none,
    lua_error_runtime,
    lua_error_file,
    lua_error_syntax,
    lua_error_memory,
    lua_error_error,
    lua_exception
  );
  for error_t use (
    lua_error_none => 0,
    lua_error_runtime => 1,
    lua_error_file => 2,
    lua_error_syntax => 3,
    lua_error_memory => 4,
    lua_error_error => 5,
    lua_exception => 6
  );

  type error_msg_t (length: natural) is
  record
    code: error_t;
    message: string (1 .. length);
  end record;

  no_error: constant error_msg_t := (
    length => 0,
    code => lua_error_none,
    message => ""
  );

  type state_ptr_t is private;
  type debug_t is private;

  state_error: constant state_ptr_t;

  registryindex: constant int_t := -10000;
  environindex:  constant int_t := -10001;
  globalsindex:  constant int_t := -10002;
  multret:       constant int_t := -1;

  registry_index: constant integer := -10000;
  environ_index:  constant integer := -10001;
  globals_index:  constant integer := -10002;
  mult_ret:       constant integer := -1;

  type user_func_t is access function (ls: state_ptr_t) return int_t;
  pragma convention (c, user_func_t);

  type hook_t is access procedure (ls: state_ptr_t; d: debug_t);
  pragma convention (c, hook_t);

  type chunk_reader_t is access function (ls: state_ptr_t; data: ics.chars_ptr;
    size: access ic.size_t) return ics.chars_ptr;
  pragma convention (c, chunk_reader_t);

  type chunk_writer_t is access function (ls: state_ptr_t; p: ics.chars_ptr;
    size: ic.size_t; data: ics.chars_ptr) return int_t;
  pragma convention (c, chunk_writer_t);

  type type_t is (
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
  function open return state_ptr_t;
  procedure close (ls: state_ptr_t);
  function at_panic (ls: state_ptr_t; panic_function: user_func_t) return user_func_t;

  -- stack manipulation
  function get_top (ls: state_ptr_t) return integer;
  procedure set_top (ls: state_ptr_t; index: integer);
  procedure push_value (ls: state_ptr_t; index: integer);
  procedure remove (ls: state_ptr_t; index: integer);
  procedure insert (ls: state_ptr_t; index: integer);
  procedure replace (ls: state_ptr_t; index: integer);
  function check_stack (ls: state_ptr_t; size: integer) return integer;

  -- check functions (stack -> ada)
  function is_number (ls: state_ptr_t; index: integer) return boolean;
  function is_string (ls: state_ptr_t; index: integer) return boolean;
  function is_user_function (ls: state_ptr_t; index: integer) return boolean;
  function is_user_data (ls: state_ptr_t; index: integer) return boolean;
  function is_nil (ls: state_ptr_t; index: integer) return boolean;
  function is_equal (ls: state_ptr_t; index1, index2: integer) return boolean;
  function is_raw_equal (ls: state_ptr_t; index1, index2: integer) return boolean;
  function is_less_than (ls: state_ptr_t; index1, index2: integer) return boolean;

  function type_of (ls: state_ptr_t; index: integer) return type_t;
  function type_name (ls: state_ptr_t; index: integer) return string;

  function to_number (ls: state_ptr_t; index: integer) return number_t;
  function to_string (ls: state_ptr_t; index: integer) return string;
  function to_boolean (ls: state_ptr_t; index: integer) return boolean;
  function to_cfunction (ls: state_ptr_t; index: integer) return user_func_t;

  function objlen (ls: state_ptr_t; index: integer) return int_t;
  function strlen (ls: state_ptr_t; index: integer) return int_t;

  -- function to_user_function (ls: state_ptr_t; index: integer) return user_func_t;
  -- function to_user_data (ls: state_ptr_t; index: integer) return void;
  -- function to_thread (ls: state_ptr_t; index: integer) return state_ptr_t;

  -- push functions (ada -> stack)
  procedure push_nil (ls: state_ptr_t);
  procedure push_number (ls: state_ptr_t; n: number_t);
  procedure push_boolean (ls: state_ptr_t; b: boolean);
  procedure push_string (ls: state_ptr_t; str: ics.chars_ptr);
  procedure push_string (ls: state_ptr_t; str: string);
  procedure push_string (ls: state_ptr_t; str: su.unbounded_string);
  procedure push_string (ls: state_ptr_t; address: system.address; amount: positive);
  procedure push_user_closure (ls: state_ptr_t; func: user_func_t; num_params: integer);
  procedure push_user_function (ls: state_ptr_t; func: user_func_t);

  -- new functions
  procedure new_table (ls: state_ptr_t);
   function new_thread (ls: state_ptr_t) return state_ptr_t;

  -- get functions (lua -> stack)
  procedure get_table (ls: state_ptr_t; index: integer);
   function get_metatable (ls: state_ptr_t; index: integer) return error_t;
  procedure raw_get (ls: state_ptr_t; index: integer);
  procedure raw_get_int (ls: state_ptr_t; index: integer; element: integer);
  procedure get_field (ls: state_ptr_t; index: integer; str: ics.chars_ptr);
  procedure get_field (ls: state_ptr_t; index: integer; str: string);
  procedure get_field (ls: state_ptr_t; index: integer; str: su.unbounded_string);
  procedure get_global (ls: state_ptr_t; str: ics.chars_ptr);
  procedure get_global (ls: state_ptr_t; str: string);
  procedure get_global (ls: state_ptr_t; str: su.unbounded_string);
  procedure get_fenv (ls: state_ptr_t; index: integer);

  -- set functions (stack -> lua)
  procedure set_table (ls: state_ptr_t; index: integer);
   function set_metatable (ls: state_ptr_t; index: integer) return error_t;
  procedure raw_set (ls: state_ptr_t; index: integer);
  procedure raw_set_int (ls: state_ptr_t; index: integer; element: integer);
  procedure set_field (ls: state_ptr_t; index: integer; str: ics.chars_ptr);
  procedure set_field (ls: state_ptr_t; index: integer; str: string);
  procedure set_field (ls: state_ptr_t; index: integer; str: su.unbounded_string);
  procedure set_global (ls: state_ptr_t; str: ics.chars_ptr);
  procedure set_global (ls: state_ptr_t; str: string);
  procedure set_global (ls: state_ptr_t; str: su.unbounded_string);
  function set_fenv (ls: state_ptr_t; index: integer) return error_t;

  -- load functions
  function load_buffer (ls: state_ptr_t; str: ics.chars_ptr; size: ic.size_t; name: string) return error_t;
  function load_buffer (ls: state_ptr_t; str: string; size: natural; name: string) return error_t;
  function load_buffer (ls: state_ptr_t; str: su.unbounded_string; name: string) return error_t;
  function load_file (ls: state_ptr_t; file: string) return error_t;
  function load_string (ls: state_ptr_t; str: string) return error_t;

  -- execute functions
  function exec_file (ls: state_ptr_t; file: string) return error_t;
  function exec_string (ls: state_ptr_t; str: string) return error_t;

  -- coroutines
  function resume (ls: state_ptr_t; num_args: integer) return error_msg_t;
  function yield (ls: state_ptr_t; nresults: int_t) return int_t;
  pragma import(c, yield, "lua_yield");

  -- misc
  procedure concat (ls: state_ptr_t; n: natural);
  procedure register (ls: state_ptr_t; func_name: string; func_ptr: user_func_t);
  procedure pop (ls: state_ptr_t; count: integer);
  function next (ls: state_ptr_t; index: integer) return integer;

  type obj_ref_t is new integer;
  nil_reference: constant obj_ref_t := -1;
  no_reference: constant obj_ref_t := -2;

  function reference (ls: state_ptr_t; table: integer) return obj_ref_t;
  procedure unreference (ls: state_ptr_t; table: integer; ref: obj_ref_t);

  pragma import (c, reference, "luaL_ref");
  pragma import (c, unreference, "luaL_unref");

  function reference (ls: state_ptr_t) return obj_ref_t;
  procedure unreference (ls: state_ptr_t; ref: obj_ref_t);
  procedure dereference (ls: state_ptr_t; ref: obj_ref_t);

  -- lua calls
  procedure call (ls: state_ptr_t; num_arguments: integer; num_results: integer);
  function pcall (ls: state_ptr_t; num_arguments, num_results, error_func: integer) return error_t;

  procedure error (ls: state_ptr_t);
  pragma no_return (error);

  -- versioning
  function version return string;
  function release return string;
  function version return integer;

  -- debug hooks
  type mask_t is mod 16;

  mask_none:   constant mask_t := 2#0000_0000#;
  mask_call:   constant mask_t := 2#0000_0001#;
  mask_return: constant mask_t := 2#0000_0010#;
  mask_line:   constant mask_t := 2#0000_0100#;
  mask_count:  constant mask_t := 2#0000_1000#;

  procedure set_hook (ls: state_ptr_t; func: hook_t; amask: mask_t; count: integer);
  function get_hook_mask (ls: state_ptr_t) return mask_t;

  private

  type state_ptr_t is new system.address;
  type debug_t is new system.address;
  state_error: constant state_ptr_t := state_ptr_t (system.null_address);

  str_traceback: constant ics.chars_ptr := ics.new_string("_traceback");

  msg_err_none:      aliased string := "";
  msg_err_syntax:    aliased string := "syntax error: ";
  msg_error_runtime: aliased string := "runtime error: ";
  msg_err_memory:    aliased string := "memory error: ";
  msg_err_error:     aliased string := "error-handling error: ";
  msg_err_file:      aliased string := "file error: ";

  type str_access_t is access all string;
  type str_access_array_t is array (error_t) of str_access_t;

  error_messages: str_access_array_t := (
    lua_error_none    => msg_err_none'access,
    lua_error_runtime => msg_error_runtime'access,
    lua_error_memory  => msg_err_memory'access,
    lua_error_file    => msg_err_file'access,
    lua_error_syntax  => msg_err_syntax'access,
    lua_error_error   => msg_err_error'access,
    lua_exception     => msg_err_none'access
  );
end lua;
