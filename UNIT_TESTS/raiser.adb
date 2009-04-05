with Ada.Text_IO;

package body Raiser is

  function Raiser
    (State : Lua.State_t) return Lua.Integer_t
  is
    use type Lua.State_t;
  begin
    pragma Assert (State /= Lua.State_Error);
    Ada.Text_IO.Put_Line ("inside Raiser.Raiser...");
    raise Raiser_Error;
    return 0;
  end Raiser;

end Raiser;
