with utest;
with lua;
with lua.lib;

procedure loadbase is
  ls: lua.state_ptr_t;
begin
  ls := lua.open;
  lua.lib.open_base (ls);
exception
  when others => utest.fail (2, "unexpected exception");
end loadbase;
