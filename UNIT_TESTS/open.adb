with UTest;
with Lua;

-- the majority of strange code here is to stop very strict compilers from
-- complaining about unread or unreferenced variables.
procedure open is
  use type Lua.State_t;

  State       : Lua.State_t;
  State_Dummy : Lua.State_t;
begin
  State       := Lua.Open;
  State_Dummy := State;
  State       := State_Dummy;
  if State /= State_Dummy then
    raise Program_Error with "assignment error";
  end if;
exception
  when others =>
    UTest.Fail (2, "unexpected exception");
end open;
