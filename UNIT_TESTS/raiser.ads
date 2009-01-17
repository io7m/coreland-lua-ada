with lua;

package raiser is

  function raiser
    (state : lua.state_t) return lua.int_t;
  pragma convention (c, raiser);

  raiser_error : exception;

end raiser;
