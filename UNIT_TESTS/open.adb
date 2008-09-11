with utest;
with lua;

-- the majority of strange code here is to stop very strict compilers from
-- complaining about unread or unreferenced variables.
procedure open is
  use type lua.state_ptr_t;

  ls: lua.state_ptr_t;
  lsdummy: lua.state_ptr_t;
begin
  ls := lua.open;
  lsdummy := ls;
  ls := lsdummy;
  if ls /= lsdummy then
    raise program_error with "assignment error";
  end if;
exception
  when others => utest.fail (2, "unexpected exception");
end open;
