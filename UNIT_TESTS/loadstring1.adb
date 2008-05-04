with utest;
with lua;
with lua.lib;

procedure loadstring1 is
  use type lua.error_type;

  ls: lua.state;
  ec: lua.error_type;
begin
  ls := lua.open;
  lua.lib.open_base (ls);

  ec := lua.load_string (ls, "print 'loaded string'");
  if ec /= lua.lua_error_none then
    utest.fail (1, lua.to_string (ls, -1));
  end if;

exception
  when others => utest.fail (2, "unexpected exception");
end loadstring1;
