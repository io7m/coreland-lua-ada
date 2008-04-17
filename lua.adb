-- Lua API

with ada.text_io;
with ada.exceptions;
use ada.text_io;

package body lua is

  function luext_version return ics.chars_ptr;
  pragma import (c, luext_version, "luext_version");

  function luext_version_num return lua_int;
  pragma import (c, luext_version_num, "luext_version_num");

  function luext_release return ics.chars_ptr;
  pragma import (c, luext_release, "luext_release");

  function luaL_newstate return state;
  pragma import (c, luaL_newstate, "luaL_newstate");

  procedure lua_close (ls: state);
  pragma import (c, lua_close, "lua_close");

  function lua_newthread (ls: state) return state;
  pragma import (c, lua_newthread, "lua_newthread");

  function lua_gettop (ls: state) return lua_int;
  pragma import (c, lua_gettop, "lua_gettop");

  procedure lua_settop (ls: state; index: lua_int);
  pragma import (c, lua_settop, "lua_settop");

  function lua_checkstack (ls: state; extra: lua_int) return lua_int;
  pragma import (c, lua_checkstack, "lua_checkstack");

  procedure lua_pushvalue (ls: state; index: lua_int);
  pragma import (c, lua_pushvalue, "lua_pushvalue");

  procedure lua_remove (ls: state; index: lua_int);
  pragma import (c, lua_remove, "lua_remove");

  procedure lua_insert (ls: state; index: lua_int);
  pragma import (c, lua_insert, "lua_insert");

  procedure lua_replace (ls: state; index: lua_int);
  pragma import (c, lua_replace, "lua_replace");

  -- access functions
  function lua_typename (ls: state; index: lua_int) return ics.chars_ptr;
  pragma import (c, lua_typename, "lua_typename");

  function lua_type (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_type, "lua_type");

  function lua_isnumber (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_isnumber, "lua_isnumber");

  function lua_isnil (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_isnil, "lua_isnil");

  function lua_isstring (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_isstring, "lua_isstring");

  function lua_iscfunction (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_iscfunction, "lua_iscfunction");

  function lua_isuserdata (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_isuserdata, "lua_isuserdata");

  function lua_equal (ls: state; index1, index2: lua_int) return lua_int;
  pragma import (c, lua_equal, "lua_equal");

  function lua_rawequal (ls: state; index1, index2: lua_int) return lua_int;
  pragma import (c, lua_rawequal, "lua_rawequal");

  function lua_lessthan (ls: state; index1, index2: lua_int) return lua_int;
  pragma import (c, lua_lessthan, "lua_lessthan");

  function lua_toboolean (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_toboolean, "lua_toboolean");

  function lua_tonumber (ls: state; index: lua_int) return lua_number;
  pragma import (c, lua_tonumber, "lua_tonumber");

  function luext_tostring (ls: state; index: lua_int) return ics.chars_ptr;
  pragma import (c, luext_tostring, "luext_tostring");

  function lua_strlen (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_strlen, "lua_strlen");

  function lua_tocfunction (ls: state; index: lua_int) return user_function;
  pragma import (c, lua_tocfunction, "lua_tocfunction");

  -- push functions
  procedure lua_pushboolean (ls: state; b: lua_int);
  pragma import (c, lua_pushboolean, "lua_pushboolean");

  procedure lua_pushnumber (ls: state; n: lua_number);
  pragma import (c, lua_pushnumber, "lua_pushnumber");

  procedure lua_pushstring (ls: state; s: ics.chars_ptr);
  pragma import (c, lua_pushstring, "lua_pushstring");

  procedure lua_pushstring2 (ls: state; s: system.address);
  pragma import (c, lua_pushstring2, "lua_pushstring");

  procedure lua_pushlstring (ls: state; s: system.address; a: integer);
  pragma import (c, lua_pushlstring, "lua_pushlstring");

  procedure lua_pushnil (ls: state);
  pragma import (c, lua_pushnil, "lua_pushnil");

  procedure lua_pushcclosure (ls: in state; fn: in user_function; num: in lua_int);
  pragma import (c, lua_pushcclosure, "lua_pushcclosure");

  procedure lua_concat (ls: state; num: lua_natural);
  pragma import (c, lua_concat, "lua_concat");

  -- metatable functions
  function lua_getmetatable (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_getmetatable, "lua_getmetatable");

  function lua_setmetatable (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_setmetatable, "lua_setmetatable");

  -- environment functions
  procedure lua_getfenv (ls: state; index: lua_int);
  pragma import (c, lua_getfenv, "lua_getfenv");

  function lua_setfenv (ls: state; index: lua_int) return lua_int;
  pragma import (c, lua_setfenv, "lua_setfenv");

  -- registered functions
  procedure lua_call (ls: in state; num_args: in lua_int; num_results: in lua_int);
  pragma import (c, lua_call, "lua_call");

  function lua_pcall (ls: in state; num_args: in lua_int; num_results: in lua_int; error_f: in lua_int) return lua_int;
  pragma import (c, lua_pcall, "lua_pcall");

  -- table functions
  procedure lua_createtable (ls: state; num_arr: lua_int; num_rec: lua_int);
  pragma import (c, lua_createtable, "lua_createtable");

  procedure lua_settable (ls: state; index: lua_int);
  pragma import (c, lua_settable, "lua_settable");

  procedure lua_gettable (ls: state; index: lua_int);
  pragma import (c, lua_gettable, "lua_gettable");

  procedure lua_rawget (ls: state; index: lua_int);
  pragma import (c, lua_rawget, "lua_rawget");

  procedure lua_rawset (ls: state; index: lua_int);
  pragma import (c, lua_rawset, "lua_rawset");

  procedure lua_rawgeti (ls: state; index, element: lua_int);
  pragma import (c, lua_rawgeti, "lua_rawgeti");

  procedure lua_rawseti (ls: state; index, element: lua_int);
  pragma import (c, lua_rawseti, "lua_rawseti");

  -- errors
  function lua_atpanic (ls: state; func: user_function) return user_function;
  pragma import (c, lua_atpanic, "lua_atpanic");

  procedure lua_error (ls: state);
  pragma import (c, lua_error, "lua_error");
  pragma no_return(lua_error);

  procedure lua_sethook (ls: state; func: hook_procedure; amask, count: lua_int);
  pragma import (c, lua_sethook, "lua_sethook");

  function lua_gethookmask (ls: state) return lua_int;
  pragma import (c, lua_gethookmask, "lua_gethookmask");

  procedure set_hook (ls: state; func: hook_procedure; amask: mask; count: integer) is
  begin
    lua_sethook (ls, func, lua_int (amask), lua_int (count));
  end set_hook;

  function get_hook_mask (ls: state) return mask is
  begin
    return mask (lua_gethookmask (ls));
  end get_hook_mask;

  procedure error (ls: state) is
  begin
    lua_error (ls);
  end error;

  -- state manipulation
  function open return state is
  begin
    return luaL_newstate;
  end open;

  procedure close (ls: state)  is
  begin
    lua_close (ls);
  end close;

  function new_thread (ls: state) return state is
  begin
    return lua_newthread (ls);
  end new_thread;

  function at_panic (ls: state; panic_function: user_function) return user_function is
  begin
    return lua_atpanic (ls, panic_function);
  end at_panic;

  -- stack manipulation
  function get_top (ls: state) return integer is
  begin
    return integer (lua_gettop (ls));
  end get_top;

  procedure set_top (ls: state; index: integer) is
  begin
    lua_settop (ls, lua_int (index));
  end set_top;

  procedure push_value (ls: state; index: integer) is
  begin
    lua_pushvalue (ls, lua_int (index));
  end push_value;

  procedure remove (ls: state; index: integer) is
  begin
    lua_remove (ls, lua_int (index));
  end remove;

  procedure insert (ls: state; index: integer) is
  begin
    lua_insert (ls, lua_int (index));
  end insert;

  procedure replace (ls: state; index: integer) is
  begin
    lua_replace (ls, lua_int (index));
  end replace;

  function check_stack(ls: state; size: integer) return integer is
  begin
    return integer (lua_checkstack (ls, lua_int (size)));
  end check_stack;

  -- access functions (stack -> ada)
  function is_number (ls: state; index: integer) return boolean is
  begin
    return lua_isnumber (ls, lua_int (index)) /= 0;
  end is_number;

  function is_string (ls: state; index: integer) return boolean is
  begin
    return lua_isstring (ls, lua_int (index)) /= 0;
  end is_string;

  function is_user_function (ls: state; index: integer) return boolean is
  begin
    return lua_iscfunction (ls, lua_int (index)) /= 0;
  end is_user_function;

  function is_user_data (ls: state; index: integer) return boolean is
  begin
    return lua_isuserdata (ls, lua_int (index)) /= 0;
  end is_user_data;

  function is_nil (ls: state; index: integer) return boolean is
  begin
    return lua_type (ls, lua_int (index))=0;
  end is_nil;

  function type_of (ls: state; index: integer) return lua_ttype is
    x: lua_int;
  begin
    x := lua_type (ls, lua_int (index));
    return lua_ttype'val (x+1);
  end type_of;

  function type_name (ls: state; index: integer) return string is
  begin
    return ics.value (lua_typename (ls, lua_int (index)));
  end type_name;

  function to_number (ls: state; index: integer) return lua_number is
  begin
    return lua_tonumber (ls, lua_int (index));
  end to_number;

  function to_string (ls: state; index: integer) return string is
    x: ics.chars_ptr;
    use ics;
  begin
    x := luext_tostring (ls, lua_int (index));
    if x /= ics.null_ptr then return ics.value (x); else return ""; end if;
  end to_string;

  function to_boolean (ls: state; index: integer) return boolean is
  begin
    return lua_toboolean (ls, lua_int (index))/=0;
  end to_boolean;

  function is_equal (ls: state; index1, index2: integer) return boolean is
  begin
    return lua_equal (ls, lua_int (index1), lua_int (index2)) /= 0;
  end is_equal;

  function is_raw_equal (ls: state; index1, index2: integer) return boolean is
  begin
    return lua_rawequal (ls, lua_int (index1), lua_int (index2)) /= 0;
  end is_raw_equal;

  function is_less_than (ls: state; index1, index2: integer) return boolean is
  begin
    return lua_lessthan (ls, lua_int (index1), lua_int (index2)) /= 0;
  end is_less_than;

  -- push functions (ada -> stack)
  procedure push_nil (ls: state) is
  begin
    lua_pushnil (ls);
  end push_nil;

  procedure push_number (ls: state; n: lua_number) is
  begin
    lua_pushnumber (ls, n);
  end push_number;

  procedure push_boolean (ls: state; b: boolean) is
  begin
    if b then
      lua_pushboolean (ls, 1);
    else
      lua_pushboolean (ls, 0);
    end if;
  end push_boolean;

  procedure push_string (ls: state; pchar: ics.chars_ptr) is
  begin
    lua_pushstring (ls, pchar);
  end push_string;

  procedure push_string (ls: state; str: string) is
  begin
    if str'length > 0 then
      lua_pushlstring (ls, str (str'first)'address, str'length);
    else
      lua_pushlstring (ls, system.null_address, 0);
    end if;
  end push_string;

  procedure push_string (ls: state; str: unbounded_string) is
    x: ics.chars_ptr := ics.new_string (to_string (str));
  begin
    lua_pushstring (ls, x);
    ics.free (x);
  end push_string;

  procedure push_string (ls: state; address: system.address; amount: positive) is
  begin
    lua_pushlstring (ls, address, amount);
  end push_string;

  procedure push_user_closure (ls: state; func: user_function; num_params: integer) is
  begin
    lua_pushcclosure (ls, func, lua_int (num_params));
  end push_user_closure;

  procedure push_user_function (ls: state; func: user_function) is
  begin
    lua_pushcclosure (ls, func, 0);
  end push_user_function;

  procedure concat (ls: state; n: natural) is
  begin
    lua_concat (ls, lua_int (n));
  end concat;

  -- get functions (lua -> stack)
  procedure get_table (ls: state; index: integer) is
  begin
    lua_gettable (ls, lua_int (index));
  end get_table;

  function get_metatable (ls: state; index: integer) return error_type is
  begin
    return error_type'val (lua_getmetatable (ls, lua_int (index)));
  end get_metatable;

  procedure raw_get (ls: state; index: integer) is
  begin
    lua_rawget (ls, lua_int (index));
  end raw_get;

  procedure raw_get_int (ls: state; index: integer; element: integer) is
  begin
    lua_rawgeti (ls, lua_int (index), lua_int (element));
  end raw_get_int;

  -- set functions (stack -> lua)
  procedure set_table     (ls: state; index: integer) is
  begin
    lua_settable (ls, lua_int (index));
  end set_table;

  function set_metatable (ls: state; index: integer) return error_type is
  begin
    return error_type'val (lua_setmetatable (ls, lua_int (index)));
  end set_metatable;

  procedure raw_set (ls: state; index: integer) is
  begin
    lua_rawset (ls, lua_int (index));
  end raw_set;

  procedure new_table (ls: state) is
  begin
     lua_createtable (ls, 0, 0);
  end new_table;

  procedure raw_set_int (ls: state; index: integer; element: integer) is
  begin
     lua_rawseti (ls, lua_int (index), lua_int (element));
  end raw_set_int;

  -- coroutines
  function lua_resume (ls: state; narg: lua_int) return lua_int;
  pragma import (c, lua_resume, "lua_resume");

  function ret_error (e: error_type; s: string) return error_message is
    z: constant string := error_messages (e).all & s;
  begin
    return (z'length, e, z);
  end ret_error;
  pragma inline (ret_error);

  function resume (ls: state; num_args: integer) return error_message is
    error: error_type;
    ndx: constant lua_int := lua_gettop (ls) - lua_int (num_args);
  begin
    push_string (ls, "_traceback");
    lua_rawget (ls, globalsindex);
    lua_insert (ls, ndx);
    error := error_type'val (lua_resume (ls, lua_int (num_args)));
    lua_remove (ls, ndx);
    if error /= lua_error_none then
      return ret_error (error, to_string (ls, -1));
    else
      return no_error;
    end if;
  exception
    when damned_error: others =>
      return ret_error (lua_exception, "exception while doing lua.traced_call:" & ascii.lf & ascii.cr & ada.exceptions.exception_information (damned_error));
  end resume;

  -- misc
  procedure register (ls: state; function_name: string; function_access: user_function) is
  begin
    push_string (ls, function_name);
    lua_pushcclosure (ls, function_access, 0);
    lua_settable (ls, globalsindex);
  end;

  function lua_load (ls: state; reader: chunk_reader; data: ics.chars_ptr; chunk_name: ics.chars_ptr) return lua_int;
  pragma import (c, lua_load, "lua_load");

  function traced_call (ls: state; num_arguments, num_results: integer) return error_message is
    error: error_type;
    ndx: constant lua_int := lua_gettop (ls) - lua_int (num_arguments);
  begin
    push_string (ls, "_traceback");
    lua_rawget (ls, globalsindex);
    lua_insert (ls, ndx);
    error := error_type'val (lua_pcall (ls, lua_int (num_arguments), lua_int (num_results), ndx));
    lua_remove (ls, ndx);
    if error /= lua_error_none then
      return ret_error (error, to_string (ls, -1));
    else
      return no_error;
    end if;
  exception
    when damned_error: others =>
      return ret_error (lua_exception, "traced call exception:" & ascii.lf & ascii.cr & ada.exceptions.exception_information (damned_error));
  end traced_call;
  pragma inline (traced_call);

  function protected_call (ls: state; num_arguments, num_results, error_func: integer := 0) return error_message is
    error: error_type;
    ndx: constant lua_int := lua_gettop (ls) - lua_int (num_arguments);
  begin
    error := error_type'val (lua_pcall (ls, lua_int (num_arguments), lua_int (num_results), lua_int (error_func)));
    if error /= lua_error_none then
      return ret_error (error, to_string (ls, -1));
    else
      return no_error;
    end if;
  exception
    when damned_error: others =>
      return ret_error (lua_exception, "protected call exception:" & ascii.lf & ascii.cr & ada.exceptions.exception_information (damned_error));
  end protected_call;
  pragma inline (protected_call);

  procedure call (ls: state; num_arguments, num_results: integer) is
  begin
    lua_call (ls, lua_int (num_arguments), lua_int (num_results));
  exception
    when damned_error: others =>
      put_line ("call exception:" & ascii.lf & ascii.cr & ada.exceptions.exception_information (damned_error));
  end call;
  pragma inline (call);

  procedure pop (ls: state; count: integer) is
  begin
    set_top (ls, -(count)-1);
  end pop;
  pragma inline (pop);

  function reference (ls : state) return object_reference is
  begin
    return reference (ls, registry_index);
  end reference;

  procedure unreference (ls : state; ref : object_reference) is
  begin
    unreference (ls, registry_index, ref);
  end unreference;

  procedure dereference (ls : state; ref : object_reference) is
  begin
    raw_get_int (ls, registry_index, integer (ref));
  end dereference;

  function string_reader (ls: state; data: ics.chars_ptr; size: access ic.size_t) return ics.chars_ptr is
    temp: constant ics.chars_ptr := ics.new_string (ics.value (data));
    use ic;
  begin
    size.all := ics.strlen (data);
    ics.update (data, 0, ic.to_c (""), false);
    return temp;
  end string_reader;

  function execute_string (ls: state; code: string; chunk_name: string := "[luada]") return error_message is
    buf: ics.chars_ptr := ics.new_string (code);
    chunk: ics.chars_ptr := ics.new_string ("=" & chunk_name);
    error: error_type;
  begin
    error := error_type'val (lua_load (ls, string_reader'access, buf, chunk));
    ics.free (buf);
    ics.free (chunk);
    if error = lua_error_none then
      return traced_call (ls, 0, 0);
    else
      return ret_error (lua_error_syntax, ics.value (luext_tostring (ls, -1)));
    end if;
  end execute_string;

  function execute_file (ls: state; file_name: string) return error_message is
    f: ada.text_io.file_type;
    s: string (1..4096);
    n: natural;
    z: unbounded_string;
  begin
    open (f, in_file, file_name);
    while not end_of_file (f) loop
      get_line (f, s, n);
      append (z, s (1 .. n) & ascii.lf);
    end loop;
    close (f);
    return execute_string (ls, to_string (z), file_name);
  end execute_file;

  function version return string is
  begin
    return ics.value (luext_version);
  end version;

  function version return integer is
  begin
    return integer (luext_version_num);
  end version;

  function release return string is
  begin
    return ics.value (luext_release);
  end release;

end lua;
