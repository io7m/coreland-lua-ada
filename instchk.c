#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "install.h"

const char progname[] = "instchk";

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
main (void)
{
  unsigned long i;
  struct install_status_t status;

  status = install_init ();
  if (status.status != INSTALL_STATUS_OK) {
    printf ("%s: fatal: init: %s - %s\n", progname,
      status.message, install_error (errno));
    exit (112);
  }

  install_callback_warn_set (cb_warn);
  install_callback_info_set (cb_info);

  for (i = 0; i < insthier_len; ++i) {
    status = install_check (&insthier[i]);
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
  }

  if (install_failed) {
    fprintf (stderr, "%s: %lu of %lu files failed\n", progname,
      install_failed, insthier_len);
    return 1;
  }
  return 0;
}
