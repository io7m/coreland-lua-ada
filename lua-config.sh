#!/bin/sh

fatal()
{
  echo "fatal: $1" 1>&2
  exit 1
}

ret_text=`./lua-check-exception 2>&1`
ret_code=$?
if [ $ret_code -eq 0 ]
then
  can_catch="True"
else
  can_catch="False"
fi

cat <<EOF
package Lua.Config is

  Can_Propagate_Exceptions : constant Boolean := ${can_catch};

end Lua.Config;
EOF

exit 0
