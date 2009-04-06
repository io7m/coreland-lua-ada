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

  type Integer_t is new IC.int;
  subtype Natural_t is Integer_t range 0 .. Integer_t'Last;
  subtype Number_t is IC.double;

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

  function Open return State_t;

  procedure Close (State : State_t);

  function At_Panic
    (State          : State_t;
     Panic_Function : User_Function_t) return User_Function_t;

  procedure At_Panic
    (State          : State_t;
     Panic_Function : User_Function_t);

  -- Stack manipulation

  function Get_Top (State : State_t) return Integer;

  procedure Set_Top
    (State : State_t;
     Index : Integer);

  procedure Push_Value
    (State : State_t;
     Index : Integer);

  procedure Remove
    (State : State_t;
     Index : Integer);

  procedure Insert
    (State : State_t;
     Index : Integer);

  procedure Replace
    (State : State_t;
     Index : Integer);

  function Check_Stack
    (State : State_t;
     Size  : Integer) return Boolean;

  -- Check functions (stack -> ada)

  function Is_Number
    (State : State_t;
     Index : Integer) return Boolean;

  function Is_String
    (State : State_t;
     Index : Integer) return Boolean;

  function Is_User_Function
    (State : State_t;
     Index : Integer) return Boolean;

  function Is_Userdata
    (State : State_t;
     Index : Integer) return Boolean;

  function Is_Nil
    (State : State_t;
     Index : Integer) return Boolean;

  function Is_Equal
    (State  : State_t;
     Index1 : Integer;
     Index2 : Integer) return Boolean;

  function Is_Raw_Equal
    (State  : State_t;
     Index1 : Integer;
     Index2 : Integer) return Boolean;

  function Is_Less_Than
   (State  : State_t;
    Index1 : Integer;
    Index2 : Integer) return Boolean;

  function Type_Of
    (State : State_t;
     Index : Integer) return Type_t;

  function Type_Name
    (State : State_t;
     Index : Integer) return String;

  function Type_Name
    (T : Lua.Type_t) return String;

  function To_Number
    (State : State_t;
     Index : Integer) return Number_t;

  function To_String
    (State : State_t;
     Index : Integer) return String;

  function To_Boolean
    (State : State_t;
     Index : Integer) return Boolean;

  function To_C_Function
    (State : State_t;
     Index : Integer) return User_Function_t;

  function Object_Length
    (State : State_t;
     Index : Integer) return Integer_t;

  function String_Length
    (State : State_t;
     Index : Integer) return Integer_t;

  -- Push functions (ada -> stack)

  procedure Push_Nil (State : State_t);

  procedure Push_Number
    (State : State_t;
     N     : Number_t);

  procedure Push_Boolean
    (State : State_t;
     B     : Boolean);

  procedure Push_String
    (State : State_t;
     Str   : ICS.chars_ptr);

  procedure Push_String
    (State : State_t;
     Str   : String);

  procedure Push_String
    (State : State_t;
     Str   : UB_Strings.Unbounded_String);

  procedure Push_String
    (State   : State_t;
     Address : System.Address;
     Size    : Positive);

  procedure Push_User_Closure
    (State      : State_t;
     Func       : User_Function_t;
     Num_Params : Integer);

  procedure Push_User_Function
    (State : State_t;
     Func  : User_Function_t);

  -- New functions

  procedure New_Table (State : State_t);

  function New_Thread (State : State_t) return State_t;

  -- Get functions (lua -> stack)

  procedure Get_Table
    (State : State_t;
     Index : Integer);

  function Get_Metatable
    (State : State_t;
     Index : Integer) return Error_t;

  procedure Raw_Get
    (State : State_t;
     Index : Integer);

  procedure Raw_Get_Index
    (State   : State_t;
     Index   : Integer;
     Element : Integer);

  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : ICS.chars_ptr);

  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : String);

  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : UB_Strings.Unbounded_String);

  procedure Get_Global
    (State : State_t;
     Key   : ICS.chars_ptr);

  procedure Get_Global
    (State : State_t;
     Key   : String);

  procedure Get_Global
    (State : State_t;
     Key   : UB_Strings.Unbounded_String);

  procedure Get_FEnv
    (State : State_t;
     Index : Integer);

  -- Set functions (stack -> lua)

  procedure Set_Table
    (State : State_t;
     Index : Integer);

  function Set_Metatable
    (State : State_t;
     Index : Integer) return Error_t;

  procedure Raw_Set
    (State : State_t;
     Index : Integer);

  procedure Raw_Set_Index
    (State   : State_t;
     Index   : Integer;
     Element : Integer);

  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : ICS.chars_ptr);

  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : String);

  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : UB_Strings.Unbounded_String);

  procedure Set_Global
    (State : State_t;
     Key   : ICS.chars_ptr);

  procedure Set_Global
    (State : State_t;
     Key   : String);

  procedure Set_Global
    (State : State_t;
     Key   : UB_Strings.Unbounded_String);

  function Set_FEnv
    (State : State_t;
     Index : Integer) return Error_t;

  -- Load functions

  function Load_Buffer
   (State  : State_t;
    Buffer : ICS.chars_ptr;
    Size   : IC.size_t;
    Name   : String) return Error_t;

  function Load_Buffer
   (State  : State_t;
    Buffer : String;
    Size   : Natural;
    Name   : String) return Error_t;

  function Load_Buffer
   (State  : State_t;
    Buffer : UB_Strings.Unbounded_String;
    Name   : String) return Error_t;

  function Load_File
    (State : State_t;
     File  : String) return Error_t;

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

  function Resume
    (State         : State_t;
     Num_Arguments : Integer) return Error_Message_t;

  function Yield
    (State       : State_t;
     Num_Results : Integer_t) return Integer_t;
  pragma Import (C, Yield, "lua_yield");

  -- Misc

  procedure Concat
    (State : State_t;
     N     : Natural);

  procedure Register
    (State     : State_t;
     Func_Name : String;
     Func_Ptr  : User_Function_t);

  procedure Pop
    (State : State_t;
     Count : Integer);

  function Next
    (State : State_t;
     Index : Integer) return Integer;

  function Reference
    (State : State_t;
     Table : Integer) return Object_Ref_t;
  pragma Import (C, Reference, "luaL_ref");

  procedure Unreference
    (State : State_t;
     Table : Integer;
     Ref   : Object_Ref_t);
  pragma Import (C, Unreference, "luaL_unref");

  function Reference (State : State_t) return Object_Ref_t;

  procedure Unreference (State : State_t; Ref : Object_Ref_t);

  procedure Dereference (State : State_t; Ref : Object_Ref_t);

  -- Lua calls

  procedure Call
    (State         : State_t;
     Num_Arguments : Integer;
     Num_Results   : Integer);

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

  procedure Error (State : State_t);
  pragma No_Return (Error);

  -- Versioning

  function Version return String;
  function Release return String;
  function Version return Integer;

  -- Debug hooks

  procedure Set_Hook
   (State : State_t;
    Func  : Hook_t;
    AMask : Mask_t;
    Count : Integer);

  function Get_Hook_Mask (State : State_t) return Mask_t;

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
