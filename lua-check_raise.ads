package Lua.Check_Raise is

  function Check_Raise (State : Lua.State_t) return Lua.Integer_t;
  pragma Convention (C, Check_Raise);

  Check_Raise_Error : exception;

end Lua.Check_Raise;
