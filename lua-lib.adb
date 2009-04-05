-- Lua standard libraries

package body Lua.Lib is

  function New_Metatable
    (State : Lua.State_t;
     Name  : String) return Boolean is
  begin
    Lua.Push_String (State, Name);
    Lua.Raw_Get (State, Lua.Registry_Index);
    if Lua.Is_Nil (State, -1) = False then
      return False;
    end if;
    Lua.Pop (State, 1);
    Lua.New_Table (State);
    -- 1 metatable
    Lua.Push_String (State, Name);
    -- 1 metatable
    -- 2 Name
    Lua.Push_Value (State, -2);
    -- 1 metatable
    -- 2 Name
    -- 3 metatable
    Lua.Raw_Set (State, Lua.Registry_Index);
    -- 1 metatable
    Lua.Push_Value (State, -1);
    -- 1 metatable
    -- 2 metatable
    Lua.Push_String (State, Name);
    -- 1 metatable
    -- 2 metatable
    -- 3 Name
    Lua.Raw_Set (State, Lua.Registry_Index);
    -- 1 metatable
    return True;
  end New_Metatable;

  procedure Open_Library
   (State     : Lua.State_t;
    Name      : String;
    Functions : Register_Array_t;
    num_up    : Integer)
  is
  begin
    if Name /= "" then
      Lua.Push_String (State, Name);
      Lua.Get_Table (State, Lua.Globals_Index);
      if Lua.Is_Nil (State, -1) then
        Lua.Pop (State, 1);
        Lua.New_Table (State);
        Lua.Push_String (State, Name);
        Lua.Push_Value (State, -2);
        Lua.Set_Table (State, Lua.Globals_Index);
      end if;
      Lua.Insert (State, -(num_up + 1));
    end if;

    for Index in Functions'First .. Functions'Last loop
      Lua.Push_String (State, Functions (Index).Name);
      for j in 1 .. num_up loop
        Lua.Push_Value (State, -(num_up + 1));
      end loop;
      Lua.Push_User_Closure (State, Functions (Index).Func, num_up);
      Lua.Set_Table (State, -(num_up + 3));
    end loop;

    Lua.Pop (State, num_up);
  end Open_Library;

end Lua.Lib;
