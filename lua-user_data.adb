-- Lua userdata handling

package body Lua.User_Data is

  use type System.Address;

  package C_Bindings is
    function New_User_Data
      (State : Lua.State_t;
       Size  : Lua.IC.size_t) return System.Address;
    pragma Import (C, New_User_Data, "lua_newuserdata");

    function To_User_Data
      (State : Lua.State_t;
       Index : Lua.Integer_t) return System.Address;
    pragma Import (C, To_User_Data, "lua_touserdata");
  end C_Bindings;

  procedure Register (State : Lua.State_t) is
    Dummy : Boolean;
  begin
    Lua.Lib.Open_Library (State, Class_Name, Method_Table, 0);
    Dummy := Lua.Lib.New_Metatable (State, Class_Name);
    if not Dummy then
      return;
    end if;
    Lua.Lib.Open_Library (State, "", Meta_Table, 0);
    Lua.Push_String (State, "__index");
    Lua.Push_Value (State, -3);
    Lua.Raw_Set (State, -3);
    Lua.Push_String (State, "__metatable");
    Lua.Push_Value (State, -3);
    Lua.Raw_Set (State, -3);
    Lua.Pop (State, 1);
  end Register;

  procedure Push
    (State : Lua.State_t;
     Item  : User_Data_t)
  is
    UD_Access : User_Data_Access_t;
    Error     : Lua.Error_t;
  begin
    UD_Access := User_Data_Access_t
      (Convert.To_Pointer
        (C_Bindings.New_User_Data
          (State => State,
           Size  => Lua.IC.size_t (User_Data_t'Size / System.Storage_Unit))));

    UD_Access.all := Item;
    Lua.Push_String (State, Class_Name);
    Lua.Raw_Get (State, Lua.Registry_Index);
    Error := Lua.Set_Metatable (State, -2);
    if Error /= Lua.Lua_Error_None then
      return;
    end if;
  end Push;

  function Get
    (State : Lua.State_t;
     Index : Integer := 1) return User_Data_t
  is
    Address : constant System.Address := C_Bindings.To_User_Data (State, Lua.Integer_t (Index));
  begin
    return Convert.To_Pointer (Address).all;
  end Get;

end Lua.User_Data;
