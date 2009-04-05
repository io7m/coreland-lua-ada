package body Lua.Check_Raise is

  function Check_Raise (State : Lua.State_t) return Lua.Integer_t is
    use type Lua.State_t;
  begin
    pragma Assert (State /= Lua.State_Error);
    raise Check_Raise_Error;
    return 0;
  end Check_Raise;

end Lua.Check_Raise;
