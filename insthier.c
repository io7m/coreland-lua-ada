#include "ctxt.h"
#include "install.h"

struct install_item insthier[] = {
  {INST_MKDIR, 0, 0, ctxt_repos, 0, 0, 0755},
  {INST_COPY, "deinstaller.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "generic-conf.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "install-error.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "install-posix.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "install-win32.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "install.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "installer.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "instchk.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "insthier.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "ctxt.h", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "install.h", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "install_os.h", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "install.sld", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "deinstaller.ld", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "installer.ld", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "instchk.ld", 0, ctxt_repos, 0, 0, 0644},
};
unsigned long insthier_len = sizeof(insthier) / sizeof(struct install_item);
