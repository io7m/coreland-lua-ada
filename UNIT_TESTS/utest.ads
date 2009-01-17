package utest is
  procedure fail
    (exit_code : in integer;
     message   : in string);

  procedure check
    (check   : in boolean;
     message : in string := "test failed");
end utest;
