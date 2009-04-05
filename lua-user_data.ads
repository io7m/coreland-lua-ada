-- Lua userdata handling

with System.Address_To_Access_Conversions;
with Lua;
with Lua.Lib;

generic
  type User_Data_t is private;
  Class_Name   : String;
  Method_Table : Lua.Lib.Register_Array_t;
  Meta_Table   : Lua.Lib.Register_Array_t;

package Lua.User_Data is

  type User_Data_Access_t is access all User_Data_t;

  procedure Register (State : Lua.State_t);

  procedure Push
    (State : Lua.State_t;
     Item  : User_Data_t);

  function Get
    (State : Lua.State_t;
     Index : Integer := 1) return User_Data_t;
  pragma Inline (Get);

private
  package Convert is new System.Address_To_Access_Conversions (User_Data_t);
end Lua.User_Data;
