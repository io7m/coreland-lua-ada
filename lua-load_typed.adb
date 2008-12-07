package body lua.load_typed is

  package cbinds is
    function lua_load
      (state      : state_t;
       reader     : chunk_reader_t;
       data       : access user_data;
       chunk_name : ics.chars_ptr) return ic.int;
    pragma import (c, lua_load, "lua_load");
  end cbinds;

  function load
    (state      : state_t;
     reader     : chunk_reader_t;
     data       : access user_data;
     chunk_name : string) return error_t
  is
    c_chunk_name : aliased ic.char_array := ic.to_c (chunk_name);
  begin
    return error_t'val (cbinds.lua_load
      (state      => state,
       reader     => reader,
       data       => data,
       chunk_name => ics.to_chars_ptr (c_chunk_name'unchecked_access)));
  end load;

end lua.load_typed;
