package body raiser is

  function raiser
    (state : lua.state_t) return lua.int_t is
  begin
    raise raiser_error;
    return 0;
  end raiser;

end raiser;
