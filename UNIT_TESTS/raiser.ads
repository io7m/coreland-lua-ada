with Lua;

package Raiser is

  function Raiser
    (State : Lua.State_t) return Lua.Integer_t;
  pragma Convention (C, Raiser);

  Raiser_Error : exception;

end Raiser;
