generic
  type user_data is limited private;

package lua.load_typed is

  function load
    (state      : state_t;
     reader     : chunk_reader_t;
     data       : access user_data;
     chunk_name : string) return error_t;
  pragma inline (load);

end lua.load_typed;
