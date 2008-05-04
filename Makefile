# auto generated - do not edit

default: all

all:\
UNIT_TESTS/execfile UNIT_TESTS/execfile.ali UNIT_TESTS/execfile.o\
UNIT_TESTS/execstring UNIT_TESTS/execstring.ali UNIT_TESTS/execstring.o\
UNIT_TESTS/loadbase UNIT_TESTS/loadbase.ali UNIT_TESTS/loadbase.o\
UNIT_TESTS/loadfile1 UNIT_TESTS/loadfile1.ali UNIT_TESTS/loadfile1.o\
UNIT_TESTS/loadfile2 UNIT_TESTS/loadfile2.ali UNIT_TESTS/loadfile2.o\
UNIT_TESTS/loadstring1 UNIT_TESTS/loadstring1.ali UNIT_TESTS/loadstring1.o\
UNIT_TESTS/loadstring2 UNIT_TESTS/loadstring2.ali UNIT_TESTS/loadstring2.o\
UNIT_TESTS/open UNIT_TESTS/open.ali UNIT_TESTS/open.o UNIT_TESTS/utest.ali\
UNIT_TESTS/utest.o ada-lua-conf ada-lua-conf.o ada-lua.a ctxt/bindir.o\
ctxt/ctxt.a ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o ctxt/slibdir.o\
ctxt/version.o deinstaller deinstaller.o inst-check inst-check.o inst-copy\
inst-copy.o inst-dir inst-dir.o inst-link inst-link.o install_core.o\
install_error.o installer installer.o instchk instchk.o insthier.o libada-lua.a\
lua-ext.o lua-lib.ali lua-lib.o lua-udata.ali lua-udata.o lua.ali lua.o

# Mkf-deinstall
deinstall: deinstaller inst-check inst-copy inst-dir inst-link
	./deinstaller
deinstall-dryrun: deinstaller inst-check inst-copy inst-dir inst-link
	./deinstaller dryrun

# Mkf-install
install: installer inst-check inst-copy inst-dir inst-link postinstall
	./installer
	./postinstall

install-dryrun: installer inst-check inst-copy inst-dir inst-link
	./installer dryrun

# Mkf-instchk
install-check: instchk inst-check
	./instchk

# Mkf-test
tests:
	(cd UNIT_TESTS && make)
tests_clean:
	(cd UNIT_TESTS && make clean)

UNIT_TESTS/execfile:\
ada-bind ada-link UNIT_TESTS/execfile.ald UNIT_TESTS/execfile.ali\
UNIT_TESTS/utest.ali lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/execfile.ali
	./ada-link UNIT_TESTS/execfile UNIT_TESTS/execfile.ali lua-ext.o

UNIT_TESTS/execfile.ali:\
ada-compile UNIT_TESTS/execfile.adb lua.ads lua-lib.ads
	./ada-compile UNIT_TESTS/execfile.adb

UNIT_TESTS/execfile.o:\
UNIT_TESTS/execfile.ali

UNIT_TESTS/execstring:\
ada-bind ada-link UNIT_TESTS/execstring.ald UNIT_TESTS/execstring.ali\
UNIT_TESTS/utest.ali lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/execstring.ali
	./ada-link UNIT_TESTS/execstring UNIT_TESTS/execstring.ali lua-ext.o

UNIT_TESTS/execstring.ali:\
ada-compile UNIT_TESTS/execstring.adb lua.ads lua-lib.ads
	./ada-compile UNIT_TESTS/execstring.adb

UNIT_TESTS/execstring.o:\
UNIT_TESTS/execstring.ali

UNIT_TESTS/loadbase:\
ada-bind ada-link UNIT_TESTS/loadbase.ald UNIT_TESTS/loadbase.ali\
UNIT_TESTS/utest.ali lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/loadbase.ali
	./ada-link UNIT_TESTS/loadbase UNIT_TESTS/loadbase.ali lua-ext.o

UNIT_TESTS/loadbase.ali:\
ada-compile UNIT_TESTS/loadbase.adb lua.ads lua-lib.ads
	./ada-compile UNIT_TESTS/loadbase.adb

UNIT_TESTS/loadbase.o:\
UNIT_TESTS/loadbase.ali

UNIT_TESTS/loadfile1:\
ada-bind ada-link UNIT_TESTS/loadfile1.ald UNIT_TESTS/loadfile1.ali\
UNIT_TESTS/utest.ali lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/loadfile1.ali
	./ada-link UNIT_TESTS/loadfile1 UNIT_TESTS/loadfile1.ali lua-ext.o

UNIT_TESTS/loadfile1.ali:\
ada-compile UNIT_TESTS/loadfile1.adb lua.ads lua-lib.ads
	./ada-compile UNIT_TESTS/loadfile1.adb

UNIT_TESTS/loadfile1.o:\
UNIT_TESTS/loadfile1.ali

UNIT_TESTS/loadfile2:\
ada-bind ada-link UNIT_TESTS/loadfile2.ald UNIT_TESTS/loadfile2.ali\
UNIT_TESTS/utest.ali lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/loadfile2.ali
	./ada-link UNIT_TESTS/loadfile2 UNIT_TESTS/loadfile2.ali lua-ext.o

UNIT_TESTS/loadfile2.ali:\
ada-compile UNIT_TESTS/loadfile2.adb lua.ads lua-lib.ads
	./ada-compile UNIT_TESTS/loadfile2.adb

UNIT_TESTS/loadfile2.o:\
UNIT_TESTS/loadfile2.ali

UNIT_TESTS/loadstring1:\
ada-bind ada-link UNIT_TESTS/loadstring1.ald UNIT_TESTS/loadstring1.ali\
UNIT_TESTS/utest.ali lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/loadstring1.ali
	./ada-link UNIT_TESTS/loadstring1 UNIT_TESTS/loadstring1.ali lua-ext.o

UNIT_TESTS/loadstring1.ali:\
ada-compile UNIT_TESTS/loadstring1.adb lua.ads lua-lib.ads
	./ada-compile UNIT_TESTS/loadstring1.adb

UNIT_TESTS/loadstring1.o:\
UNIT_TESTS/loadstring1.ali

UNIT_TESTS/loadstring2:\
ada-bind ada-link UNIT_TESTS/loadstring2.ald UNIT_TESTS/loadstring2.ali\
UNIT_TESTS/utest.ali lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/loadstring2.ali
	./ada-link UNIT_TESTS/loadstring2 UNIT_TESTS/loadstring2.ali lua-ext.o

UNIT_TESTS/loadstring2.ali:\
ada-compile UNIT_TESTS/loadstring2.adb lua.ads lua-lib.ads
	./ada-compile UNIT_TESTS/loadstring2.adb

UNIT_TESTS/loadstring2.o:\
UNIT_TESTS/loadstring2.ali

UNIT_TESTS/open:\
ada-bind ada-link UNIT_TESTS/open.ald UNIT_TESTS/open.ali UNIT_TESTS/utest.ali\
lua.ali lua-lib.ali lua-ext.o
	./ada-bind UNIT_TESTS/open.ali
	./ada-link UNIT_TESTS/open UNIT_TESTS/open.ali lua-ext.o

UNIT_TESTS/open.ali:\
ada-compile UNIT_TESTS/open.adb lua.ads
	./ada-compile UNIT_TESTS/open.adb

UNIT_TESTS/open.o:\
UNIT_TESTS/open.ali

UNIT_TESTS/utest.ali:\
ada-compile UNIT_TESTS/utest.adb
	./ada-compile UNIT_TESTS/utest.adb

UNIT_TESTS/utest.o:\
UNIT_TESTS/utest.ali

ada-bind:\
conf-adabind conf-systype conf-adatype conf-adafflist flags-cwd

ada-compile:\
conf-adacomp conf-adatype conf-systype conf-adacflags conf-adafflist flags-cwd

ada-link:\
conf-adalink conf-adatype conf-systype conf-aldfflist libs-lua libs-math\
	libs-cwd

ada-lua-conf:\
cc-link ada-lua-conf.ld ada-lua-conf.o ctxt/ctxt.a
	./cc-link ada-lua-conf ada-lua-conf.o ctxt/ctxt.a

ada-lua-conf.o:\
cc-compile ada-lua-conf.c ctxt.h
	./cc-compile ada-lua-conf.c

ada-lua.a:\
cc-slib ada-lua.sld lua-lib.o lua-udata.o lua.o lua-ext.o
	./cc-slib ada-lua lua-lib.o lua-udata.o lua.o lua-ext.o

ada-srcmap:\
conf-adacomp conf-adatype conf-systype

ada-srcmap-all:\
ada-srcmap conf-adacomp conf-adatype conf-systype

cc-compile:\
conf-cc conf-cctype conf-systype conf-cflags conf-ccfflist flags-lua

cc-link:\
conf-ld conf-ldtype conf-systype conf-ldfflist libs-lua

cc-slib:\
conf-systype

conf-adatype:\
mk-adatype
	./mk-adatype > conf-adatype.tmp && mv conf-adatype.tmp conf-adatype

conf-cctype:\
conf-cc conf-cc mk-cctype
	./mk-cctype > conf-cctype.tmp && mv conf-cctype.tmp conf-cctype

conf-ldtype:\
conf-ld conf-ld mk-ldtype
	./mk-ldtype > conf-ldtype.tmp && mv conf-ldtype.tmp conf-ldtype

conf-sosuffix:\
mk-sosuffix
	./mk-sosuffix > conf-sosuffix.tmp && mv conf-sosuffix.tmp conf-sosuffix

conf-systype:\
mk-systype
	./mk-systype > conf-systype.tmp && mv conf-systype.tmp conf-systype

# ctxt/bindir.c.mff
ctxt/bindir.c: mk-ctxt conf-bindir
	rm -f ctxt/bindir.c
	./mk-ctxt ctxt_bindir < conf-bindir > ctxt/bindir.c

ctxt/bindir.o:\
cc-compile ctxt/bindir.c
	./cc-compile ctxt/bindir.c

ctxt/ctxt.a:\
cc-slib ctxt/ctxt.sld ctxt/bindir.o ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o\
ctxt/slibdir.o ctxt/version.o
	./cc-slib ctxt/ctxt ctxt/bindir.o ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o\
	ctxt/slibdir.o ctxt/version.o

# ctxt/dlibdir.c.mff
ctxt/dlibdir.c: mk-ctxt conf-dlibdir
	rm -f ctxt/dlibdir.c
	./mk-ctxt ctxt_dlibdir < conf-dlibdir > ctxt/dlibdir.c

ctxt/dlibdir.o:\
cc-compile ctxt/dlibdir.c
	./cc-compile ctxt/dlibdir.c

# ctxt/incdir.c.mff
ctxt/incdir.c: mk-ctxt conf-incdir
	rm -f ctxt/incdir.c
	./mk-ctxt ctxt_incdir < conf-incdir > ctxt/incdir.c

ctxt/incdir.o:\
cc-compile ctxt/incdir.c
	./cc-compile ctxt/incdir.c

# ctxt/repos.c.mff
ctxt/repos.c: mk-ctxt conf-repos
	rm -f ctxt/repos.c
	./mk-ctxt ctxt_repos < conf-repos > ctxt/repos.c

ctxt/repos.o:\
cc-compile ctxt/repos.c
	./cc-compile ctxt/repos.c

# ctxt/slibdir.c.mff
ctxt/slibdir.c: mk-ctxt conf-slibdir
	rm -f ctxt/slibdir.c
	./mk-ctxt ctxt_slibdir < conf-slibdir > ctxt/slibdir.c

ctxt/slibdir.o:\
cc-compile ctxt/slibdir.c
	./cc-compile ctxt/slibdir.c

# ctxt/version.c.mff
ctxt/version.c: mk-ctxt VERSION
	rm -f ctxt/version.c
	./mk-ctxt ctxt_version < VERSION > ctxt/version.c

ctxt/version.o:\
cc-compile ctxt/version.c
	./cc-compile ctxt/version.c

deinstaller:\
cc-link deinstaller.ld deinstaller.o insthier.o install_core.o install_error.o\
ctxt/ctxt.a
	./cc-link deinstaller deinstaller.o insthier.o install_core.o install_error.o\
	ctxt/ctxt.a

deinstaller.o:\
cc-compile deinstaller.c install.h
	./cc-compile deinstaller.c

inst-check:\
cc-link inst-check.ld inst-check.o install_error.o
	./cc-link inst-check inst-check.o install_error.o

inst-check.o:\
cc-compile inst-check.c install.h
	./cc-compile inst-check.c

inst-copy:\
cc-link inst-copy.ld inst-copy.o install_error.o
	./cc-link inst-copy inst-copy.o install_error.o

inst-copy.o:\
cc-compile inst-copy.c install.h
	./cc-compile inst-copy.c

inst-dir:\
cc-link inst-dir.ld inst-dir.o install_error.o
	./cc-link inst-dir inst-dir.o install_error.o

inst-dir.o:\
cc-compile inst-dir.c install.h
	./cc-compile inst-dir.c

inst-link:\
cc-link inst-link.ld inst-link.o install_error.o
	./cc-link inst-link inst-link.o install_error.o

inst-link.o:\
cc-compile inst-link.c install.h
	./cc-compile inst-link.c

install_core.o:\
cc-compile install_core.c install.h
	./cc-compile install_core.c

install_error.o:\
cc-compile install_error.c install.h
	./cc-compile install_error.c

installer:\
cc-link installer.ld installer.o insthier.o install_core.o install_error.o\
ctxt/ctxt.a
	./cc-link installer installer.o insthier.o install_core.o install_error.o\
	ctxt/ctxt.a

installer.o:\
cc-compile installer.c install.h
	./cc-compile installer.c

instchk:\
cc-link instchk.ld instchk.o insthier.o install_core.o install_error.o\
ctxt/ctxt.a
	./cc-link instchk instchk.o insthier.o install_core.o install_error.o\
	ctxt/ctxt.a

instchk.o:\
cc-compile instchk.c install.h
	./cc-compile instchk.c

insthier.o:\
cc-compile insthier.c ctxt.h install.h
	./cc-compile insthier.c

libada-lua.a:\
cc-slib libada-lua.sld lua-ext.o lua-lib.o lua-udata.o lua.o
	./cc-slib libada-lua lua-ext.o lua-lib.o lua-udata.o lua.o

lua-ext.o:\
cc-compile lua-ext.c
	./cc-compile lua-ext.c

lua-lib.ads:\
lua.ads

lua-lib.ali:\
ada-compile lua-lib.adb lua-lib.ads
	./ada-compile lua-lib.adb

lua-lib.o:\
lua-lib.ali

lua-udata.ads:\
lua.ads lua-lib.ads

lua-udata.ali:\
ada-compile lua-udata.adb lua-udata.ads
	./ada-compile lua-udata.adb

lua-udata.o:\
lua-udata.ali

lua.ali:\
ada-compile lua.adb lua.ads
	./ada-compile lua.adb

lua.o:\
lua.ali

mk-adatype:\
conf-adacomp conf-systype

mk-cctype:\
conf-cc conf-systype

mk-ctxt:\
mk-mk-ctxt
	./mk-mk-ctxt

mk-ldtype:\
conf-ld conf-systype conf-cctype

mk-mk-ctxt:\
conf-cc

mk-sosuffix:\
conf-systype

mk-systype:\
conf-cc

clean-all: tests_clean obj_clean ext_clean
clean: obj_clean
obj_clean:
	rm -f UNIT_TESTS/execfile UNIT_TESTS/execfile.ali UNIT_TESTS/execfile.o\
	UNIT_TESTS/execstring UNIT_TESTS/execstring.ali UNIT_TESTS/execstring.o\
	UNIT_TESTS/loadbase UNIT_TESTS/loadbase.ali UNIT_TESTS/loadbase.o\
	UNIT_TESTS/loadfile1 UNIT_TESTS/loadfile1.ali UNIT_TESTS/loadfile1.o\
	UNIT_TESTS/loadfile2 UNIT_TESTS/loadfile2.ali UNIT_TESTS/loadfile2.o\
	UNIT_TESTS/loadstring1 UNIT_TESTS/loadstring1.ali UNIT_TESTS/loadstring1.o\
	UNIT_TESTS/loadstring2 UNIT_TESTS/loadstring2.ali UNIT_TESTS/loadstring2.o\
	UNIT_TESTS/open UNIT_TESTS/open.ali UNIT_TESTS/open.o UNIT_TESTS/utest.ali\
	UNIT_TESTS/utest.o ada-lua-conf ada-lua-conf.o ada-lua.a ctxt/bindir.c\
	ctxt/bindir.o ctxt/ctxt.a ctxt/dlibdir.c ctxt/dlibdir.o ctxt/incdir.c\
	ctxt/incdir.o ctxt/repos.c ctxt/repos.o ctxt/slibdir.c ctxt/slibdir.o\
	ctxt/version.c ctxt/version.o deinstaller deinstaller.o inst-check inst-check.o\
	inst-copy inst-copy.o inst-dir inst-dir.o inst-link inst-link.o install_core.o\
	install_error.o installer installer.o instchk instchk.o insthier.o libada-lua.a\
	lua-ext.o lua-lib.ali lua-lib.o lua-udata.ali lua-udata.o lua.ali lua.o
ext_clean:
	rm -f conf-adatype conf-cctype conf-ldtype conf-sosuffix conf-systype mk-ctxt

regen:
	./ada-srcmap-all
	cpj-genmk > Makefile.tmp && mv Makefile.tmp Makefile
