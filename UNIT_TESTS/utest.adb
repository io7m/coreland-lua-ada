with ada.text_io;
with ada.strings.fixed;
with ada.strings;
with interfaces.c;

package body utest is
  package io renames ada.text_io;
  package ic renames interfaces.c;
  package sf renames ada.strings.fixed;
  package s renames ada.strings;

  procedure sys_exit (ecode: ic.int);
  pragma import (c, sys_exit, "_exit");

  test_num: natural;

  procedure fail
    (exit_code : in integer;
     message   : in string)
  is
    nstr : constant string := sf.trim (natural'image (test_num), s.left);
  begin
    io.put_line ("[" & nstr & "] fail: " & message);
    sys_exit (ic.int (exit_code));
  end fail;

  procedure pass
    (message : in string)
  is
    nstr : constant string := sf.trim (natural'image (test_num), s.left);
  begin
    test_num := test_num + 1;
    io.put_line ("[" & nstr & "] pass: " & message);
  end pass;

  procedure check
    (check   : in boolean;
     message : in string := "test failed") is
  begin
    if check then
      pass (message);
    else
      fail (1, message);
    end if;
  end check;

end utest;
