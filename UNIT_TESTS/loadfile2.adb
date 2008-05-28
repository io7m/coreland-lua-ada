with utest;
with lua;
with lua.lib;

procedure loadfile2 is
  use type lua.error_t;

  ls: lua.state_ptr_t;
  ec: lua.error_t;
begin
  ls := lua.open;
  lua.lib.open_base (ls);

  ec := lua.load_file (ls, "test.lua");
  if ec /= lua.lua_error_none then
    utest.fail (1, lua.to_string (ls, -1));
  end if;

  ec := lua.pcall (ls, 0, -1, 0);
  if ec /= lua.lua_error_none then
    utest.fail (1, lua.to_string (ls, -1));
  end if;

exception
  when others => utest.fail (2, "unexpected exception");
end loadfile2;
