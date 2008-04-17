all: luatest lua.ali lua-lib.ali lua-udata.ali libada-lua

luatest: luatest.adb luatest.ali lua.ali lua-lib.ali lua-udata.ali lua-ext.o
	./ada-bind luatest.ali
	./ada-link luatest luatest.ali lua-ext.o

luatest.ali: luatest.o
luatest.o: luatest.adb
	./ada-compile luatest.adb

lua.ali: lua.o
lua.o: lua.adb lua.ads
	./ada-compile lua.adb

lua-lib.ali: lua-lib.o
lua-lib.o: lua-lib.adb lua-lib.ads
	./ada-compile lua-lib.adb

lua-udata.ali: lua-udata.o
lua-udata.o: lua-udata.adb lua-udata.ads
	./ada-compile lua-udata.adb

lua-ext.o: lua-ext.c
	./cc-compile lua-ext.c

libada-lua: libada-lua.sld lua-ext.o lua-lib.o lua-udata.o lua.o
	./cc-slib libada-lua lua-ext.o lua-lib.o lua-udata.o lua.o

clean:
	rm -f *.o *.ali b~*.ad* luatest *.a
