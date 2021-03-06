/*
 * Auto generated - do not edit.
 */

#include <stdio.h>

const char *var = "UNKNOWN";

int main(void)
{
  var = "UNKNOWN";
#if defined(___TOS_AIX__)
  var = "AIX";
#endif
#if defined(AMIGA) || defined(__amigaos__)
  var = "AMIGAOS";
#endif
#if defined(__BEOS__)
  var = "BEOS";
#endif
#if defined(__bsdi__)
  var = "BSD_OS";
#endif
#if defined(_UNICOS)
  var = "CRAY_UNICOS";
#endif
#if defined(__APPLE__) || defined(__MACH__)
  var = "DARWIN";
#endif
#if defined(DGUX) || defined(__DGUX__) || defined(__dgux__)
  var = "DG_UX";
#endif
#if defined(__DragonFly__)
  var = "DRAGONFLY";
#endif
#if defined(_SEQUENT_) || defined(sequent)
  var = "DYNIX_PTX";
#endif
#if defined(__FreeBSD__)
  var = "FREEBSD";
#endif
#if defined(__GNU__)
  var = "GNU_HURD";
#endif
#if defined(__HAIKU__)
  var = "HAIKU";
#endif
#if defined(__hiuxmpp)
  var = "HI_UX_MPP";
#endif
#if defined(_hpux) || defined(hpux) || defined(__hpux)
  var = "HPUX";
#endif
#if defined(sgi) || defined(__sgi)
  var = "IRIX";
#endif
#if defined(linux) || defined(__linux)
  var = "LINUX";
#endif
#if defined(__Lynx__)
  var = "LYNXOS";
#endif
#if defined(macintosh) || defined(Macintosh)
  var = "MACOS";
#endif
#if defined(__OS9000) || defined(_OSK)
  var = "MICROWARE_OS_9";
#endif
#if defined(__minix)
  var = "MINIX";
#endif
#if defined(mpeix) || defined(__mpexl)
  var = "MPE_IX";
#endif
#if defined(__MSDOS__) || defined(___DOS__)
  var = "MSDOS";
#endif
#if defined(_WIN32) || defined(_WIN64) || defined(__WIN32__) || defined(__WIN64__) || defined(__TOS_WIN__)
  var = "MS_WINDOWS";
#endif
#if defined(__NetBSD__)
  var = "NETBSD";
#endif
#if defined(__OpenBSD__)
  var = "OPENBSD";
#endif
#if defined(___OS2__) || defined(__TOS_OS2__)
  var = "OS2";
#endif
#if defined(pyr)
  var = "PYRAMID_DC_OS";
#endif
#if defined(__QNX__) || defined(__QNXNTO__)
  var = "QNX";
#endif
#if defined(sinux)
  var = "RELIANT_UNIX";
#endif
#if defined(M_XENIX) || defined(_SCO_DS)
  var = "SCO_OPENSERVER";
#endif
#if defined(sun) || defined(__sun)
  var = "SUNOS";
#endif
#if defined(__SYMBIAN32__)
  var = "SYMBIAN_OS";
#endif
#if defined(__osf__) || defined(__osf)
  var = "TRU64_OSF_1";
#endif
#if defined(ultrix) || defined(__ultrix) || defined(__ultrix__)
  var = "ULTRIX";
#endif
#if defined(sco) || defined(_UNIXWARE7)
  var = "UNIXWARE";
#endif
#if defined(____VMS_VER)
  var = "VMS";
#endif
#if defined(__MVS__) || defined(__HOS_MVS__) || defined(__TOS_MVS__)
  var = "Z_OS_OS390";
#endif

  printf("SD_SYSINFO_OS_%s\n", var);
  return 0;
}
