#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "install.h"

const char progname[] = "deinstaller";

void
cb_info (const char *str, void *data)
{
  fprintf (stderr, "%s\n", str);
}

void
cb_warn (const char *str, void *data)
{
  fprintf (stderr, "%s: warning: %s\n", progname, str);
}

int
main (int argc, char *argv[])
{
  unsigned long i;
  unsigned int flag;
  struct install_status_t status;

  argv = 0;

  status = install_init ("conf-sosuffix");
  if (status.status != INSTALL_STATUS_OK) {
    fprintf (stderr, "%s: fatal: init: %s - %s\n", progname,
      status.message, install_error (errno));
    exit (112);
  }

  install_callback_warn_set (cb_warn);
  install_callback_info_set (cb_info);

  flag = (argc > 1) ? INSTALL_DRYRUN : 0;
  for (i = insthier_len - 1;; --i) {
    status = deinstall (&insthier[i], flag);
    switch (status.status) {
      case INSTALL_STATUS_OK:
        break;
      case INSTALL_STATUS_ERROR:
        fprintf (stderr, "%s: error: %s - %s\n", progname,
          status.message, install_error (errno));
        break;
      case INSTALL_STATUS_FATAL:
        fprintf (stderr, "%s: fatal: %s - %s\n", progname,
          status.message, install_error (errno));
        exit (112);
        break;
    }
    if (i == 0) break;
  }

  return 0;
}
