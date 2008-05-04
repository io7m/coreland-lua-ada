with utest;
with lua;

procedure open is
  ls: lua.state;
begin
  ls := lua.open;
exception
  when others => utest.fail (2, "unexpected exception");
end open;
