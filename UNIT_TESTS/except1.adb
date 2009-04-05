with Ada.Text_IO;
with Lua;
with Lua.Config;
with Raiser;
with UTest;

-- ensure exceptions can be passed through libLua

procedure except1 is
  State  : Lua.State_t;
  Caught : Boolean := False;

  use type Lua.State_t;
  use type Lua.Number_t;
begin

  if Lua.Config.Can_Propagate_Exceptions then
    State := Lua.Open;

    Lua.At_Panic
      (State          => State,
       Panic_Function => Raiser.Raiser'Access);
    Ada.Text_IO.Put_Line ("registered panic handler");

    begin
      Ada.Text_IO.Put_Line ("causing panic...");
      Lua.Push_Number (State, -1.0);
      Lua.Call (State, 1, 1);
    exception
      when Raiser.Raiser_Error =>
        Ada.Text_IO.Put_Line ("Caught Raiser.Raiser_Error");
        Caught := True;
    end;

    UTest.Check
      (Check   => Caught,
       Message => "Caught exception");
  end if;
end except1;
