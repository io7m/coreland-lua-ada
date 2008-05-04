#include "ctxt.h"
#include "install.h"

struct install_item insthier[] = {
  {INST_MKDIR, 0, 0, ctxt_bindir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_incdir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_dlibdir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_slibdir, 0, 0, 0755},
  {INST_MKDIR, 0, 0, ctxt_repos, 0, 0, 0755},
  {INST_COPY, "ada-lua-conf.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua-ext.c", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "lua.ads", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "lua.ali", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "lua-lib.ads", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "lua-lib.ali", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "lua-udata.ads", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "lua-udata.ali", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "lua-udata.adb", 0, ctxt_incdir, 0, 0, 0444},
  {INST_COPY, "ada-lua.sld", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "ada-lua.a", "libada-lua.a", ctxt_slibdir, 0, 0, 0644},
  {INST_COPY, "ada-lua-conf.ld", 0, ctxt_repos, 0, 0, 0644},
  {INST_COPY, "ada-lua-conf", 0, ctxt_bindir, 0, 0, 0755},
};
unsigned long insthier_len = sizeof(insthier) / sizeof(struct install_item);
