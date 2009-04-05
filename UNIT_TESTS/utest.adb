with Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Strings;
with Interfaces.C;

package body UTest is
  package IO renames Ada.Text_IO;
  package IC renames Interfaces.C;
  package Fixed_Strings renames Ada.Strings.Fixed;
  package Strings renames Ada.Strings;

  procedure Sys_Exit (ecode : IC.int);
  pragma Import (C, Sys_Exit, "_exit");

  Test_Number : Natural;

  procedure Fail
    (Exit_Code : in Integer;
     Message   : in String)
  is
    Num_String : constant String := Fixed_Strings.Trim (Natural'Image (Test_Number), Strings.Left);
  begin
    IO.Put_Line ("[" & Num_String & "] Fail: " & Message);
    Sys_Exit (IC.int (Exit_Code));
  end Fail;

  procedure Pass (Message : in String) is
    Num_String : constant String := Fixed_Strings.Trim (Natural'Image (Test_Number), Strings.Left);
  begin
    Test_Number := Test_Number + 1;
    IO.Put_Line ("[" & Num_String & "] Pass: " & Message);
  end Pass;

  procedure Check
    (Check   : in Boolean;
     Message : in String := "test failed") is
  begin
    if Check then
      Pass (Message);
    else
      Fail (1, Message);
    end if;
  end Check;

end UTest;
