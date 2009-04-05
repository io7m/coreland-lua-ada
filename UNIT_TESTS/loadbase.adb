with UTest;
with Lua;
with Lua.Lib;

procedure loadbase is
  State : Lua.State_t;
begin
  State := Lua.Open;
  Lua.Lib.Open_Base (State);
exception
  when others =>
    UTest.Fail (2, "unexpected exception");
end loadbase;
