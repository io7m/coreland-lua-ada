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

  procedure lua_close (state : state_ptr_t);
  pragma import (c, lua_close, "lua_close");

  function lua_newthread (state : state_ptr_t) return state_ptr_t;
  pragma import (c, lua_newthread, "lua_newthread");

  function lua_gettop (state : state_ptr_t) return int_t;
  pragma import (c, lua_gettop, "lua_gettop");

  procedure lua_settop (state : state_ptr_t; index : int_t);
  pragma import (c, lua_settop, "lua_settop");

  function lua_checkstack (state : state_ptr_t; extra : int_t) return int_t;
  pragma import (c, lua_checkstack, "lua_checkstack");

  procedure lua_pushvalue (state : state_ptr_t; index : int_t);
  pragma import (c, lua_pushvalue, "lua_pushvalue");

  procedure lua_remove (state : state_ptr_t; index : int_t);
  pragma import (c, lua_remove, "lua_remove");

  procedure lua_insert (state : state_ptr_t; index : int_t);
  pragma import (c, lua_insert, "lua_insert");

  procedure lua_replace (state : state_ptr_t; index : int_t);
  pragma import (c, lua_replace, "lua_replace");

  --
  -- access functions
  --

  function lua_typename (state : state_ptr_t; index : int_t) return ics.chars_ptr;
  pragma import (c, lua_typename, "lua_typename");

  function lua_type (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_type, "lua_type");

  function lua_isnumber (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_isnumber, "lua_isnumber");

  function lua_isstring (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_isstring, "lua_isstring");

  function lua_iscfunction (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_iscfunction, "lua_iscfunction");

  function lua_isuserdata (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_isuserdata, "lua_isuserdata");

  function lua_equal (state : state_ptr_t; index1, index2 : int_t) return int_t;
  pragma import (c, lua_equal, "lua_equal");

  function lua_rawequal (state : state_ptr_t; index1, index2 : int_t) return int_t;
  pragma import (c, lua_rawequal, "lua_rawequal");

  function lua_lessthan (state : state_ptr_t; index1, index2 : int_t) return int_t;
  pragma import (c, lua_lessthan, "lua_lessthan");

  function lua_toboolean (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_toboolean, "lua_toboolean");

  function lua_tonumber (state : state_ptr_t; index : int_t) return number_t;
  pragma import (c, lua_tonumber, "lua_tonumber");

  function luext_tostring (state : state_ptr_t; index : int_t) return ics.chars_ptr;
  pragma import (c, luext_tostring, "luext_tostring");

  function lua_objlen (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_objlen, "lua_objlen");

  function lua_tocfunction (state : state_ptr_t; index : int_t) return user_func_t;
  pragma import (c, lua_tocfunction, "lua_tocfunction");

  --
  -- push functions
  --

  procedure lua_pushboolean (state : state_ptr_t; b : int_t);
  pragma import (c, lua_pushboolean, "lua_pushboolean");

  procedure lua_pushnumber (state : state_ptr_t; n : number_t);
  pragma import (c, lua_pushnumber, "lua_pushnumber");

  procedure lua_pushstring (state : state_ptr_t; s : ics.chars_ptr);
  pragma import (c, lua_pushstring, "lua_pushstring");

  procedure lua_pushlstring (state : state_ptr_t; s : system.address; a : integer);
  pragma import (c, lua_pushlstring, "lua_pushlstring");

  procedure lua_pushnil (state : state_ptr_t);
  pragma import (c, lua_pushnil, "lua_pushnil");

  procedure lua_pushcclosure (state : in state_ptr_t; fn : in user_func_t; num : in int_t);
  pragma import (c, lua_pushcclosure, "lua_pushcclosure");

  procedure lua_concat (state : state_ptr_t; num : natural_t);
  pragma import (c, lua_concat, "lua_concat");

  function lua_next (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_next, "lua_next");

  --
  -- metatable functions
  --

  function lua_getmetatable (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_getmetatable, "lua_getmetatable");

  function lua_setmetatable (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_setmetatable, "lua_setmetatable");

  --
  -- environment functions
  --

  procedure lua_getfenv (state : state_ptr_t; index : int_t);
  pragma import (c, lua_getfenv, "lua_getfenv");

  function lua_setfenv (state : state_ptr_t; index : int_t) return int_t;
  pragma import (c, lua_setfenv, "lua_setfenv");

  --
  -- registered functions
  --

  procedure lua_call (state : in state_ptr_t; num_args : in int_t; num_results : in int_t);
  pragma import (c, lua_call, "lua_call");

  function lua_pcall (state : in state_ptr_t; num_args : in int_t; num_results : in int_t;
    error_f : in int_t) return int_t;
  pragma import (c, lua_pcall, "lua_pcall");

  --
  -- table functions
  --

  procedure lua_createtable (state : state_ptr_t; num_arr : int_t; num_rec : int_t);
  pragma import (c, lua_createtable, "lua_createtable");

  procedure lua_settable (state : state_ptr_t; index : int_t);
  pragma import (c, lua_settable, "lua_settable");

  procedure lua_gettable (state : state_ptr_t; index : int_t);
  pragma import (c, lua_gettable, "lua_gettable");

  procedure lua_rawget (state : state_ptr_t; index : int_t);
  pragma import (c, lua_rawget, "lua_rawget");

  procedure lua_rawset (state : state_ptr_t; index : int_t);
  pragma import (c, lua_rawset, "lua_rawset");

  procedure lua_rawgeti (state : state_ptr_t; index, element : int_t);
  pragma import (c, lua_rawgeti, "lua_rawgeti");

  procedure lua_rawseti (state : state_ptr_t; index, element : int_t);
  pragma import (c, lua_rawseti, "lua_rawseti");

  --
  -- errors
  --

  function lua_atpanic (state : state_ptr_t; func : user_func_t) return user_func_t;
  pragma import (c, lua_atpanic, "lua_atpanic");

  procedure lua_error (state : state_ptr_t);
  pragma import (c, lua_error, "lua_error");
  pragma no_return (lua_error);

  procedure lua_sethook (state : state_ptr_t; func : hook_t; amask, count : int_t);
  pragma import (c, lua_sethook, "lua_sethook");

  function lua_gethookmask (state : state_ptr_t) return int_t;
  pragma import (c, lua_gethookmask, "lua_gethookmask");

  --
  -- set functions
  --

  procedure lua_setfield (state : state_ptr_t; index : int_t; key : ics.chars_ptr);
  pragma import (c, lua_setfield, "lua_setfield");

  --
  -- get functions
  --

  procedure lua_getfield (state : state_ptr_t; index : int_t; key : ics.chars_ptr);
  pragma import (c, lua_getfield, "lua_getfield");

  --
  -- load functions
  --

  type buffer_ctx is record
    buff : ics.chars_ptr;
    size : ic.size_t;
  end record;
  pragma convention (c, buffer_ctx);

  type buffer_func is
    access function (state : state_ptr_t; data : access buffer_ctx; size : access ic.size_t)
      return ics.chars_ptr;
  pragma convention (c, buffer_func);

  function lua_load_buffer (state : state_ptr_t;
    func : buffer_func;
    data : access buffer_ctx;
    name : ics.chars_ptr) return int_t;
  pragma import (c, lua_load_buffer, "lua_load");

  -- buffer reader callback
  -- XXX : should be C calling convention

  function read_buffer
    (state : state_ptr_t;
     data  : access buffer_ctx;
     size  : access ic.size_t) return ics.chars_ptr;
  pragma convention (c, read_buffer);
 
  function read_buffer
    (state : state_ptr_t;
     data  : access buffer_ctx;
     size  : access ic.size_t) return ics.chars_ptr
  is
    use type ic.size_t;
    size_alias : constant access ic.size_t := size;
  begin
    if data.size = 0 then return ics.null_ptr; end if;
    size_alias.all := data.size;
    data.size := 0;
    return data.buff;
  end read_buffer;

  function load_buffer (state : state_ptr_t; str : ics.chars_ptr; size : ic.size_t; name : string) return error_t is
    ch_array : aliased ic.char_array := ic.to_c (name);
    rctx     : aliased buffer_ctx := (str, size);
  begin
    return error_t'val (lua_load_buffer (state, read_buffer'access, rctx'access, 
      ics.to_chars_ptr (ch_array'unchecked_access)));
  end load_buffer;
  
  function load_buffer (state : state_ptr_t; str : string; size : natural; name : string) return error_t is
    ch_array : aliased ic.char_array := ic.to_c (str);
  begin
    return load_buffer (state, ics.to_chars_ptr (ch_array'unchecked_access),
      ic.size_t (size), name);
  end load_buffer;

  function load_buffer (state : state_ptr_t; str : su.unbounded_string; name : string) return error_t is
  begin
    return load_buffer (state, su.to_string (str), su.length (str), name);
  end load_buffer;

  function load_file (state : state_ptr_t; file : string) return error_t is
    fd : ada.text_io.file_type;
    buf : string (1 .. 4096);
    len : natural;
    ubs : su.unbounded_string;
  begin
    io.open (fd, io.in_file, file);
    while not io.end_of_file (fd) loop
      io.get_line (fd, buf, len);
      su.append (ubs, buf (1 .. len) & ascii.lf);
    end loop;
    io.close (fd);
    return load_buffer (state, ubs, file);
  end load_file;

  function load_string (state : state_ptr_t; str : string) return error_t is
  begin
    return load_buffer (state, str, str'last, "");
  end load_string;

  --
  -- execute functions
  --

  function exec_file (state : state_ptr_t; file : string) return error_t is
    ec : error_t;
  begin
    ec := load_file (state, file);
    if ec /= lua_error_none then return ec; end if;
    ec := error_t'val (lua_pcall (state, 0, -1, 0));
    return ec;
  end exec_file;

  function exec_string (state : state_ptr_t; str : string) return error_t is
    ec : error_t;
  begin
    ec := load_string (state, str);
    if ec /= lua_error_none then return ec; end if;
    ec := error_t'val (lua_pcall (state, 0, -1, 0));
    return ec;
  end exec_string;

  --
  -- Main API
  --

  procedure set_hook (state : state_ptr_t; func : hook_t; amask : mask_t; count : integer) is
  begin
    lua_sethook (state, func, int_t (amask), int_t (count));
  end set_hook;

  function get_hook_mask (state : state_ptr_t) return mask_t is
  begin
    return mask_t (lua_gethookmask (state));
  end get_hook_mask;

  procedure error (state : state_ptr_t) is
  begin
    lua_error (state);
  end error;

  --
  -- state manipulation
  --

  function open return state_ptr_t is
  begin
    return luaL_newstate;
  end open;

  procedure close (state : state_ptr_t)  is
  begin
    lua_close (state);
  end close;

  function new_thread (state : state_ptr_t) return state_ptr_t is
  begin
    return lua_newthread (state);
  end new_thread;

  function at_panic (state : state_ptr_t; panic_function : user_func_t) return user_func_t is
  begin
    return lua_atpanic (state, panic_function);
  end at_panic;

  --
  -- stack manipulation
  --

  function get_top (state : state_ptr_t) return integer is
  begin
    return integer (lua_gettop (state));
  end get_top;

  procedure set_top (state : state_ptr_t; index : integer) is
  begin
    lua_settop (state, int_t (index));
  end set_top;

  procedure push_value (state : state_ptr_t; index : integer) is
  begin
    lua_pushvalue (state, int_t (index));
  end push_value;

  procedure remove (state : state_ptr_t; index : integer) is
  begin
    lua_remove (state, int_t (index));
  end remove;

  procedure insert (state : state_ptr_t; index : integer) is
  begin
    lua_insert (state, int_t (index));
  end insert;

  procedure replace (state : state_ptr_t; index : integer) is
  begin
    lua_replace (state, int_t (index));
  end replace;

  function check_stack(state : state_ptr_t; size : integer) return integer is
  begin
    return integer (lua_checkstack (state, int_t (size)));
  end check_stack;

  --
  -- access functions (stack -> ada)
  --

  function is_number (state : state_ptr_t; index : integer) return boolean is
  begin
    return lua_isnumber (state, int_t (index)) /= 0;
  end is_number;

  function is_string (state : state_ptr_t; index : integer) return boolean is
  begin
    return lua_isstring (state, int_t (index)) /= 0;
  end is_string;

  function is_user_function (state : state_ptr_t; index : integer) return boolean is
  begin
    return lua_iscfunction (state, int_t (index)) /= 0;
  end is_user_function;

  function is_user_data (state : state_ptr_t; index : integer) return boolean is
  begin
    return lua_isuserdata (state, int_t (index)) /= 0;
  end is_user_data;

  function is_nil (state : state_ptr_t; index : integer) return boolean is
  begin
    return lua_type (state, int_t (index)) = 0;
  end is_nil;

  function type_of (state : state_ptr_t; index : integer) return type_t is
    x : int_t;
  begin
    x := lua_type (state, int_t (index));
    return type_t'val (x + 1);
  end type_of;

  function type_name (state : state_ptr_t; index : integer) return string is
    t : constant int_t := lua_type (state, int_t (index));
  begin
    return ics.value (lua_typename (state, t));
  end type_name;

  function type_name (t : lua.type_t) return string is
  begin
    case t is
      when t_none => return "none";
      when t_nil => return "nil";
      when t_boolean => return "boolean";
      when t_lightuserdata => return "light_userdata";
      when t_number => return "number";
      when t_string => return "string";
      when t_table => return "table";
      when t_function => return "function";
      when t_userdata => return "userdata";
      when t_thread => return "thread";
    end case;
  end type_name;

  function to_number (state : state_ptr_t; index : integer) return number_t is
  begin
    return lua_tonumber (state, int_t (index));
  end to_number;

  function to_string (state : state_ptr_t; index : integer) return string is
    x : ics.chars_ptr;
    use ics;
  begin
    x := luext_tostring (state, int_t (index));
    if x /= ics.null_ptr then return ics.value (x); else return ""; end if;
  end to_string;

  function to_boolean (state : state_ptr_t; index : integer) return boolean is
  begin
    return lua_toboolean (state, int_t (index)) /= 0;
  end to_boolean;

  function to_cfunction (state : state_ptr_t; index : integer) return user_func_t is
  begin
    return lua_tocfunction (state, int_t (index));
  end to_cfunction;

  function is_equal (state : state_ptr_t; index1, index2 : integer) return boolean is
  begin
    return lua_equal (state, int_t (index1), int_t (index2)) /= 0;
  end is_equal;

  function is_raw_equal (state : state_ptr_t; index1, index2 : integer) return boolean is
  begin
    return lua_rawequal (state, int_t (index1), int_t (index2)) /= 0;
  end is_raw_equal;

  function is_less_than (state : state_ptr_t; index1, index2 : integer) return boolean is
  begin
    return lua_lessthan (state, int_t (index1), int_t (index2)) /= 0;
  end is_less_than;

  function objlen (state : state_ptr_t; index : integer) return int_t is
  begin
    return lua_objlen (state, int_t (index));
  end objlen;

  function strlen (state : state_ptr_t; index : integer) return int_t is
  begin
    return lua_objlen (state, int_t (index));
  end strlen;

  --
  -- push functions (ada -> stack)
  --

  procedure push_nil (state : state_ptr_t) is
  begin
    lua_pushnil (state);
  end push_nil;

  procedure push_number (state : state_ptr_t; n : number_t) is
  begin
    lua_pushnumber (state, n);
  end push_number;

  procedure push_boolean (state : state_ptr_t; b : boolean) is
  begin
    if b then
      lua_pushboolean (state, 1);
    else
      lua_pushboolean (state, 0);
    end if;
  end push_boolean;

  procedure push_string (state : state_ptr_t; str : ics.chars_ptr) is
  begin
    lua_pushstring (state, str);
  end push_string;

  procedure push_string (state : state_ptr_t; str : string) is
  begin
    if str'length > 0 then
      lua_pushlstring (state, str (str'first)'address, str'length);
    else
      lua_pushlstring (state, system.null_address, 0);
    end if;
  end push_string;

  procedure push_string (state : state_ptr_t; str : su.unbounded_string) is
    ch_array : aliased ic.char_array := ic.to_c (su.to_string (str));
  begin
    lua_pushstring (state, ics.to_chars_ptr (ch_array'unchecked_access));
  end push_string;

  procedure push_string (state : state_ptr_t; address : system.address; amount : positive) is
  begin
    lua_pushlstring (state, address, amount);
  end push_string;

  procedure push_user_closure (state : state_ptr_t; func : user_func_t; num_params : integer) is
  begin
    lua_pushcclosure (state, func, int_t (num_params));
  end push_user_closure;

  procedure push_user_function (state : state_ptr_t; func : user_func_t) is
  begin
    lua_pushcclosure (state, func, 0);
  end push_user_function;

  procedure concat (state : state_ptr_t; n : natural) is
  begin
    lua_concat (state, int_t (n));
  end concat;

  --
  -- get functions (lua -> stack)
  --

  procedure get_table (state : state_ptr_t; index : integer) is
  begin
    lua_gettable (state, int_t (index));
  end get_table;

  function get_metatable (state : state_ptr_t; index : integer) return error_t is
  begin
    return error_t'val (lua_getmetatable (state, int_t (index)));
  end get_metatable;

  procedure raw_get (state : state_ptr_t; index : integer) is
  begin
    lua_rawget (state, int_t (index));
  end raw_get;

  procedure raw_get_int (state : state_ptr_t; index : integer; element : integer) is
  begin
    lua_rawgeti (state, int_t (index), int_t (element));
  end raw_get_int;

  procedure get_field (state : state_ptr_t; index : integer; str : ics.chars_ptr) is
  begin
    lua_getfield (state, int_t (index), str);
  end get_field;

  procedure get_field (state : state_ptr_t; index : integer; str : string) is
    ch_array : aliased ic.char_array := ic.to_c (str);
  begin
    lua_getfield (state, int_t (index), ics.to_chars_ptr (ch_array'unchecked_access));
  end get_field;

  procedure get_field (state : state_ptr_t; index : integer; str : su.unbounded_string) is
    ch_array : aliased ic.char_array := ic.to_c (su.to_string (str));
  begin
    lua_getfield (state, int_t (index), ics.to_chars_ptr (ch_array'unchecked_access));
  end get_field;
 
  procedure get_global (state : state_ptr_t; str : ics.chars_ptr) is
  begin
    lua_getfield (state, globalsindex, str);
  end get_global;

  procedure get_global (state : state_ptr_t; str : string) is
    ch_array : aliased ic.char_array := ic.to_c (str);
  begin
    lua_getfield (state, globalsindex, ics.to_chars_ptr (ch_array'unchecked_access));
  end get_global;

  procedure get_global (state : state_ptr_t; str : su.unbounded_string) is
    ch_array : aliased ic.char_array := ic.to_c (su.to_string (str));
  begin
    lua_getfield (state, globalsindex, ics.to_chars_ptr (ch_array'unchecked_access));
  end get_global;

  procedure get_fenv (state : state_ptr_t; index : integer) is
  begin
    lua_getfenv (state, int_t (index));
  end get_fenv;

  --
  -- set functions (stack -> lua)
  --

  procedure set_table (state : state_ptr_t; index : integer) is
  begin
    lua_settable (state, int_t (index));
  end set_table;

  function set_metatable (state : state_ptr_t; index : integer) return error_t is
  begin
    return error_t'val (lua_setmetatable (state, int_t (index)));
  end set_metatable;

  procedure raw_set (state : state_ptr_t; index : integer) is
  begin
    lua_rawset (state, int_t (index));
  end raw_set;

  procedure new_table (state : state_ptr_t) is
  begin
    lua_createtable (state, 0, 0);
  end new_table;

  procedure raw_set_int (state : state_ptr_t; index : integer; element : integer) is
  begin
    lua_rawseti (state, int_t (index), int_t (element));
  end raw_set_int;

  procedure set_field (state : state_ptr_t; index : integer; str : ics.chars_ptr) is
  begin
    lua_setfield (state, int_t (index), str);
  end set_field;

  procedure set_field (state : state_ptr_t; index : integer; str : string) is
    ch_array : aliased ic.char_array := ic.to_c (str);
  begin
    lua_setfield (state, int_t (index), ics.to_chars_ptr (ch_array'unchecked_access));
  end set_field;

  procedure set_field (state : state_ptr_t; index : integer; str : su.unbounded_string) is
    ch_array : aliased ic.char_array := ic.to_c (su.to_string (str));
  begin
    lua_setfield (state, int_t (index), ics.to_chars_ptr (ch_array'unchecked_access));
  end set_field;

  procedure set_global (state : state_ptr_t; str : ics.chars_ptr) is
  begin
    lua_setfield (state, globalsindex, str);
  end set_global;

  procedure set_global (state : state_ptr_t; str : string) is
    ch_array : aliased ic.char_array := ic.to_c (str);
  begin
    lua_setfield (state, globalsindex, ics.to_chars_ptr (ch_array'unchecked_access));
  end set_global;

  procedure set_global (state : state_ptr_t; str : su.unbounded_string) is
    ch_array : aliased ic.char_array := ic.to_c (su.to_string (str));
  begin
    lua_setfield (state, globalsindex, ics.to_chars_ptr (ch_array'unchecked_access));
  end set_global;

  function set_fenv (state : state_ptr_t; index : integer) return error_t is
  begin
    return error_t'val (lua_setfenv (state, int_t (index)));
  end set_fenv;

  --
  -- coroutines
  --

  function lua_resume (state : state_ptr_t; narg : int_t) return int_t;
  pragma import (c, lua_resume, "lua_resume");

  function ret_error (e : error_t; s : string) return error_msg_t is
    z : constant string := error_messages (e).all & s;
  begin
    return (z'length, e, z);
  end ret_error;

  function resume (state : state_ptr_t; num_args : integer) return error_msg_t is
    error : error_t;
    ndx : constant int_t := lua_gettop (state) - int_t (num_args);
  begin
    push_string (state, "_traceback");
    lua_rawget (state, globalsindex);
    lua_insert (state, ndx);
    error := error_t'val (lua_resume (state, int_t (num_args)));
    lua_remove (state, ndx);
    if error /= lua_error_none then
      return ret_error (error, to_string (state, -1));
    else
      return no_error;
    end if;
  exception
    when err : others =>
      return ret_error (lua_exception, "exception while doing lua.traced_call:"
        & ascii.lf & ascii.cr
        & ada.exceptions.exception_information (err));
  end resume;

  --
  -- misc
  --

  procedure register (state : state_ptr_t; func_name : string; func_ptr : user_func_t) is
  begin
    push_string (state, func_name);
    lua_pushcclosure (state, func_ptr, 0);
    lua_settable (state, globalsindex);
  end;

  procedure call (state : state_ptr_t; num_arguments, num_results : integer) is
  begin
    lua_call (state, int_t (num_arguments), int_t (num_results));
  end call;

  function pcall (state : state_ptr_t; num_arguments, num_results, error_func : integer)
    return error_t is
  begin
    return error_t'val (lua_pcall (state, lua.int_t (num_arguments),
      lua.int_t (num_results), lua.int_t (error_func)));
  end pcall;

  procedure pop (state : state_ptr_t; count : integer) is
  begin
    set_top (state, -(count) - 1);
  end pop;

  function next (state : state_ptr_t; index : integer) return integer is
  begin
    return integer (lua_next (state, int_t (index)));
  end next;

  function reference (state : state_ptr_t) return obj_ref_t is
  begin
    return reference (state, registry_index);
  end reference;

  procedure unreference (state : state_ptr_t; ref : obj_ref_t) is
  begin
    unreference (state, registry_index, ref);
  end unreference;

  procedure dereference (state : state_ptr_t; ref : obj_ref_t) is
  begin
    raw_get_int (state, registry_index, integer (ref));
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
