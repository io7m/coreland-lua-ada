with Lua;
with Lua.Check_Raise;

procedure Lua_Check_Exception is
  State  : Lua.State_t;
  Caught : Boolean := False;

  use type Lua.State_t;
  use type Lua.Number_t;
begin
  State := Lua.Open;

  if State = Lua.State_Error then
    raise Program_Error;
  end if;

  Lua.At_Panic
    (State          => State,
     Panic_Function => Lua.Check_Raise.Check_Raise'Access);

  begin
    Lua.Push_Number (State, -1.0);
    Lua.Call (State, 1, 1);
  exception
    when Lua.Check_Raise.Check_Raise_Error => Caught := True;
  end;

  if not Caught then
    raise Program_Error;
  end if;

end Lua_Check_Exception;
