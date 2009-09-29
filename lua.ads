-- Lua API

with Interfaces.C;
with Interfaces.C.Strings;
with System;
with Ada.Strings.Unbounded;

package Lua is
  package IC renames Interfaces.C;
  package ICS renames Interfaces.C.Strings;
  package UB_Strings renames Ada.Strings.Unbounded;

  use type ICS.chars_ptr;
  use type IC.int;

  --
  -- These types must match the integer types defined in your
  -- Lua implementation.
  --

  type    Integer_t is new IC.int;
  subtype Natural_t is Integer_t range 0 .. Integer_t'Last;
  subtype Number_t  is IC.double;

  type Error_t is
   (Lua_Error_None,
    Lua_Error_Runtime,
    Lua_Error_File,
    Lua_Error_Syntax,
    Lua_Error_Memory,
    Lua_Error_Error,
    Lua_Exception);

  for Error_t use
   (Lua_Error_None    => 0,
    Lua_Error_Runtime => 1,
    Lua_Error_File    => 2,
    Lua_Error_Syntax  => 3,
    Lua_Error_Memory  => 4,
    Lua_Error_Error   => 5,
    Lua_Exception     => 6);

  type Error_Message_t (Length : Natural) is record
    Code    : Error_t;
    Message : String (1 .. Length);
  end record;

  No_Error : constant Error_Message_t :=
    (Length  => 0,
     Code    => Lua_Error_None,
     Message => "");

  type State_t is private;
  type Debug_t is private;
  type Object_Ref_t is new Integer;

  type User_Function_t is access function (State : State_t) return Integer_t;
  pragma Convention (C, User_Function_t);

  type Hook_t is access procedure
    (State : State_t;
     Debug : Debug_t);
  pragma Convention (C, Hook_t);

  type Chunk_Reader_t is access function
   (State : State_t;
    Data  : System.Address;
    Size  : access IC.size_t)
  return    System.Address;
  pragma Convention (C, Chunk_Reader_t);

  type Chunk_Writer_t is access function
   (State : State_t;
    P     : System.Address;
    Size  : IC.size_t;
    Data  : System.Address)
  return    Integer_t;
  pragma Convention (C, Chunk_Writer_t);

  type Type_t is
   (T_None,
    T_Nil,
    T_Boolean,
    T_Light_Userdata,
    T_Number,
    T_String,
    T_Table,
    T_Function,
    T_Userdata,
    T_Thread);

  type Mask_t is mod 16;

  --
  -- Constants
  --

  Mask_None   : constant := 2#0000_0000#;
  Mask_Call   : constant := 2#0000_0001#;
  Mask_Return : constant := 2#0000_0010#;
  Mask_Line   : constant := 2#0000_0100#;
  Mask_Count  : constant := 2#0000_1000#;

  Nil_Reference : constant := -1;
  No_Reference  : constant := -2;

  State_Error : constant State_t;

  Registry_Index : constant := -10000;
  Environ_Index  : constant := -10001;
  Globals_Index  : constant := -10002;
  Multi_Return   : constant := -1;

  --
  -- API
  --

  -- State manipulation

  -- proc_map : luaL_newstate
  function Open return State_t;

  -- proc_map : lua_close
  procedure Close (State : State_t);

  -- proc_map : lua_atpanic
  function At_Panic
    (State          : State_t;
     Panic_Function : User_Function_t) return User_Function_t;

  -- proc_map : lua_atpanic
  procedure At_Panic
    (State          : State_t;
     Panic_Function : User_Function_t);

  -- Stack manipulation

  -- proc_map : lua_gettop
  function Get_Top (State : State_t) return Integer;

  -- proc_map : lua_settop
  procedure Set_Top
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_pushvalue
  procedure Push_Value
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_remove
  procedure Remove
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_insert
  procedure Insert
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_replace
  procedure Replace
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_checkstack
  function Check_Stack
    (State : State_t;
     Size  : Integer) return Boolean;

  -- Check functions (stack -> ada)

  -- proc_map : lua_isnumber
  function Is_Number
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isstring
  function Is_String
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_iscfunction
  function Is_User_Function
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isuserdata
  function Is_Userdata
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isnil
  function Is_Nil
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_istable
  function Is_Table
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isboolean
  function Is_Boolean
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isfunction
  function Is_Function
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isthread
  function Is_Thread
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isnone
  function Is_None
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_isnoneornil
  function Is_None_Or_Nil
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_islightuserdata
  function Is_Light_Userdata
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_equal
  function Is_Equal
    (State  : State_t;
     Index1 : Integer;
     Index2 : Integer) return Boolean;

  -- proc_map : lua_rawequal
  function Is_Raw_Equal
    (State  : State_t;
     Index1 : Integer;
     Index2 : Integer) return Boolean;

  -- proc_map : lua_lessthan
  function Is_Less_Than
   (State  : State_t;
    Index1 : Integer;
    Index2 : Integer) return Boolean;

  -- proc_map : lua_type
  function Type_Of
    (State : State_t;
     Index : Integer) return Type_t;

  -- proc_map : lua_typename
  function Type_Name
    (State : State_t;
     Index : Integer) return String;

  -- proc_map : lua_typename
  function Type_Name
    (T : Lua.Type_t) return String;

  -- proc_map : lua_tonumber
  function To_Number
    (State : State_t;
     Index : Integer) return Number_t;

  -- proc_map : lua_tointeger
  function To_Integer
    (State : State_t;
     Index : Integer) return Integer_t;

  -- proc_map : lua_tothread
  function To_Thread
    (State : State_t;
     Index : Integer) return State_t;

  -- proc_map : lua_tostring
  function To_String
    (State : State_t;
     Index : Integer) return String;

  -- proc_map : lua_tostring
  function To_Unbounded_String
    (State : State_t;
     Index : Integer) return UB_Strings.Unbounded_String;

  -- proc_map : lua_toboolean
  function To_Boolean
    (State : State_t;
     Index : Integer) return Boolean;

  -- proc_map : lua_tocfunction
  function To_C_Function
    (State : State_t;
     Index : Integer) return User_Function_t;

  -- proc_map : lua_objlen
  function Object_Length
    (State : State_t;
     Index : Integer) return Integer_t;

  -- Push functions (ada -> stack)

  -- proc_map : lua_pushnil
  procedure Push_Nil (State : State_t);

  -- proc_map : lua_pushnumber
  procedure Push_Number
    (State : State_t;
     N     : Number_t);

  -- proc_map : lua_pushinteger
  procedure Push_Integer
    (State : State_t;
     I     : Integer_t);

  -- proc_map : lua_pushboolean
  procedure Push_Boolean
    (State : State_t;
     B     : Boolean);

  -- proc_map : lua_pushstring
  procedure Push_String
    (State : State_t;
     Str   : ICS.chars_ptr);

  -- proc_map : lua_pushlstring
  procedure Push_String
    (State : State_t;
     Str   : String);

  -- proc_map : lua_pushstring
  procedure Push_String
    (State : State_t;
     Str   : UB_Strings.Unbounded_String);

  -- proc_map : lua_pushlstring
  procedure Push_String
    (State   : State_t;
     Address : System.Address;
     Size    : Positive);

  -- proc_map : lua_pushclosure
  procedure Push_User_Closure
    (State      : State_t;
     Func       : User_Function_t;
     Num_Params : Integer);

  -- proc_map : lua_pushclosure
  procedure Push_User_Function
    (State : State_t;
     Func  : User_Function_t);

  -- New functions

  -- proc_map : lua_createtable
  procedure Create_Table
    (State              : State_t;
     Array_Elements     : in Natural;
     Non_Array_Elements : in Natural);

  -- proc_map : lua_newtable
  procedure New_Table (State : State_t);

  -- proc_map : lua_newthread
  function New_Thread (State : State_t) return State_t;

  -- Get functions (lua -> stack)

  -- proc_map : lua_gettable
  procedure Get_Table
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_getmetatable
  function Get_Metatable
    (State : State_t;
     Index : Integer) return Error_t;

  -- proc_map : lua_rawget
  procedure Raw_Get
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_rawgeti
  procedure Raw_Get_Index
    (State   : State_t;
     Index   : Integer;
     Element : Integer);

  -- proc_map : lua_getfield
  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : ICS.chars_ptr);

  -- proc_map : lua_getfield
  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : String);

  -- proc_map : lua_getfield
  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : UB_Strings.Unbounded_String);

  -- proc_map : lua_getfield
  procedure Get_Global
    (State : State_t;
     Key   : ICS.chars_ptr);

  -- proc_map : lua_getfield
  procedure Get_Global
    (State : State_t;
     Key   : String);

  -- proc_map : lua_getfield
  procedure Get_Global
    (State : State_t;
     Key   : UB_Strings.Unbounded_String);

  -- proc_map : lua_getfenv
  procedure Get_FEnv
    (State : State_t;
     Index : Integer);

  -- Set functions (stack -> lua)

  -- proc_map : lua_settable
  procedure Set_Table
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_setmetatable
  function Set_Metatable
    (State : State_t;
     Index : Integer) return Error_t;

  -- proc_map : lua_rawset
  procedure Raw_Set
    (State : State_t;
     Index : Integer);

  -- proc_map : lua_rawseti
  procedure Raw_Set_Index
    (State   : State_t;
     Index   : Integer;
     Element : Integer);

  -- proc_map : lua_setfield
  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : ICS.chars_ptr);

  -- proc_map : lua_setfield
  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : String);

  -- proc_map : lua_setfield
  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : UB_Strings.Unbounded_String);

  -- proc_map : lua_setfield
  procedure Set_Global
    (State : State_t;
     Key   : ICS.chars_ptr);

  -- proc_map : lua_setfield
  procedure Set_Global
    (State : State_t;
     Key   : String);

  -- proc_map : lua_setfield
  procedure Set_Global
    (State : State_t;
     Key   : UB_Strings.Unbounded_String);

  -- proc_map : lua_setfenv
  function Set_FEnv
    (State : State_t;
     Index : Integer) return Error_t;

  -- Load functions

  -- proc_map : lua_load
  function Load_Buffer
   (State  : State_t;
    Buffer : ICS.chars_ptr;
    Size   : IC.size_t;
    Name   : String) return Error_t;

  -- proc_map : lua_load
  function Load_Buffer
   (State  : State_t;
    Buffer : String;
    Size   : Natural;
    Name   : String) return Error_t;

  -- proc_map : lua_load
  function Load_Buffer
   (State  : State_t;
    Buffer : UB_Strings.Unbounded_String;
    Name   : String) return Error_t;

  -- proc_map : lua_load
  function Load_File
    (State : State_t;
     File  : String) return Error_t;

  -- proc_map : lua_load
  function Load_String
    (State  : State_t;
     Buffer : String) return Error_t;

  -- Execute functions

  function Exec_File
    (State : State_t;
     File  : String) return Error_t;

  function Exec_String
    (State : State_t;
     Str   : String) return Error_t;

  -- Coroutines

  -- proc_map : lua_resume
  function Resume
    (State         : State_t;
     Num_Arguments : Integer) return Error_Message_t;

  -- proc_map : lua_yield
  function Yield
    (State       : State_t;
     Num_Results : Integer_t) return Integer_t;
  pragma Import (C, Yield, "lua_yield");

  -- Misc

  -- proc_map : lua_concat
  procedure Concat
    (State : State_t;
     N     : Natural);

  procedure Register
    (State     : State_t;
     Func_Name : String;
     Func_Ptr  : User_Function_t);

  -- proc_map : lua_pop
  procedure Pop
    (State : State_t;
     Count : Integer);

  -- proc_map : lua_next
  function Next
    (State : State_t;
     Index : Integer) return Integer;

  -- proc_map : luaL_ref
  function Reference
    (State : State_t;
     Index : Integer) return Object_Ref_t;
  pragma Import (C, Reference, "luaL_ref");

  -- proc_map : luaL_unref
  procedure Unreference
    (State : State_t;
     Index : Integer;
     Ref   : Object_Ref_t);
  pragma Import (C, Unreference, "luaL_unref");

  function Reference (State : State_t) return Object_Ref_t;

  procedure Unreference (State : State_t; Ref : Object_Ref_t);

  procedure Dereference (State : State_t; Ref : Object_Ref_t);

  -- Lua calls

  -- proc_map : lua_call
  procedure Call
    (State         : State_t;
     Num_Arguments : Integer;
     Num_Results   : Integer);

  -- proc_map : lua_pcall
  function PCall
   (State         : State_t;
    Num_Arguments : Integer;
    Num_Results   : Integer;
    Error_Func    : Integer) return Error_t;

  function Protected_Call
   (State         : State_t;
    Num_Arguments : Integer;
    Num_Results   : Integer;
    Error_Func    : Integer) return Error_t renames PCall;

  -- proc_map : lua_error
  procedure Error (State : State_t);
  pragma No_Return (Error);

  -- Versioning

  function Version return String;
  function Release return String;
  function Version return Integer;

  -- Debug hooks

  -- proc_map : lua_sethook
  procedure Set_Hook
   (State : State_t;
    Func  : Hook_t;
    AMask : Mask_t;
    Count : Integer);

  -- proc_map : lua_gethookmask
  function Get_Hook_Mask (State : State_t) return Mask_t;

  -- proc_map : lua_gethookcount
  function Get_Hook_Count (State : State_t) return Natural;

  -- Generic typed loading.

  generic
    type User_Data is limited private;

  function Load_Typed
    (State      : State_t;
     Reader     : Chunk_Reader_t;
     Data       : access User_Data;
     Chunk_Name : String) return Error_t;

private

  type State_t is new System.Address;
  type Debug_t is new System.Address;

  State_Error   : constant State_t := State_t (System.Null_Address);
  Str_Traceback : constant ICS.chars_ptr := ICS.New_String ("_traceback");

  Msg_Error_None    : aliased constant String := "";
  Msg_Error_Syntax  : aliased constant String := "syntax error: ";
  Msg_Error_Runtime : aliased constant String := "runtime error: ";
  Msg_Error_Memory  : aliased constant String := "memory error: ";
  Msg_Error_Error   : aliased constant String := "error-handling error: ";
  Msg_Error_File    : aliased constant String := "file error: ";

  type Str_Access_t is access constant String;
  type Str_Access_Array_t is array (Error_t) of Str_Access_t;

  Error_Messages : Str_Access_Array_t :=
   (Lua_Error_None    => Msg_Error_None'Access,
    Lua_Error_Runtime => Msg_Error_Runtime'Access,
    Lua_Error_Memory  => Msg_Error_Memory'Access,
    Lua_Error_File    => Msg_Error_File'Access,
    Lua_Error_Syntax  => Msg_Error_Syntax'Access,
    Lua_Error_Error   => Msg_Error_Error'Access,
    Lua_Exception     => Msg_Error_None'Access);

end Lua;
