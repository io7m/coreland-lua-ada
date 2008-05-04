package utest is
  procedure fail (exit_code: integer; msg: string);
  procedure check (cond: boolean; msg: string := "test failed");
end utest;
