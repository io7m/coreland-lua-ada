with UTest;
with Lua;
with Lua.Lib;

procedure loadfile2 is
  use type Lua.Error_t;

  State      : Lua.State_t;
  Error_Code : Lua.Error_t;
begin
  State := Lua.Open;
  Lua.Lib.Open_Base (State);

  Error_Code := Lua.Load_File (State, "test.lua");
  if Error_Code /= Lua.Lua_Error_None then
    UTest.Fail (1, Lua.To_String (State, -1));
  end if;

  Error_Code := Lua.PCall (State, 0, -1, 0);
  if Error_Code /= Lua.Lua_Error_None then
    UTest.Fail (1, Lua.To_String (State, -1));
  end if;

exception
  when others =>
    UTest.Fail (2, "unexpected exception");
end loadfile2;
