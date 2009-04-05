package UTest is

  procedure Fail
    (Exit_Code : in Integer;
     Message   : in String);

  procedure Check
    (Check   : in Boolean;
     Message : in String := "test failed");

end UTest;
