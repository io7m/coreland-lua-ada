with ada.text_io;

package body raiser is

  function raiser
    (state : lua.state_t) return lua.int_t is
  begin
    ada.text_io.put_line ("inside raiser.raiser...");
    raise raiser_error;
    return 0;
  end raiser;

end raiser;
