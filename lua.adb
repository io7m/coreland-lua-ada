-- Lua API

with ada.text_io;
with ada.exceptions;

package body lua is
  package io renames ada.text_io;

  --
  -- C functions.
  --

  function luext_version return ics.chars_ptr;
  pragma import (c, luext_version, "luext_version");

  function luext_version_num return int_t;
  pragma import (c, luext_version_num, "luext_version_num");

  function luext_release return ics.chars_ptr;
  pragma import (c, luext_release, "luext_release");

  function luaL_newstate return state_ptr_t;
  pragma import (c, luaL_newstate, "luaL_newstate");

  procedure lua_close (ls: state_ptr_t);
  pragma import (c, lua_close, "lua_close");

  function lua_newthread (ls: state_ptr_t) return state_ptr_t;
  pragma import (c, lua_newthread, "lua_newthread");

  function lua_gettop (ls: state_ptr_t) return int_t;
  pragma import (c, lua_gettop, "lua_gettop");

  procedure lua_settop (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_settop, "lua_settop");

  function lua_checkstack (ls: state_ptr_t; extra: int_t) return int_t;
  pragma import (c, lua_checkstack, "lua_checkstack");

  procedure lua_pushvalue (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_pushvalue, "lua_pushvalue");

  procedure lua_remove (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_remove, "lua_remove");

  procedure lua_insert (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_insert, "lua_insert");

  procedure lua_replace (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_replace, "lua_replace");

  --
  -- access functions
  --

  function lua_typename (ls: state_ptr_t; index: int_t) return ics.chars_ptr;
  pragma import (c, lua_typename, "lua_typename");

  function lua_type (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_type, "lua_type");

  function lua_isnumber (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_isnumber, "lua_isnumber");

  function lua_isstring (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_isstring, "lua_isstring");

  function lua_iscfunction (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_iscfunction, "lua_iscfunction");

  function lua_isuserdata (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_isuserdata, "lua_isuserdata");

  function lua_equal (ls: state_ptr_t; index1, index2: int_t) return int_t;
  pragma import (c, lua_equal, "lua_equal");

  function lua_rawequal (ls: state_ptr_t; index1, index2: int_t) return int_t;
  pragma import (c, lua_rawequal, "lua_rawequal");

  function lua_lessthan (ls: state_ptr_t; index1, index2: int_t) return int_t;
  pragma import (c, lua_lessthan, "lua_lessthan");

  function lua_toboolean (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_toboolean, "lua_toboolean");

  function lua_tonumber (ls: state_ptr_t; index: int_t) return number_t;
  pragma import (c, lua_tonumber, "lua_tonumber");

  function luext_tostring (ls: state_ptr_t; index: int_t) return ics.chars_ptr;
  pragma import (c, luext_tostring, "luext_tostring");

  function lua_objlen (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_objlen, "lua_objlen");

  function lua_tocfunction (ls: state_ptr_t; index: int_t) return user_func_t;
  pragma import (c, lua_tocfunction, "lua_tocfunction");

  --
  -- push functions
  --

  procedure lua_pushboolean (ls: state_ptr_t; b: int_t);
  pragma import (c, lua_pushboolean, "lua_pushboolean");

  procedure lua_pushnumber (ls: state_ptr_t; n: number_t);
  pragma import (c, lua_pushnumber, "lua_pushnumber");

  procedure lua_pushstring (ls: state_ptr_t; s: ics.chars_ptr);
  pragma import (c, lua_pushstring, "lua_pushstring");

  procedure lua_pushlstring (ls: state_ptr_t; s: system.address; a: integer);
  pragma import (c, lua_pushlstring, "lua_pushlstring");

  procedure lua_pushnil (ls: state_ptr_t);
  pragma import (c, lua_pushnil, "lua_pushnil");

  procedure lua_pushcclosure (ls: in state_ptr_t; fn: in user_func_t; num: in int_t);
  pragma import (c, lua_pushcclosure, "lua_pushcclosure");

  procedure lua_concat (ls: state_ptr_t; num: natural_t);
  pragma import (c, lua_concat, "lua_concat");

  function lua_next (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_next, "lua_next");

  --
  -- metatable functions
  --

  function lua_getmetatable (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_getmetatable, "lua_getmetatable");

  function lua_setmetatable (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_setmetatable, "lua_setmetatable");

  --
  -- environment functions
  --

  procedure lua_getfenv (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_getfenv, "lua_getfenv");

  function lua_setfenv (ls: state_ptr_t; index: int_t) return int_t;
  pragma import (c, lua_setfenv, "lua_setfenv");

  --
  -- registered functions
  --

  procedure lua_call (ls: in state_ptr_t; num_args: in int_t; num_results: in int_t);
  pragma import (c, lua_call, "lua_call");

  function lua_pcall (ls: in state_ptr_t; num_args: in int_t; num_results: in int_t;
    error_f: in int_t) return int_t;
  pragma import (c, lua_pcall, "lua_pcall");

  --
  -- table functions
  --

  procedure lua_createtable (ls: state_ptr_t; num_arr: int_t; num_rec: int_t);
  pragma import (c, lua_createtable, "lua_createtable");

  procedure lua_settable (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_settable, "lua_settable");

  procedure lua_gettable (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_gettable, "lua_gettable");

  procedure lua_rawget (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_rawget, "lua_rawget");

  procedure lua_rawset (ls: state_ptr_t; index: int_t);
  pragma import (c, lua_rawset, "lua_rawset");

  procedure lua_rawgeti (ls: state_ptr_t; index, element: int_t);
  pragma import (c, lua_rawgeti, "lua_rawgeti");

  procedure lua_rawseti (ls: state_ptr_t; index, element: int_t);
  pragma import (c, lua_rawseti, "lua_rawseti");

  --
  -- errors
  --

  function lua_atpanic (ls: state_ptr_t; func: user_func_t) return user_func_t;
  pragma import (c, lua_atpanic, "lua_atpanic");

  procedure lua_error (ls: state_ptr_t);
  pragma import (c, lua_error, "lua_error");
  pragma no_return (lua_error);

  procedure lua_sethook (ls: state_ptr_t; func: hook_t; amask, count: int_t);
  pragma import (c, lua_sethook, "lua_sethook");

  function lua_gethookmask (ls: state_ptr_t) return int_t;
  pragma import (c, lua_gethookmask, "lua_gethookmask");

  --
  -- set functions
  --

  procedure lua_setfield (ls: state_ptr_t; index: int_t; key: ics.chars_ptr);
  pragma import (c, lua_setfield, "lua_setfield");

  --
  -- get functions
  --

  procedure lua_getfield (ls: state_ptr_t; index: int_t; key: ics.chars_ptr);
  pragma import (c, lua_getfield, "lua_getfield");

  --
  -- load functions
  --

  type buffer_ctx is record
    buff: ics.chars_ptr;
    size: ic.size_t;
  end record;
  pragma convention (c, buffer_ctx);

  type buffer_func is
    access function (ls: state_ptr_t; data: access buffer_ctx; size: access ic.size_t)
      return ics.chars_ptr;

  function lua_load_buffer (ls: state_ptr_t;
    func: buffer_func;
    data: access buffer_ctx;
    name: ics.chars_ptr)
    return int_t;
  pragma import (c, lua_load_buffer, "lua_load");

  -- buffer reader callback
  -- XXX: should be C calling convention

  function read_buffer (ls: state_ptr_t; data: access buffer_ctx; size: access ic.size_t) return ics.chars_ptr is
    use type ic.size_t;
    size_alias: constant access ic.size_t := size;
  begin
    if data.size = 0 then return ics.null_ptr; end if;
    size_alias.all := data.size;
    data.size := 0;
    return data.buff;
  end read_buffer;

  function load_buffer (ls: state_ptr_t; str: ics.chars_ptr; size: ic.size_t; name: string) return error_t is
    cptr: aliased constant ics.chars_ptr := ics.new_string (name);
    rctx: aliased buffer_ctx := (str, size);
  begin
    return error_t'val (lua_load_buffer (ls, read_buffer'access, rctx'access, cptr));
  end load_buffer;
  
  function load_buffer (ls: state_ptr_t; str: string; size: natural; name: string) return error_t is
  begin
    return load_buffer (ls, ics.new_string (str), ic.size_t (size), name);
  end load_buffer;

  function load_buffer (ls: state_ptr_t; str: su.unbounded_string; name: string) return error_t is
  begin
    return load_buffer (ls, su.to_string (str), su.length (str), name);
  end load_buffer;

  function load_file (ls: state_ptr_t; file: string) return error_t is
    fd: ada.text_io.file_type;
    buf: string (1 .. 4096);
    len: natural;
    ubs: su.unbounded_string;
  begin
    io.open (fd, io.in_file, file);
    while not io.end_of_file (fd) loop
      io.get_line (fd, buf, len);
      su.append (ubs, buf (1 .. len) & ascii.lf);
    end loop;
    io.close (fd);
    return load_buffer (ls, ubs, file);
  end load_file;

  function load_string (ls: state_ptr_t; str: string) return error_t is
  begin
    return load_buffer (ls, str, str'last, "");
  end load_string;

  --
  -- execute functions
  --

  function exec_file (ls: state_ptr_t; file: string) return error_t is
    ec: error_t;
  begin
    ec := load_file (ls, file);
    if ec /= lua_error_none then return ec; end if;
    ec := error_t'val (lua_pcall (ls, 0, -1, 0));
    return ec;
  end exec_file;

  function exec_string (ls: state_ptr_t; str: string) return error_t is
    ec: error_t;
  begin
    ec := load_string (ls, str);
    if ec /= lua_error_none then return ec; end if;
    ec := error_t'val (lua_pcall (ls, 0, -1, 0));
    return ec;
  end exec_string;

  --
  -- Main API
  --

  procedure set_hook (ls: state_ptr_t; func: hook_t; amask: mask_t; count: integer) is
  begin
    lua_sethook (ls, func, int_t (amask), int_t (count));
  end set_hook;

  function get_hook_mask (ls: state_ptr_t) return mask_t is
  begin
    return mask_t (lua_gethookmask (ls));
  end get_hook_mask;

  procedure error (ls: state_ptr_t) is
  begin
    lua_error (ls);
  end error;

  --
  -- state manipulation
  --

  function open return state_ptr_t is
  begin
    return luaL_newstate;
  end open;

  procedure close (ls: state_ptr_t)  is
  begin
    lua_close (ls);
  end close;

  function new_thread (ls: state_ptr_t) return state_ptr_t is
  begin
    return lua_newthread (ls);
  end new_thread;

  function at_panic (ls: state_ptr_t; panic_function: user_func_t) return user_func_t is
  begin
    return lua_atpanic (ls, panic_function);
  end at_panic;

  --
  -- stack manipulation
  --

  function get_top (ls: state_ptr_t) return integer is
  begin
    return integer (lua_gettop (ls));
  end get_top;

  procedure set_top (ls: state_ptr_t; index: integer) is
  begin
    lua_settop (ls, int_t (index));
  end set_top;

  procedure push_value (ls: state_ptr_t; index: integer) is
  begin
    lua_pushvalue (ls, int_t (index));
  end push_value;

  procedure remove (ls: state_ptr_t; index: integer) is
  begin
    lua_remove (ls, int_t (index));
  end remove;

  procedure insert (ls: state_ptr_t; index: integer) is
  begin
    lua_insert (ls, int_t (index));
  end insert;

  procedure replace (ls: state_ptr_t; index: integer) is
  begin
    lua_replace (ls, int_t (index));
  end replace;

  function check_stack(ls: state_ptr_t; size: integer) return integer is
  begin
    return integer (lua_checkstack (ls, int_t (size)));
  end check_stack;

  --
  -- access functions (stack -> ada)
  --

  function is_number (ls: state_ptr_t; index: integer) return boolean is
  begin
    return lua_isnumber (ls, int_t (index)) /= 0;
  end is_number;

  function is_string (ls: state_ptr_t; index: integer) return boolean is
  begin
    return lua_isstring (ls, int_t (index)) /= 0;
  end is_string;

  function is_user_function (ls: state_ptr_t; index: integer) return boolean is
  begin
    return lua_iscfunction (ls, int_t (index)) /= 0;
  end is_user_function;

  function is_user_data (ls: state_ptr_t; index: integer) return boolean is
  begin
    return lua_isuserdata (ls, int_t (index)) /= 0;
  end is_user_data;

  function is_nil (ls: state_ptr_t; index: integer) return boolean is
  begin
    return lua_type (ls, int_t (index)) = 0;
  end is_nil;

  function type_of (ls: state_ptr_t; index: integer) return type_t is
    x: int_t;
  begin
    x := lua_type (ls, int_t (index));
    return type_t'val (x + 1);
  end type_of;

  function type_name (ls: state_ptr_t; index: integer) return string is
    t: constant int_t := lua_type (ls, int_t (index));
  begin
    return ics.value (lua_typename (ls, t));
  end type_name;

  function to_number (ls: state_ptr_t; index: integer) return number_t is
  begin
    return lua_tonumber (ls, int_t (index));
  end to_number;

  function to_string (ls: state_ptr_t; index: integer) return string is
    x: ics.chars_ptr;
    use ics;
  begin
    x := luext_tostring (ls, int_t (index));
    if x /= ics.null_ptr then return ics.value (x); else return ""; end if;
  end to_string;

  function to_boolean (ls: state_ptr_t; index: integer) return boolean is
  begin
    return lua_toboolean (ls, int_t (index)) /= 0;
  end to_boolean;

  function to_cfunction (ls: state_ptr_t; index: integer) return user_func_t is
  begin
    return lua_tocfunction (ls, int_t (index));
  end to_cfunction;

  function is_equal (ls: state_ptr_t; index1, index2: integer) return boolean is
  begin
    return lua_equal (ls, int_t (index1), int_t (index2)) /= 0;
  end is_equal;

  function is_raw_equal (ls: state_ptr_t; index1, index2: integer) return boolean is
  begin
    return lua_rawequal (ls, int_t (index1), int_t (index2)) /= 0;
  end is_raw_equal;

  function is_less_than (ls: state_ptr_t; index1, index2: integer) return boolean is
  begin
    return lua_lessthan (ls, int_t (index1), int_t (index2)) /= 0;
  end is_less_than;

  function objlen (ls: state_ptr_t; index: integer) return int_t is
  begin
    return lua_objlen (ls, int_t (index));
  end objlen;

  function strlen (ls: state_ptr_t; index: integer) return int_t is
  begin
    return lua_objlen (ls, int_t (index));
  end strlen;

  --
  -- push functions (ada -> stack)
  --

  procedure push_nil (ls: state_ptr_t) is
  begin
    lua_pushnil (ls);
  end push_nil;

  procedure push_number (ls: state_ptr_t; n: number_t) is
  begin
    lua_pushnumber (ls, n);
  end push_number;

  procedure push_boolean (ls: state_ptr_t; b: boolean) is
  begin
    if b then
      lua_pushboolean (ls, 1);
    else
      lua_pushboolean (ls, 0);
    end if;
  end push_boolean;

  procedure push_string (ls: state_ptr_t; str: ics.chars_ptr) is
  begin
    lua_pushstring (ls, str);
  end push_string;

  procedure push_string (ls: state_ptr_t; str: string) is
  begin
    if str'length > 0 then
      lua_pushlstring (ls, str (str'first)'address, str'length);
    else
      lua_pushlstring (ls, system.null_address, 0);
    end if;
  end push_string;

  procedure push_string (ls: state_ptr_t; str: su.unbounded_string) is
    x: ics.chars_ptr := ics.new_string (su.to_string (str));
  begin
    lua_pushstring (ls, x);
    ics.free (x);
  end push_string;

  procedure push_string (ls: state_ptr_t; address: system.address; amount: positive) is
  begin
    lua_pushlstring (ls, address, amount);
  end push_string;

  procedure push_user_closure (ls: state_ptr_t; func: user_func_t; num_params: integer) is
  begin
    lua_pushcclosure (ls, func, int_t (num_params));
  end push_user_closure;

  procedure push_user_function (ls: state_ptr_t; func: user_func_t) is
  begin
    lua_pushcclosure (ls, func, 0);
  end push_user_function;

  procedure concat (ls: state_ptr_t; n: natural) is
  begin
    lua_concat (ls, int_t (n));
  end concat;

  --
  -- get functions (lua -> stack)
  --

  procedure get_table (ls: state_ptr_t; index: integer) is
  begin
    lua_gettable (ls, int_t (index));
  end get_table;

  function get_metatable (ls: state_ptr_t; index: integer) return error_t is
  begin
    return error_t'val (lua_getmetatable (ls, int_t (index)));
  end get_metatable;

  procedure raw_get (ls: state_ptr_t; index: integer) is
  begin
    lua_rawget (ls, int_t (index));
  end raw_get;

  procedure raw_get_int (ls: state_ptr_t; index: integer; element: integer) is
  begin
    lua_rawgeti (ls, int_t (index), int_t (element));
  end raw_get_int;

  procedure get_field (ls: state_ptr_t; index: integer; str: ics.chars_ptr) is
  begin
    lua_getfield (ls, int_t (index), str);
  end get_field;

  procedure get_field (ls: state_ptr_t; index: integer; str: string) is
  begin
    lua_getfield (ls, int_t (index), ics.new_string (str));
  end get_field;

  procedure get_field (ls: state_ptr_t; index: integer; str: su.unbounded_string) is
  begin
    lua_getfield (ls, int_t (index), ics.new_string (su.to_string (str)));
  end get_field;
 
  procedure get_global (ls: state_ptr_t; str: ics.chars_ptr) is
  begin
    lua_getfield (ls, globalsindex, str);
  end get_global;

  procedure get_global (ls: state_ptr_t; str: string) is
  begin
    lua_getfield (ls, globalsindex, ics.new_string (str));
  end get_global;

  procedure get_global (ls: state_ptr_t; str: su.unbounded_string) is
  begin
    lua_getfield (ls, globalsindex, ics.new_string (su.to_string (str)));
  end get_global;

  procedure get_fenv (ls: state_ptr_t; index: integer) is
  begin
    lua_getfenv (ls, int_t (index));
  end get_fenv;

  --
  -- set functions (stack -> lua)
  --

  procedure set_table (ls: state_ptr_t; index: integer) is
  begin
    lua_settable (ls, int_t (index));
  end set_table;

  function set_metatable (ls: state_ptr_t; index: integer) return error_t is
  begin
    return error_t'val (lua_setmetatable (ls, int_t (index)));
  end set_metatable;

  procedure raw_set (ls: state_ptr_t; index: integer) is
  begin
    lua_rawset (ls, int_t (index));
  end raw_set;

  procedure new_table (ls: state_ptr_t) is
  begin
    lua_createtable (ls, 0, 0);
  end new_table;

  procedure raw_set_int (ls: state_ptr_t; index: integer; element: integer) is
  begin
    lua_rawseti (ls, int_t (index), int_t (element));
  end raw_set_int;

  procedure set_field (ls: state_ptr_t; index: integer; str: ics.chars_ptr) is
  begin
    lua_setfield (ls, int_t (index), str);
  end set_field;

  procedure set_field (ls: state_ptr_t; index: integer; str: string) is
  begin
    lua_setfield (ls, int_t (index), ics.new_string (str));
  end set_field;

  procedure set_field (ls: state_ptr_t; index: integer; str: su.unbounded_string) is
  begin
    lua_setfield (ls, int_t (index), ics.new_string (su.to_string (str)));
  end set_field;

  procedure set_global (ls: state_ptr_t; str: ics.chars_ptr) is
  begin
    lua_setfield (ls, globalsindex, str);
  end set_global;

  procedure set_global (ls: state_ptr_t; str: string) is
  begin
    lua_setfield (ls, globalsindex, ics.new_string (str));
  end set_global;

  procedure set_global (ls: state_ptr_t; str: su.unbounded_string) is
  begin
    lua_setfield (ls, globalsindex, ics.new_string (su.to_string (str)));
  end set_global;

  function set_fenv (ls: state_ptr_t; index: integer) return error_t is
  begin
    return error_t'val (lua_setfenv (ls, int_t (index)));
  end set_fenv;

  --
  -- coroutines
  --

  function lua_resume (ls: state_ptr_t; narg: int_t) return int_t;
  pragma import (c, lua_resume, "lua_resume");

  function ret_error (e: error_t; s: string) return error_msg_t is
    z: constant string := error_messages (e).all & s;
  begin
    return (z'length, e, z);
  end ret_error;

  function resume (ls: state_ptr_t; num_args: integer) return error_msg_t is
    error: error_t;
    ndx: constant int_t := lua_gettop (ls) - int_t (num_args);
  begin
    push_string (ls, "_traceback");
    lua_rawget (ls, globalsindex);
    lua_insert (ls, ndx);
    error := error_t'val (lua_resume (ls, int_t (num_args)));
    lua_remove (ls, ndx);
    if error /= lua_error_none then
      return ret_error (error, to_string (ls, -1));
    else
      return no_error;
    end if;
  exception
    when err: others =>
      return ret_error (lua_exception, "exception while doing lua.traced_call:"
        & ascii.lf & ascii.cr
        & ada.exceptions.exception_information (err));
  end resume;

  --
  -- misc
  --

  procedure register (ls: state_ptr_t; func_name: string; func_ptr: user_func_t) is
  begin
    push_string (ls, func_name);
    lua_pushcclosure (ls, func_ptr, 0);
    lua_settable (ls, globalsindex);
  end;

  procedure call (ls: state_ptr_t; num_arguments, num_results: integer) is
  begin
    lua_call (ls, int_t (num_arguments), int_t (num_results));
  end call;

  function pcall (ls: state_ptr_t; num_arguments, num_results, error_func: integer)
    return error_t is
  begin
    return error_t'val (lua_pcall (ls, lua.int_t (num_arguments),
      lua.int_t (num_results), lua.int_t (error_func)));
  end pcall;

  procedure pop (ls: state_ptr_t; count: integer) is
  begin
    set_top (ls, -(count) - 1);
  end pop;

  function next (ls: state_ptr_t; index: integer) return integer is
  begin
    return integer (lua_next (ls, int_t (index)));
  end next;

  function reference (ls: state_ptr_t) return obj_ref_t is
  begin
    return reference (ls, registry_index);
  end reference;

  procedure unreference (ls: state_ptr_t; ref: obj_ref_t) is
  begin
    unreference (ls, registry_index, ref);
  end unreference;

  procedure dereference (ls: state_ptr_t; ref: obj_ref_t) is
  begin
    raw_get_int (ls, registry_index, integer (ref));
  end dereference;

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
