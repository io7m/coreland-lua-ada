with utest;
with lua;

procedure open is
  ls: lua.state_ptr_t;
  lsdummy: lua.state_ptr_t;
begin
  ls := lua.open;
  lsdummy := ls; -- stop very strict compilers from complaining about unread var
  ls := lsdummy;
exception
  when others => utest.fail (2, "unexpected exception");
end open;
