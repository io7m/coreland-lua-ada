-- Lua API

with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Characters.Latin_1;

package body Lua is
  package IO renames Ada.Text_IO;

  use type IC.size_t;

  CR : constant Character := Ada.Characters.Latin_1.CR;
  LF : constant Character := Ada.Characters.Latin_1.LF;

  --
  -- C functions.
  --

  package C_Bindings is

    function luext_version return  ICS.chars_ptr;
    pragma Import (C, luext_version, "luext_version");

    function luext_version_num return Integer_t;
    pragma Import (C, luext_version_num, "luext_version_num");

    function luext_release return  ICS.chars_ptr;
    pragma Import (C, luext_release, "luext_release");

    function lual_newstate return State_t;
    pragma Import (C, lual_newstate, "luaL_newstate");

    procedure lua_close (State : State_t);
    pragma Import (C, lua_close, "lua_close");

    function lua_newthread (State : State_t) return State_t;
    pragma Import (C, lua_newthread, "lua_newthread");

    function lua_gettop (State : State_t) return Integer_t;
    pragma Import (C, lua_gettop, "lua_gettop");

    procedure lua_settop
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_settop, "lua_settop");

    function lua_checkstack
      (State : State_t;
       Extra : Integer_t) return Integer_t;
    pragma Import (C, lua_checkstack, "lua_checkstack");

    procedure lua_pushvalue
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_pushvalue, "lua_pushvalue");

    procedure lua_remove
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_remove, "lua_remove");

    procedure lua_insert
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_insert, "lua_insert");

    procedure lua_replace
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_replace, "lua_replace");

    --
    -- access functions
    --

    function lua_typename
      (State : State_t;
       Index : Integer_t) return ICS.chars_ptr;
    pragma Import (C, lua_typename, "lua_typename");

    function lua_type
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_type, "lua_type");

    function lua_isnumber
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_isnumber, "lua_isnumber");

    function lua_isstring
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_isstring, "lua_isstring");

    function lua_iscfunction
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_iscfunction, "lua_iscfunction");

    function lua_isuserdata
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_isuserdata, "lua_isuserdata");

    function lua_equal
     (State  : State_t;
      Index1 : Integer_t;
      Index2 : Integer_t) return Integer_t;
    pragma Import (C, lua_equal, "lua_equal");

    function lua_rawequal
     (State  : State_t;
      Index1 : Integer_t;
      Index2 : Integer_t) return Integer_t;
    pragma Import (C, lua_rawequal, "lua_rawequal");

    function lua_lessthan
     (State  : State_t;
      Index1 : Integer_t;
      Index2 : Integer_t) return Integer_t;
    pragma Import (C, lua_lessthan, "lua_lessthan");

    function lua_toboolean
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_toboolean, "lua_toboolean");

    function lua_tonumber
      (State : State_t;
       Index : Integer_t) return Number_t;
    pragma Import (C, lua_tonumber, "lua_tonumber");

    function lua_tointeger
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_tointeger, "lua_tointeger");

    function lua_tothread
      (State : State_t;
       Index : Integer_t) return State_t;
    pragma Import (C, lua_tothread, "lua_tothread");

    function luext_tostring
      (State : State_t;
       Index : Integer_t) return ICS.chars_ptr;
    pragma Import (C, luext_tostring, "luext_tostring");

    function lua_objlen
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_objlen, "lua_objlen");

    function lua_tocfunction
      (State : State_t;
       Index : Integer_t) return User_Function_t;
    pragma Import (C, lua_tocfunction, "lua_tocfunction");

    --
    -- push functions
    --

    procedure lua_pushboolean
      (State : State_t;
       B     : Integer_t);
    pragma Import (C, lua_pushboolean, "lua_pushboolean");

    procedure lua_pushnumber
      (State : State_t;
       N     : Number_t);
    pragma Import (C, lua_pushnumber, "lua_pushnumber");

    procedure lua_pushinteger
      (State : State_t;
       I     : Integer_t);
    pragma Import (C, lua_pushinteger, "lua_pushinteger");

    procedure lua_pushstring
      (State : State_t;
       Str   : ICS.chars_ptr);
    pragma Import (C, lua_pushstring, "lua_pushstring");

    procedure lua_pushlstring
      (State   : State_t;
       Address : System.Address;
       Size    : IC.size_t);
    pragma Import (C, lua_pushlstring, "lua_pushlstring");

    procedure lua_pushnil (State : State_t);
    pragma Import (C, lua_pushnil, "lua_pushnil");

    procedure lua_pushcclosure
      (State : in State_t;
       fn    : in User_Function_t;
       num   : in Integer_t);
    pragma Import (C, lua_pushcclosure, "lua_pushcclosure");

    procedure lua_concat
      (State : State_t;
       num   : Natural_t);
    pragma Import (C, lua_concat, "lua_concat");

    function lua_next
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_next, "lua_next");

    --
    -- metatable functions
    --

    function lua_getmetatable
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_getmetatable, "lua_getmetatable");

    function lua_setmetatable
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_setmetatable, "lua_setmetatable");

    --
    -- environment functions
    --

    procedure lua_getfenv
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_getfenv, "lua_getfenv");

    function lua_setfenv
      (State : State_t;
       Index : Integer_t) return Integer_t;
    pragma Import (C, lua_setfenv, "lua_setfenv");

    --
    -- registered functions
    --

    procedure lua_call
      (State         : State_t;
       Num_Arguments : Integer_t;
       Num_Results   : Integer_t);
    pragma Import (C, lua_call, "lua_call");

    function lua_pcall
     (State         : State_t;
      Num_Arguments : Integer_t;
      Num_Results   : Integer_t;
      Error_Func    : Integer_t) return Integer_t;
    pragma Import (C, lua_pcall, "lua_pcall");

    --
    -- table functions
    --

    procedure lua_createtable
      (State   : State_t;
       num_arr : Integer_t;
       num_rec : Integer_t);
    pragma Import (C, lua_createtable, "lua_createtable");

    procedure lua_settable
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_settable, "lua_settable");

    procedure lua_gettable
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_gettable, "lua_gettable");

    procedure lua_rawget
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_rawget, "lua_rawget");

    procedure lua_rawset
      (State : State_t;
       Index : Integer_t);
    pragma Import (C, lua_rawset, "lua_rawset");

    procedure lua_rawgeti
      (State   : State_t;
       Index   : Integer_t;
       Element : Integer_t);
    pragma Import (C, lua_rawgeti, "lua_rawgeti");

    procedure lua_rawseti
      (State   : State_t;
       Index   : Integer_t;
       Element : Integer_t);
    pragma Import (C, lua_rawseti, "lua_rawseti");

    --
    -- errors
    --

    function lua_atpanic
      (State : State_t;
       Func  : User_Function_t) return User_Function_t;
    procedure lua_atpanic
      (State : State_t;
       Func  : User_Function_t);
    pragma Import (C, Lua_Atpanic, "lua_atpanic");

    procedure lua_error (State : State_t);
    pragma Import (C, lua_error, "lua_error");
    pragma No_Return (lua_error);

    procedure lua_sethook
     (State : State_t;
      Func  : Hook_t;
      AMask : Integer_t;
      Count : Integer_t);
    pragma Import (C, lua_sethook, "lua_sethook");

    function lua_gethookmask (State : State_t) return Integer_t;
    pragma Import (C, lua_gethookmask, "lua_gethookmask");

    function lua_gethookcount (State : State_t) return Integer_t;
    pragma Import (C, lua_gethookcount, "lua_gethookcount");

    --
    -- set functions
    --

    procedure lua_setfield
      (State : State_t;
       Index : Integer_t;
       Key   : ICS.chars_ptr);
    pragma Import (C, lua_setfield, "lua_setfield");

    --
    -- get functions
    --

    procedure lua_getfield
      (State : State_t;
       Index : Integer_t;
       Key   : ICS.chars_ptr);
    pragma Import (C, lua_getfield, "lua_getfield");

    --
    -- coroutines
    --

    function lua_resume
      (State : State_t;
       Narg  : Integer_t) return Integer_t;
    pragma Import (C, lua_resume, "lua_resume");

    type Buffer_Context_t is record
      Buffer      : ICS.chars_ptr;
      Buffer_Size : IC.size_t;
    end record;
    type Buffer_Context_Access_t is access all Buffer_Context_t;
    pragma Convention (C, Buffer_Context_t);
    pragma Convention (C, Buffer_Context_Access_t);

    type buffer_func_t is access function
     (State : State_t;
      Data  : Buffer_Context_Access_t;
      Size  : access IC.size_t)
    return    ICS.chars_ptr;
    pragma Convention (C, buffer_func_t);

    function lua_load_buffer
     (State : State_t;
      Func  : buffer_func_t;
      Data  : Buffer_Context_Access_t;
      Name  : ICS.chars_ptr)
      return  Integer_t;
    pragma Import (C, lua_load_buffer, "lua_load");

    function read_buffer
     (State : State_t;
      Data  : Buffer_Context_Access_t;
      Size  : access IC.size_t)
      return  ICS.chars_ptr;
    pragma Convention (C, read_buffer);

  end C_Bindings;

  package body C_Bindings is

    function read_buffer
     (State : State_t;
      Data  : Buffer_Context_Access_t;
      Size  : access IC.size_t)
      return  ICS.chars_ptr
    is
      pragma Assert (State /= State_Error);

      Size_Alias : constant access IC.size_t := Size;
    begin
      if Data.all.Buffer_Size = 0 then
        return ICS.Null_Ptr;
      end if;
      Size_Alias.all   := Data.all.Buffer_Size;
      Data.all.Buffer_Size := 0;
      return Data.all.Buffer;
    end read_buffer;

  end C_Bindings;

  --
  -- load functions
  --

  function Load_Buffer
   (State  : State_t;
    Buffer : ICS.chars_ptr;
    Size   : IC.size_t;
    Name   : String) return Error_t
  is
    C_Buffer : aliased IC.char_array               := IC.To_C (Name);
    context  : aliased C_Bindings.Buffer_Context_t := (Buffer, Size);
  begin
    return Error_t'Val
      (C_Bindings.lua_load_buffer
        (State => State,
         Func  => C_Bindings.read_buffer'Access,
         Data  => context'Unchecked_Access,
         Name  => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access)));
  end Load_Buffer;

  function Load_Buffer
   (State  : State_t;
    Buffer : String;
    Size   : Natural;
    Name   : String) return Error_t
  is
    C_Buffer : aliased IC.char_array := IC.To_C (Buffer);
  begin
    return Load_Buffer
     (State  => State,
      Buffer => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access),
      Size   => IC.size_t (Size),
      Name   => Name);
  end Load_Buffer;

  function Load_Buffer
   (State  : State_t;
    Buffer : UB_Strings.Unbounded_String;
    Name   : String) return Error_t is
  begin
    return Load_Buffer
     (State  => State,
      Buffer => UB_Strings.To_String (Buffer),
      Size   => UB_Strings.Length (Buffer),
      Name   => Name);
  end Load_Buffer;

  function Load_File (State : State_t; File : String) return Error_t is
    FD        : Ada.Text_IO.File_Type;
    Buffer    : String (1 .. 4096);
    Length    : Natural;
    UB_Buffer : UB_Strings.Unbounded_String;
  begin
    IO.Open (FD, IO.In_File, File);
    while not IO.End_Of_File (FD) loop
      IO.Get_Line (FD, Buffer, Length);
      UB_Strings.Append (UB_Buffer, Buffer (1 .. Length) & LF);
    end loop;
    IO.Close (FD);
    return Load_Buffer (State, UB_Buffer, File);
  end Load_File;

  function Load_String
    (State  : State_t;
     Buffer : String) return Error_t is
  begin
    return Load_Buffer
      (State  => State,
       Buffer => Buffer,
       Size   => Buffer'Last,
       Name   => "");
  end Load_String;

  --
  -- execute functions
  --

  function Exec_File
    (State : State_t;
     File  : String) return Error_t
  is
    Error_Code : Error_t;
  begin
    Error_Code := Load_File (State, File);
    if Error_Code /= Lua_Error_None then
      return Error_Code;
    end if;
    Error_Code := Error_t'Val (C_Bindings.lua_pcall (State, 0, -1, 0));
    return Error_Code;
  end Exec_File;

  function Exec_String
    (State : State_t;
     Str   : String) return Error_t
  is
    Error_Code : Error_t;
  begin
    Error_Code := Load_String (State, Str);
    if Error_Code /= Lua_Error_None then
      return Error_Code;
    end if;
    Error_Code := Error_t'Val (C_Bindings.lua_pcall (State, 0, -1, 0));
    return Error_Code;
  end Exec_String;

  --
  -- Main API
  --

  procedure Set_Hook
   (State : State_t;
    Func  : Hook_t;
    AMask : Mask_t;
    Count : Integer) is
  begin
    C_Bindings.lua_sethook (State, Func, Integer_t (AMask), Integer_t (Count));
  end Set_Hook;

  function Get_Hook_Mask (State : State_t) return Mask_t is
  begin
    return Mask_t (C_Bindings.lua_gethookmask (State));
  end Get_Hook_Mask;

  function Get_Hook_Count (State : State_t) return Natural is
  begin
    return Natural (C_Bindings.lua_gethookcount (State));
  end Get_Hook_Count;

  procedure Error (State : State_t) is
  begin
    C_Bindings.lua_error (State);
  end Error;

  --
  -- State manipulation
  --

  function Open return State_t is
  begin
    return C_Bindings.lual_newstate;
  end Open;

  procedure Close (State : State_t) is
  begin
    C_Bindings.lua_close (State);
  end Close;

  function New_Thread (State : State_t) return State_t is
  begin
    return C_Bindings.lua_newthread (State);
  end New_Thread;

  function At_Panic
    (State          : State_t;
     Panic_Function : User_Function_t) return User_Function_t is
  begin
    return C_Bindings.lua_atpanic (State, Panic_Function);
  end At_Panic;

  procedure At_Panic
    (State          : State_t;
     Panic_Function : User_Function_t) is
  begin
    C_Bindings.lua_atpanic (State, Panic_Function);
  end At_Panic;

  --
  -- stack manipulation
  --

  function Get_Top (State : State_t) return Integer is
  begin
    return Integer (C_Bindings.lua_gettop (State));
  end Get_Top;

  procedure Set_Top
    (State : State_t;
     Index : Integer) is
  begin
    C_Bindings.lua_settop (State, Integer_t (Index));
  end Set_Top;

  procedure Push_Value
   (State : State_t;
    Index : Integer) is
  begin
    C_Bindings.lua_pushvalue (State, Integer_t (Index));
  end Push_Value;

  procedure Remove
    (State : State_t;
     Index : Integer) is
  begin
    C_Bindings.lua_remove (State, Integer_t (Index));
  end Remove;

  procedure Insert
   (State : State_t;
    Index : Integer) is
  begin
    C_Bindings.lua_insert (State, Integer_t (Index));
  end Insert;

  procedure Replace
   (State : State_t;
    Index : Integer) is
  begin
    C_Bindings.lua_replace (State, Integer_t (Index));
  end Replace;

  function Check_Stack
   (State : State_t;
    Size  : Integer) return Boolean is
  begin
    return C_Bindings.lua_checkstack (State, Integer_t (Size)) /= 0;
  end Check_Stack;

  --
  -- access functions (stack -> Ada)
  --

  function Is_Number
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return C_Bindings.lua_isnumber (State, Integer_t (Index)) /= 0;
  end Is_Number;

  function Is_String
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return C_Bindings.lua_isstring (State, Integer_t (Index)) /= 0;
  end Is_String;

  function Is_User_Function
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return C_Bindings.lua_iscfunction (State, Integer_t (Index)) /= 0;
  end Is_User_Function;

  function Is_Userdata
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return C_Bindings.lua_isuserdata (State, Integer_t (Index)) /= 0;
  end Is_Userdata;

  function Is_Nil
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return C_Bindings.lua_type (State, Integer_t (Index)) = 0;
  end Is_Nil;

  function Is_None_Or_Nil
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return Is_None (State, Index) or Is_Nil (State, Index);
  end Is_None_Or_Nil;

  function Is_Table
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return Type_Of (State, Index) = T_Table;
  end Is_Table;

  function Is_Boolean
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return Type_Of (State, Index) = T_Boolean;
  end Is_Boolean;

  function Is_Function
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return Type_Of (State, Index) = T_Function;
  end Is_Function;

  function Is_Thread
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return Type_Of (State, Index) = T_Thread;
  end Is_Thread;

  function Is_None
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return Type_Of (State, Index) = T_None;
  end Is_None;

  function Is_Light_Userdata
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return Type_Of (State, Index) = T_Light_Userdata;
  end Is_Light_Userdata;

  function Type_Of
    (State : State_t;
     Index : Integer) return Type_t
  is
    Type_Number : Integer_t;
  begin
    Type_Number := C_Bindings.lua_type (State, Integer_t (Index));
    return Type_t'Val (Type_Number + 1);
  end Type_Of;

  function Type_Name
    (State : State_t;
     Index : Integer) return String
  is
    T : constant Integer_t := C_Bindings.lua_type (State, Integer_t (Index));
  begin
    return ICS.Value (C_Bindings.lua_typename (State, T));
  end Type_Name;

  function Type_Name (T : Lua.Type_t) return String is
  begin
    case T is
    when T_None           => return "none";
    when T_Nil            => return "nil";
    when T_Boolean        => return "boolean";
    when T_Light_Userdata => return "light_userdata";
    when T_Number         => return "number";
    when T_String         => return "string";
    when T_Table          => return "table";
    when T_Function       => return "function";
    when T_Userdata       => return "userdata";
    when T_Thread         => return "thread";
    end case;
  end Type_Name;

  function To_Number
    (State : State_t;
     Index : Integer) return Number_t is
  begin
    return C_Bindings.lua_tonumber (State, Integer_t (Index));
  end To_Number;

  function To_String
    (State : State_t;
     Index : Integer) return String
  is
    C_String : ICS.chars_ptr;
  begin
    C_String := C_Bindings.luext_tostring (State, Integer_t (Index));
    if C_String /= ICS.Null_Ptr then
      return ICS.Value (C_String);
    else
      return "";
    end if;
  end To_String;

  function To_Unbounded_String
    (State : State_t;
     Index : Integer) return UB_Strings.Unbounded_String is
  begin
    return UB_Strings.To_Unbounded_String (To_String (State, Index));
  end To_Unbounded_String;

  function To_Boolean
    (State : State_t;
     Index : Integer) return Boolean is
  begin
    return C_Bindings.lua_toboolean (State, Integer_t (Index)) /= 0;
  end To_Boolean;

  function To_Integer
    (State : State_t;
     Index : Integer) return Integer_t is
  begin
    return C_Bindings.lua_tointeger (State, Integer_t (Index));
  end To_Integer;

  function To_Thread
    (State : State_t;
     Index : Integer) return State_t is
  begin
    return C_Bindings.lua_tothread (State, Integer_t (Index));
  end To_Thread;

  function To_C_Function
   (State : State_t;
    Index : Integer) return User_Function_t is
  begin
    return C_Bindings.lua_tocfunction (State, Integer_t (Index));
  end To_C_Function;

  function Is_Equal
   (State  : State_t;
    Index1 : Integer;
    Index2 : Integer) return Boolean is
  begin
    return C_Bindings.lua_equal (State, Integer_t (Index1), Integer_t (Index2)) /= 0;
  end Is_Equal;

  function Is_Raw_Equal
   (State  : State_t;
    Index1 : Integer;
    Index2 : Integer) return Boolean is
  begin
    return C_Bindings.lua_rawequal (State, Integer_t (Index1), Integer_t (Index2)) /= 0;
  end Is_Raw_Equal;

  function Is_Less_Than
   (State  : State_t;
    Index1 : Integer;
    Index2 : Integer) return Boolean is
  begin
    return C_Bindings.lua_lessthan (State, Integer_t (Index1), Integer_t (Index2)) /= 0;
  end Is_Less_Than;

  function Object_Length
   (State : State_t;
    Index : Integer) return Integer_t is
  begin
    return C_Bindings.lua_objlen (State, Integer_t (Index));
  end Object_Length;

  --
  -- push functions (Ada -> stack)
  --

  procedure Push_Nil (State : State_t) is
  begin
    C_Bindings.lua_pushnil (State);
  end Push_Nil;

  procedure Push_Number
   (State : State_t;
    N     : Number_t) is
  begin
    C_Bindings.lua_pushnumber (State, N);
  end Push_Number;

  procedure Push_Integer
    (State : State_t;
     I     : Integer_t) is
  begin
    C_Bindings.lua_pushinteger (State, I);
  end Push_Integer;

  procedure Push_Boolean
   (State : State_t;
    B     : Boolean) is
  begin
    if B then
      C_Bindings.lua_pushboolean (State, 1);
    else
      C_Bindings.lua_pushboolean (State, 0);
    end if;
  end Push_Boolean;

  procedure Push_String
    (State : State_t;
     Str   : ICS.chars_ptr) is
  begin
    C_Bindings.lua_pushstring (State, Str);
  end Push_String;

  procedure Push_String
    (State : State_t;
     Str   : String) is
  begin
    if Str'Length > 0 then
      C_Bindings.lua_pushlstring (State => State, Address => Str (Str'First)'Address, Size => Str'Length);
    else
      C_Bindings.lua_pushlstring (State, System.Null_Address, 0);
    end if;
  end Push_String;

  procedure Push_String
    (State : State_t;
     Str   : UB_Strings.Unbounded_String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (UB_Strings.To_String (Str));
  begin
    C_Bindings.lua_pushstring (State => State, Str => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Push_String;

  procedure Push_String
    (State   : State_t;
     Address : System.Address;
     Size    : Positive) is
  begin
    C_Bindings.lua_pushlstring (State => State, Address => Address, Size => IC.size_t (Size));
  end Push_String;

  procedure Push_User_Closure
    (State      : State_t;
     Func       : User_Function_t;
     Num_Params : Integer) is
  begin
    C_Bindings.lua_pushcclosure (State, Func, Integer_t (Num_Params));
  end Push_User_Closure;

  procedure Push_User_Function
    (State : State_t;
     Func  : User_Function_t) is
  begin
    C_Bindings.lua_pushcclosure (State, Func, 0);
  end Push_User_Function;

  procedure Concat
    (State : State_t;
     N     : Natural) is
  begin
    C_Bindings.lua_concat (State, Integer_t (N));
  end Concat;

  --
  -- get functions (lua -> stack)
  --

  procedure Get_Table
    (State : State_t;
     Index : Integer) is
  begin
    C_Bindings.lua_gettable (State, Integer_t (Index));
  end Get_Table;

  function Get_Metatable
    (State : State_t;
     Index : Integer) return Error_t is
  begin
    return Error_t'Val (C_Bindings.lua_getmetatable (State, Integer_t (Index)));
  end Get_Metatable;

  procedure Raw_Get
    (State : State_t;
     Index : Integer) is
  begin
    C_Bindings.lua_rawget (State, Integer_t (Index));
  end Raw_Get;

  procedure Raw_Get_Index
    (State   : State_t;
     Index   : Integer;
     Element : Integer) is
  begin
    C_Bindings.lua_rawgeti (State, Integer_t (Index), Integer_t (Element));
  end Raw_Get_Index;

  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : ICS.chars_ptr) is
  begin
    C_Bindings.lua_getfield (State, Integer_t (Index), Key);
  end Get_Field;

  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (Key);
  begin
    C_Bindings.lua_getfield
      (State => State,
       Index => Integer_t (Index),
       Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Get_Field;

  procedure Get_Field
    (State : State_t;
     Index : Integer;
     Key   : UB_Strings.Unbounded_String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (UB_Strings.To_String (Key));
  begin
    C_Bindings.lua_getfield
      (State => State,
       Index => Integer_t (Index),
       Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Get_Field;

  procedure Get_Global
    (State : State_t;
     Key   : ICS.chars_ptr) is
  begin
    C_Bindings.lua_getfield (State, Globals_Index, Key);
  end Get_Global;

  procedure Get_Global
    (State : State_t;
     Key   : String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (Key);
  begin
    C_Bindings.lua_getfield
      (State => State,
       Index => Globals_Index,
       Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Get_Global;

  procedure Get_Global
    (State : State_t;
     Key   : UB_Strings.Unbounded_String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (UB_Strings.To_String (Key));
  begin
    C_Bindings.lua_getfield
      (State => State,
       Index => Globals_Index,
       Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Get_Global;

  procedure Get_FEnv
    (State : State_t;
     Index : Integer) is
  begin
    C_Bindings.lua_getfenv (State, Integer_t (Index));
  end Get_FEnv;

  --
  -- set functions (stack -> lua)
  --

  procedure Set_Table
   (State : State_t;
    Index : Integer) is
  begin
    C_Bindings.lua_settable (State, Integer_t (Index));
  end Set_Table;

  function Set_Metatable
    (State : State_t;
     Index : Integer) return Error_t is
  begin
    return Error_t'Val (C_Bindings.lua_setmetatable (State, Integer_t (Index)));
  end Set_Metatable;

  procedure Raw_Set
    (State : State_t;
     Index : Integer) is
  begin
    C_Bindings.lua_rawset (State, Integer_t (Index));
  end Raw_Set;

  procedure Create_Table
    (State              : State_t;
     Array_Elements     : in Natural;
     Non_Array_Elements : in Natural) is
  begin
    C_Bindings.lua_createtable
      (State   => State,
       num_arr => Integer_t (Array_Elements),
       num_rec => Integer_t (Non_Array_Elements));
  end Create_Table;

  procedure New_Table (State : State_t) is
  begin
    C_Bindings.lua_createtable (State, 0, 0);
  end New_Table;

  procedure Raw_Set_Index
    (State   : State_t;
     Index   : Integer;
     Element : Integer) is
  begin
    C_Bindings.lua_rawseti (State, Integer_t (Index), Integer_t (Element));
  end Raw_Set_Index;

  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : ICS.chars_ptr) is
  begin
    C_Bindings.lua_setfield
      (State => State,
       Index => Integer_t (Index),
       Key   => Key);
  end Set_Field;

  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (Key);
  begin
    C_Bindings.lua_setfield
      (State => State,
       Index => Integer_t (Index),
       Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Set_Field;

  procedure Set_Field
    (State : State_t;
     Index : Integer;
     Key   : UB_Strings.Unbounded_String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (UB_Strings.To_String (Key));
  begin
    C_Bindings.lua_setfield
      (State => State,
       Index => Integer_t (Index),
       Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Set_Field;

  procedure Set_Global
   (State : State_t;
    Key   : ICS.chars_ptr) is
  begin
    C_Bindings.lua_setfield (State, Globals_Index, Key);
  end Set_Global;

  procedure Set_Global
   (State : State_t;
    Key   : String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (Key);
  begin
    C_Bindings.lua_setfield
      (State => State,
       Index => Globals_Index,
       Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Set_Global;

  procedure Set_Global
   (State : State_t;
    Key   : UB_Strings.Unbounded_String)
  is
    C_Buffer : aliased IC.char_array := IC.To_C (UB_Strings.To_String (Key));
  begin
    C_Bindings.lua_setfield
     (State => State,
      Index => Globals_Index,
      Key   => ICS.To_Chars_Ptr (C_Buffer'Unchecked_Access));
  end Set_Global;

  function Set_FEnv (State : State_t; Index : Integer) return Error_t is
  begin
    return Error_t'Val (C_Bindings.lua_setfenv (State, Integer_t (Index)));
  end Set_FEnv;

  --
  -- coroutines
  --

  function Ret_Error
    (Error_Code : Error_t;
     Message    : String) return Error_Message_t
  is
    Complete_Message : constant String := Error_Messages (Error_Code).all & Message;
  begin
    return (Complete_Message'Length, Error_Code, Complete_Message);
  end Ret_Error;

  function Resume
    (State         : State_t;
     Num_Arguments : Integer) return Error_Message_t
  is
    Error : Error_t;
    NDX   : constant Integer_t := C_Bindings.lua_gettop (State) - Integer_t (Num_Arguments);
  begin
    Push_String (State, "_traceback");
    C_Bindings.lua_rawget (State, Globals_Index);
    C_Bindings.lua_insert (State, NDX);
    Error := Error_t'Val (C_Bindings.lua_resume (State, Integer_t (Num_Arguments)));
    C_Bindings.lua_remove (State, NDX);

    if Error /= Lua_Error_None then
      return Ret_Error (Error, To_String (State, -1));
    else
      return No_Error;
    end if;
  exception
    when err : others =>
      return Ret_Error (Lua_Exception,
         "exception while doing lua.traced_call:" & CR & LF & Ada.Exceptions.Exception_Information (err));
  end Resume;

  --
  -- misc
  --

  procedure Register
    (State     : State_t;
     Func_Name : String;
     Func_Ptr  : User_Function_t) is
  begin
    Push_String (State, Func_Name);
    C_Bindings.lua_pushcclosure (State, Func_Ptr, 0);
    C_Bindings.lua_settable (State, Globals_Index);
  end Register;

  procedure Call
    (State         : State_t;
     Num_Arguments : Integer;
     Num_Results   : Integer) is
  begin
    C_Bindings.lua_call
      (State         => State,
       Num_Arguments => Integer_t (Num_Arguments),
       Num_Results   => Integer_t (Num_Results));
  end Call;

  function PCall
   (State         : State_t;
    Num_Arguments : Integer;
    Num_Results   : Integer;
    Error_Func    : Integer) return Error_t is
  begin
    return Error_t'Val
      (C_Bindings.lua_pcall
        (State         => State,
         Num_Arguments => Lua.Integer_t (Num_Arguments),
         Num_Results   => Lua.Integer_t (Num_Results),
         Error_Func    => Lua.Integer_t (Error_Func)));
  end PCall;

  procedure Pop
   (State : State_t;
    Count : Integer) is
  begin
    Set_Top (State, -(Count) - 1);
  end Pop;

  function Next
   (State : State_t;
    Index : Integer) return Integer is
  begin
    return Integer (C_Bindings.lua_next (State, Integer_t (Index)));
  end Next;

  function Reference (State : State_t) return Object_Ref_t is
  begin
    return Reference (State, Registry_Index);
  end Reference;

  procedure Unreference
   (State : State_t;
    Ref   : Object_Ref_t) is
  begin
    Unreference (State, Registry_Index, Ref);
  end Unreference;

  procedure Dereference
   (State : State_t;
    Ref   : Object_Ref_t) is
  begin
    Raw_Get_Index (State, Registry_Index, Integer (Ref));
  end Dereference;

  function Version return String is
  begin
    return ICS.Value (C_Bindings.luext_version);
  end Version;

  function Version return Integer is
  begin
    return Integer (C_Bindings.luext_version_num);
  end Version;

  function Release return String is
  begin
    return ICS.Value (C_Bindings.luext_release);
  end Release;

  --
  -- Generic typed loading.
  --

  function Load_Typed
    (State      : State_t;
     Reader     : Chunk_Reader_t;
     Data       : access User_Data;
     Chunk_Name : String) return Error_t
  is
    function lua_load_generic
      (State      : State_t;
       Reader     : Chunk_Reader_t;
       Data       : access User_Data;
       Chunk_Name : ICS.chars_ptr) return IC.int;
    pragma Import (C, lua_load_generic, "lua_load");

    C_Chunk_Name : aliased IC.char_array := IC.To_C (Chunk_Name);
  begin
    return Error_t'Val (lua_load_generic
      (State      => State,
       Reader     => Reader,
       Data       => Data,
       Chunk_Name => ICS.To_Chars_Ptr (C_Chunk_Name'Unchecked_Access)));
  end Load_Typed;

end Lua;
