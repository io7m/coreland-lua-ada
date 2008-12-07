#include <errno.h>
#include <stdio.h>
#include <string.h>

#include <sys/types.h>
#include <sys/stat.h>

#define INSTALL_IMPLEMENTATION
#include "install.h"

char inst_exec_suffix [16];
char inst_dlib_suffix [16];
unsigned long install_failed;

void (*install_callback_warn)(const char *, void *);
void (*install_callback_info)(const char *, void *);
void *install_callback_data;

#ifdef INSTALL_HAVE_SYMLINKS
static int have_symlinks = 1;
#else
static int have_symlinks = 0;
#endif

/* credential functions */

int
install_file_set_ownership (const char *file, user_id_t uid, group_id_t gid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_file_set_ownership (file, uid, gid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_file_set_ownership (file, uid, gid);
#endif
}

int
install_file_get_ownership (const char *file, user_id_t *uid, group_id_t *gid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_file_get_ownership (file, uid, gid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_file_get_ownership (file, uid, gid);
#endif
}

int
install_file_get_mode (const char *file, permissions_t *mode)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_file_get_mode (file, mode);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_file_get_mode (file, mode);
#endif
}

int
install_file_link (const char *src, const char *dst)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_file_link (src, dst);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_file_link (src, dst);
#endif
}

int
install_gid_current (group_id_t *gid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_gid_current (gid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_gid_current (gid);
#endif
}

int
install_uid_current (user_id_t *uid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_uid_current (uid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_uid_current (uid);
#endif
}

int
install_gid_lookup (const char *name, group_id_t *gid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_gid_lookup (name, gid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_gid_lookup (name, gid);
#endif
}

int
install_uid_lookup (const char *name, user_id_t *uid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_uid_lookup (name, uid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_uid_lookup (name, uid);
#endif
}

unsigned int
install_fmt_gid (char *buffer, group_id_t gid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_fmt_gid (buffer, gid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_fmt_gid (buffer, gid);
#endif
}

unsigned int
install_fmt_uid (char *buffer, user_id_t uid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_fmt_uid (buffer, uid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_fmt_uid (buffer, uid);
#endif
}

unsigned int
install_scan_gid (const char *buffer, group_id_t *gid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_scan_gid (buffer, gid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_scan_gid (buffer, gid);
#endif
}

unsigned int
install_scan_uid (const char *buffer, user_id_t *uid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_scan_uid (buffer, uid);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_scan_uid (buffer, uid);
#endif
}

int
install_compare_uid (user_id_t a, user_id_t b)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_compare_uid (a, b);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_compare_uid (a, b);
#endif
}

int
install_compare_gid (group_id_t a, group_id_t b)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_compare_gid (a, b);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_compare_gid (a, b);
#endif
}

void
install_gid_free (group_id_t *gid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  iwin32_gid_free (gid);
#endif
}

void
install_uid_free (user_id_t *uid)
{
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  iwin32_uid_free (uid);
#endif
}

int
install_compare_permissions (permissions_t a, permissions_t b)
{
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return 1;
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return a.value == b.value;
#endif
}

/* portability macro */
#ifndef S_ISSOCK
#  if defined(S_IFMT) && defined(S_IFSOCK)
#    define S_ISSOCK(mode) (((mode) & S_IFMT) == S_IFSOCK)
#  else
#    define S_ISSOCK(mode) (0)
#  endif
#endif

int s_ifreg (unsigned int m)  { return S_ISREG(m); }
int s_ifchr (unsigned int m)  { return S_ISCHR(m); }
int s_ifdir (unsigned int m)  { return S_ISDIR(m); }
int s_ifsock (unsigned int m) { return S_ISSOCK(m); }
int s_ififo (unsigned int m)  { return S_ISFIFO(m); }

#ifdef INSTALL_HAVE_SYMLINKS
int s_iflnk (unsigned int m)  { return S_ISLNK(m); }
#else
int s_iflnk (unsigned int m)  { return 0; }
#endif

static const struct {
  int (*check)(unsigned int);
  const char *name;
  const enum install_file_type_t type;
} file_type_lookups [] = {
  { &s_ifreg,  "file",              INSTALL_FILE_TYPE_FILE },
  { &s_ifchr,  "character_special", INSTALL_FILE_TYPE_CHARACTER_SPECIAL },
  { &s_ifdir,  "directory",         INSTALL_FILE_TYPE_DIRECTORY },
  { &s_iflnk,  "symlink",           INSTALL_FILE_TYPE_SYMLINK },
  { &s_ifsock, "socket",            INSTALL_FILE_TYPE_SOCKET },
  { &s_ififo,  "fifo",              INSTALL_FILE_TYPE_FIFO },
};
static const unsigned int file_type_lookups_size =
  sizeof (file_type_lookups) / sizeof (file_type_lookups [0]);

int
install_file_type (const char *file, enum install_file_type_t *type, int nofollow)
{
  struct stat sb;
  unsigned int index;

#ifdef INSTALL_HAVE_SYMLINKS
  if (nofollow) {
    if (lstat (file, &sb) == -1) return 0;
  } else {
    if (stat (file, &sb) == -1) return 0;
  }
#else
  if (stat (file, &sb) == -1) return 0;
#endif

  for (index = 0; index < file_type_lookups_size; ++index) {
    if (file_type_lookups [index].check (sb.st_mode)) {
      *type = file_type_lookups [index].type;
      return 1;
    }
  }
  return 0;
}

int
install_file_type_lookup (const char *type_name, enum install_file_type_t *type)
{
  unsigned int index;
  for (index = 0; index < file_type_lookups_size; ++index) {
    if (strcmp (file_type_lookups [index].name, type_name) == 0) {
      *type = file_type_lookups [index].type;
      return 1;
    }
  }
  return 0;
}

int
install_file_type_name_lookup (enum install_file_type_t type, const char **name)
{
  unsigned int index;
  for (index = 0; index < file_type_lookups_size; ++index) {
    if (file_type_lookups [index].type == type) {
      *name = file_type_lookups [index].name;
      return 1;
    }
  }
  return 0;
}

int
install_file_set_mode (const char *file, permissions_t mode)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_file_set_mode (file, mode);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_file_set_mode (file, mode);
#endif
}

struct install_status_t
install_file_copy (const char *src, const char *dst,
  user_id_t uid, group_id_t gid, permissions_t mode)
{
  static char dst_tmp [INSTALL_MAX_PATHLEN];
  static char copy_buf [65536];
  FILE *fd_src;
  FILE *fd_dst;
  size_t r;
  size_t w;
  struct install_status_t status = INSTALL_STATUS_INIT;

  status.status = INSTALL_STATUS_ERROR;

  if (snprintf (dst_tmp, sizeof (dst_tmp), "%s.tmp", dst) < 0) {
    status.message = "could not format string";
    return status;
  }

  fd_src = fopen (src, "rb");
  if (fd_src == NULL) {
    status.message = "could not open source file";
    return status;
  }
  fd_dst = fopen (dst_tmp, "wb");
  if (fd_dst == NULL) {
    status.message = "could not open destination file";
    goto ERR;
  }

  for (;;) {
    r = fread (copy_buf, 1, sizeof (copy_buf), fd_src);
    if (r == 0) {
      if (feof (fd_src)) break;
      if (ferror (fd_src)) {
        status.message = "read error";
        goto ERR;
      }
    }
    while (r) {
      w = fwrite (copy_buf, 1, r, fd_dst);
      if (w == 0) {
        if (feof (fd_src)) break;
        if (ferror (fd_src)) {
          status.message = "write error";
          goto ERR;
        }
      }
      r -= w;
    }
  }

  if (fflush (fd_dst) != 0) { status.message = "write error"; goto ERR; }
  if (!install_file_set_mode (dst_tmp, mode)) {
    status.message = "could not set file permissions";
    goto ERR;
  }
  if (!install_file_set_ownership (dst_tmp, uid, gid)) {
    status.message = "could not set file ownership";
    goto ERR;
  }
  if (fclose (fd_dst) == -1) {
    status.message = "could not close destination file";
    goto ERR;
  }
  if (fclose (fd_src) == -1) {
    status.message = "could not close source file";
    goto ERR;
  }
  if (rename (dst_tmp, dst) == -1) {
    status.message = "could not rename temporary file";
    goto ERR;
  }

  status.status = INSTALL_STATUS_OK;
  return status;

  ERR:
  fclose (fd_dst);
  fclose (fd_src);
  unlink (dst_tmp);
  return status;
}

int
install_file_size (const char *file, unsigned long *size)
{
  struct stat sb;

  if (stat (file, &sb) == -1) return 0;

  *size = sb.st_size;
  return 1;
}

struct install_status_t
install_uidgid_lookup (const char *user, user_id_t *uid,
  const char *group, group_id_t *gid)
{
  struct install_status_t status = INSTALL_STATUS_INIT;

  if (!install_uid_lookup (user, uid)) {
    status.message = "could not lookup user id";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }
  if (!install_gid_lookup (group, gid)) {
    status.message = "could not lookup group id";
    status.status = INSTALL_STATUS_ERROR;
    install_uid_free (uid);
    return status;
  }

  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
install_file_check (const char *file_src, permissions_t mode_want,
  enum install_file_type_t type_want, user_id_t uid_want, group_id_t gid_want,
  const char *file_dst)
{
  static char msg_buffer [INSTALL_MAX_MSGLEN];
  static char uid_want_str [INSTALL_FMT_UID];
  static char uid_got_str [INSTALL_FMT_UID];
  static char gid_want_str [INSTALL_FMT_GID];
  static char gid_got_str [INSTALL_FMT_GID];
  user_id_t uid_got;
  group_id_t gid_got;
  enum install_file_type_t type_got;
  permissions_t mode_got;
  const char *type_got_name;
  const char *type_want_name;
  unsigned long size_got = 0;
  unsigned long size_want = 0;
  int no_follow;
  struct install_status_t status = INSTALL_STATUS_INIT;

  /* reset errno */
  errno = 0;

  /* get source file types and type names */
  no_follow = (type_want == INSTALL_FILE_TYPE_SYMLINK) ? 1 : 0;
  if (!install_file_type_name_lookup (type_want, &type_want_name)) {
    status.message = "unknown source filetype";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }

  /* get source file size, if necessary */
  if (type_want == INSTALL_FILE_TYPE_FILE)
    install_file_size (file_src, &size_want);

  /* format ownership data */
  uid_want_str [install_fmt_uid (uid_want_str, uid_want)] = 0;
  gid_want_str [install_fmt_gid (gid_want_str, gid_want)] = 0;

  /* call info callback if defined */
  if (install_callback_info) {
    snprintf (msg_buffer, sizeof (msg_buffer), "check %s %s %s %s %o %s %lu",
      file_src, file_dst, uid_want_str, gid_want_str, mode_want.value,
      type_want_name, size_want);
    install_callback_info (msg_buffer, install_callback_data);
  }

  /* check file type */
  if (!install_file_type (file_dst, &type_got, no_follow)) {
    status.message = "could not determine destination file type";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }
  if (!install_file_type_name_lookup (type_got, &type_got_name)) {
    status.message = "unknown destination filetype";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }

  if ((!have_symlinks) && (type_want != INSTALL_FILE_TYPE_SYMLINK)) {
    if (type_want != type_got) {
      snprintf (msg_buffer, sizeof (msg_buffer), "filetype %s not %s",
        type_got_name, type_want_name);
      status.message = msg_buffer;
      status.status = INSTALL_STATUS_ERROR;
      return status;
    }
  }

  /* check file size */
  if (type_want == INSTALL_FILE_TYPE_FILE) {
    if (!install_file_size (file_dst, &size_got)) {
      status.message = "could not determine destination file size";
      status.status = INSTALL_STATUS_ERROR;
      return status;
    }
    if (size_want != size_got) {
      snprintf (msg_buffer, sizeof (msg_buffer), "size %lu not %lu",
        size_got, size_want);
      status.message = msg_buffer;
      status.status = INSTALL_STATUS_ERROR;
      return status;
    }
  }

  /* check file permissions */
  if (!install_file_get_mode (file_dst, &mode_got)) {
    status.message = "could not determine destination file mode";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }

  if (!install_compare_permissions (mode_got, mode_want)) {
    snprintf (msg_buffer, sizeof (msg_buffer), "mode %o not %o",
      mode_got.value, mode_want.value);
    status.message = msg_buffer;
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }
 
  /* check file ownership */
  if (!install_file_get_ownership (file_dst, &uid_got, &gid_got)) {
    status.message = "could not determine destination file ownership";
    status.status = INSTALL_STATUS_ERROR;
    goto END;
  }
  uid_got_str [install_fmt_uid (uid_got_str, uid_got)] = 0;
  gid_got_str [install_fmt_gid (gid_got_str, gid_got)] = 0;

  if (!install_compare_uid (uid_want, uid_got)) {
    snprintf (msg_buffer, sizeof (msg_buffer), "uid %s not %s",
      uid_got_str, uid_want_str);
    status.message = msg_buffer;
    status.status = INSTALL_STATUS_ERROR;
    goto END;
  }
  if (!install_compare_gid (gid_want, gid_got)) {
    snprintf (msg_buffer, sizeof (msg_buffer), "gid %s not %s",
      gid_got_str, gid_want_str);
    status.message = msg_buffer;
    status.status = INSTALL_STATUS_ERROR;
    goto END;
  }

  status.status = INSTALL_STATUS_OK;
  END:
  install_uid_free (&uid_got);
  install_gid_free (&gid_got);
  return status; 
}

unsigned int
install_umask (unsigned int m)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_umask (m);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_umask (m);
#endif
}

int
install_mkdir (const char *dir, unsigned int mode)
{
#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_mkdir (dir, mode);
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_mkdir (dir, mode);
#endif
}

int
install_rmkdir (const char *dir, unsigned int perm)
{
  char path_buf [INSTALL_MAX_PATHLEN];
  unsigned int len;
  unsigned int pos;
  unsigned int buflen;
  unsigned int bufpos;
  int end;
  const char *ptr;
  char *ptr2;

  buflen = sizeof (path_buf);
  bufpos = 0;
  end = 0;
  len = strlen (dir);
  ptr = dir;

  if (len >= sizeof (path_buf)) { errno = ENAMETOOLONG; return 0; }

  for (;;) {
    if (!len) break;
    ptr2 = strchr (ptr, '/');
    if (!ptr2) {
      pos = len;
      end = 1;
    } else pos = ptr2 - ptr;
    if (buflen <= (unsigned int) pos + 1) break;
    memcpy (path_buf + bufpos, ptr, pos);
    bufpos += pos;
    buflen -= pos;
    path_buf [bufpos] = '/';
    ++bufpos;
    --buflen;
    path_buf [bufpos] = 0;
    if (install_mkdir (path_buf, perm) == -1) {
      if (!end) {
        if (errno != EEXIST && errno != EISDIR) return 0;
      } else return 0;
    }
    ptr += pos;
    len -= pos;
    if (len) {
      ++ptr;
      --len;
      if (!len) break;
    }
  }

  return 1;
}

/* portability functions */

int
base_name (const char *dir, char **out)
{
  static char path_buf [INSTALL_MAX_PATHLEN];
  const char *s;
  const char *t;
  const char *u;
  unsigned int len;
  unsigned int nlen;

  len = strlen (dir); 

  if (!len) {
    path_buf [0] = '.';
    path_buf [1] = 0;
    *out = path_buf;
    return 1;
  }

  if (len >= INSTALL_MAX_PATHLEN) return 0;

  s = dir;
  t = s + (len - 1);
  while ((t > s) && (t [0] == '/')) --t;

  if ((t == s) && (t [0] == '/')) {
    path_buf [0] = '/';
    path_buf [1] = 0;
    *out = path_buf;
    return 1;
  }
  u = t;
  while ((u > s) && (*(u - 1) != '/')) --u;

  nlen = (t - u) + 1;
  memcpy (path_buf, u, nlen);
  path_buf [nlen] = 0;

  *out = path_buf;
  return 1;
}

int
str_same (const char *a, const char *b)
{
  return strcmp (a, b) == 0;
}

int
str_ends (const char *s, const char *end)
{
  register unsigned long slen = strlen (s);
  register unsigned long elen = strlen (end);

  if (elen > slen) elen = slen;
  s += (slen - elen);
  return str_same (s, end);
}

/* utilities */

int
libname (char *name, char *buf)
{
  static char read_buf [INSTALL_MAX_PATHLEN];
  FILE *fp;
  char *s;
  size_t r;
  int ret = 1;
  int clean;

  fp = fopen (name, "rb");
  if (fp == NULL) return 0;

  r = fread (read_buf, 1, INSTALL_MAX_PATHLEN, fp);
  if (r < INSTALL_MAX_PATHLEN) {
    if (ferror (fp)) {
      ret = 0;
      goto END;
    }
  }

  /* clean whitespace from buffer */
  s = read_buf;
  clean = 0;
  while (r) {
    switch (*s) {
      case ' ':
      case '\t':
      case '\n':
      case '\r':
        s [0] = 0;
        clean = 1;
        break;
      default:
        break;
    }
    if (clean) break;
    --r;
    ++s;
  }
  memcpy (buf, read_buf, s - read_buf);
  buf [s - read_buf] = 0;

  END:
  if (fclose (fp) != 0) return 0;
  return ret;
}

/* install operator callbacks */

struct install_status_t
inst_copy (struct install_item *ins, unsigned int flags)
{
  static char msg_buffer [INSTALL_MAX_MSGLEN];
  static char uid_str [INSTALL_FMT_UID];
  static char gid_str [INSTALL_FMT_GID];
  user_id_t uid;
  group_id_t gid;
  permissions_t perm = { ins->perm };
  unsigned long size = 0;
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = install_uidgid_lookup (ins->owner, &uid, ins->group, &gid);
  if (status.status != INSTALL_STATUS_OK) return status;

  install_file_size (ins->src, &size);

  uid_str [install_fmt_uid (uid_str, uid)] = 0;
  gid_str [install_fmt_gid (gid_str, gid)] = 0;

  /* call info callback */
  if (install_callback_info) {
    snprintf (msg_buffer, sizeof (msg_buffer), "copy %s %s %s %s %o %lu",
      ins->src, ins->dst, uid_str, gid_str, perm.value, size);
    install_callback_info (msg_buffer, install_callback_data);
  }

  if (!(flags & INSTALL_DRYRUN)) {
    status = install_file_copy (ins->src, ins->dst, uid, gid, perm);
    if (status.status != INSTALL_STATUS_OK) goto END;
  }

  status.status = INSTALL_STATUS_OK;

  END:
  install_uid_free (&uid);
  install_gid_free (&gid);
  return status;
}

struct install_status_t
inst_link (struct install_item *ins, unsigned int flags)
{
  static char msg_buffer [INSTALL_MAX_MSGLEN];
  static char path_buf [INSTALL_MAX_PATHLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  /* call info callback */
  if (install_callback_info) {
    snprintf (msg_buffer, sizeof (msg_buffer), "symlink %s %s",
      ins->src, ins->dst);
    install_callback_info (msg_buffer, install_callback_data);
  }

  if (!getcwd (path_buf, sizeof (path_buf))) {
    status.message = "could not get current working directory";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }
  if (chdir (ins->dir) == -1) {
    status.message = "could not change directory";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }
  if (!(flags & INSTALL_DRYRUN)) {
    if (!install_file_link (ins->src, ins->dst)) {
      if (chdir (path_buf) == -1) {
        status.message = "could not restore current working directory";
        status.status = INSTALL_STATUS_FATAL;
        return status;
      }
      status.message = "could not make symbolic link";
      status.status = INSTALL_STATUS_ERROR;
      return status;
    }
  }
  if (chdir (path_buf) == -1) {
    status.message = "could not restore current working directory";
    status.status = INSTALL_STATUS_FATAL;
    return status;
  }

  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
inst_mkdir (struct install_item *ins, unsigned int flags)
{
  static char msg_buffer [INSTALL_MAX_MSGLEN];
  static char uid_str [INSTALL_FMT_UID];
  static char gid_str [INSTALL_FMT_GID];
  user_id_t uid;
  group_id_t gid;
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = install_uidgid_lookup (ins->owner, &uid, ins->group, &gid);
  if (status.status != INSTALL_STATUS_OK) return status;

  uid_str [install_fmt_uid (uid_str, uid)] = 0;
  gid_str [install_fmt_gid (gid_str, gid)] = 0;

  /* call info callback */
  if (install_callback_info) {
    snprintf (msg_buffer, sizeof (msg_buffer), "mkdir %s %s %s %o", ins->dir,
      uid_str, gid_str, ins->perm);
    install_callback_info (msg_buffer, install_callback_data);
  }

  if (!(flags & INSTALL_DRYRUN)) {
    if (!install_rmkdir (ins->dir, ins->perm)) {
      status.message = "could not create directory";
      status.status = INSTALL_STATUS_ERROR;
      goto END;
    }
    if (!install_file_set_ownership (ins->dir, uid, gid)) {
      status.message = "could not set ownership on directory";
      status.status = INSTALL_STATUS_ERROR;
      goto END;
    }
  }

  status.status = INSTALL_STATUS_OK;

  END:
  install_uid_free (&uid);
  install_gid_free (&gid);
  return status;
}

struct install_status_t
inst_liblink (struct install_item *ins, unsigned int flags)
{
  return inst_link (ins, flags);
}

/*
 * name translation callbacks
 */

struct install_status_t
ntran_copy (struct install_item *ins)
{
  static char src_name [INSTALL_MAX_PATHLEN];
  static char dst_name [INSTALL_MAX_PATHLEN];
  static char dst_tmp [INSTALL_MAX_PATHLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  if (!ins->src) { status.message = "source file undefined"; return status; }
  if (!ins->dir) { status.message = "directory undefined"; return status; }
  if (!ins->dst) ins->dst = ins->src;

  if (str_ends (ins->src, ".vlb")) {
    if (!libname (ins->src, src_name)) {
      status.message = "could not build library name";
      return status;
    }
    ins->src = src_name;
  }
  if (str_ends (ins->dst, ".vlb")) {
    if (!libname (ins->dst, dst_name)) {
      status.message = "could not build library name";
      return status;
    }
    ins->dst = dst_name;
  }

  if (!base_name (ins->dst, &ins->dst)) {
    status.message = "invalid destination path";
    return status;
  }
  if (snprintf (dst_tmp, sizeof (dst_tmp), "%s/%s", ins->dir, ins->dst) < 0) {
    status.status = INSTALL_STATUS_ERROR;
    status.message = "could not format destination path";
    return status;
  }

  ins->dst = dst_tmp;

  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
ntran_copy_exec (struct install_item *ins)
{
  static char src_name [INSTALL_MAX_PATHLEN];
  static char dst_name [INSTALL_MAX_PATHLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = ntran_copy (ins);
  if (status.status != INSTALL_STATUS_OK) return status;

  if (snprintf (src_name, sizeof (src_name), "%s%s", ins->src, inst_exec_suffix) < 0) {
    status.status = INSTALL_STATUS_ERROR;
    status.message = "could not format source path";
    return status;
  }
  if (snprintf (dst_name, sizeof (dst_name), "%s%s", ins->dst, inst_exec_suffix) < 0) {
    status.status = INSTALL_STATUS_ERROR;
    status.message = "could not format destination path";
    return status;
  }

  ins->src = src_name;
  ins->dst = dst_name;

  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
ntran_link (struct install_item *ins)
{
  struct install_status_t status = INSTALL_STATUS_INIT;

  if (!ins->src) { status.message = "source file undefined"; return status; }
  if (!ins->dir) { status.message = "directory undefined"; return status; }
  if (!ins->dst) { status.message = "destination file undefined"; return status; }

  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
ntran_liblink (struct install_item *ins)
{
  static char dst_tmp [INSTALL_MAX_PATHLEN];
  static char src_name [INSTALL_MAX_PATHLEN];
  static char src_tmp [INSTALL_MAX_PATHLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  if (!ins->src) { status.message = "source file undefined"; return status; }
  if (!ins->dir) { status.message = "directory undefined"; return status; }
  if (!ins->dst) { status.message = "destination file undefined"; return status; }

  if (str_ends (ins->src, ".vlb")) {
    if (!libname (ins->src, src_tmp)) {
      status.message = "could not build library name";
      return status;
    }
    ins->src = src_tmp;
    if (!base_name (ins->src, &ins->src)) {
      status.message = "invalid source path";
      return status;
    }
    memcpy (src_name, ins->src, INSTALL_MAX_PATHLEN);
    ins->src = src_name;
  }

  /* build name of library */
  if (!base_name (ins->dst, &ins->dst)) {
    status.message = "invalid destination path";
    return status;
  }
  if (snprintf (dst_tmp, INSTALL_MAX_PATHLEN, "%s%s", ins->dst, inst_dlib_suffix) < 0) {
    status.status = INSTALL_STATUS_ERROR;
    status.message = "could not format destination path";
    return status;
  }
  ins->dst = dst_tmp;

  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
ntran_mkdir (struct install_item *ins)
{
  struct install_status_t status = INSTALL_STATUS_INIT;
  if (!ins->dst) ins->dst = ins->src;
  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
ntran_chk_link (struct install_item *ins)
{
  static char dst_name [INSTALL_MAX_PATHLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = ntran_link (ins);
  if (status.status != INSTALL_STATUS_OK) return status;

  if (snprintf (dst_name, INSTALL_MAX_PATHLEN, "%s/%s", ins->dir, ins->dst) < 0) {
    status.status = INSTALL_STATUS_ERROR;
    status.message = "could not format destination path";
    return status;
  }

  ins->dst = dst_name;

  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
ntran_chk_liblink (struct install_item *ins)
{
  static char dst_name [INSTALL_MAX_PATHLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = ntran_liblink (ins);
  if (status.status != INSTALL_STATUS_OK) return status;

  if (snprintf (dst_name, INSTALL_MAX_PATHLEN, "%s/%s", ins->dir, ins->dst) < 0) {
    status.status = INSTALL_STATUS_ERROR;
    status.message = "could not format destination path";
    return status;
  }

  ins->dst = dst_name;

  status.status = INSTALL_STATUS_OK;
  return status;
}

/*
 * instchk operator callbacks
 */

struct install_status_t
instchk_copy (struct install_item *ins, unsigned int flags)
{
  struct install_status_t status = INSTALL_STATUS_INIT;
  user_id_t uid;
  group_id_t gid;
  permissions_t perm = { ins->perm };

  status = install_uidgid_lookup (ins->owner, &uid, ins->group, &gid);
  if (status.status != INSTALL_STATUS_OK) return status;

  status = install_file_check (ins->src, perm, INSTALL_FILE_TYPE_FILE,
    uid, gid, ins->dst);
  if (status.status != INSTALL_STATUS_OK) ++install_failed;

  install_uid_free (&uid);
  install_gid_free (&gid);
  return status;
}

struct install_status_t
instchk_link (struct install_item *ins, unsigned int flags)
{
  struct install_status_t status = INSTALL_STATUS_INIT;
  user_id_t uid;
  group_id_t gid;
  permissions_t perm = { ins->perm };

  status = install_uidgid_lookup (ins->owner, &uid, ins->group, &gid);
  if (status.status != INSTALL_STATUS_OK) return status;

  status = install_file_check (ins->src, perm, INSTALL_FILE_TYPE_SYMLINK,
    uid, gid, ins->dst);
  if (status.status != INSTALL_STATUS_OK) ++install_failed;

  install_uid_free (&uid);
  install_gid_free (&gid);
  return status;
}

struct install_status_t
instchk_mkdir (struct install_item *ins, unsigned int flags)
{
  struct install_status_t status = INSTALL_STATUS_INIT;
  user_id_t uid;
  group_id_t gid;
  permissions_t perm = { ins->perm };

  status = install_uidgid_lookup (ins->owner, &uid, ins->group, &gid);
  if (status.status != INSTALL_STATUS_OK) return status;

  status = install_file_check (ins->dir, perm, INSTALL_FILE_TYPE_DIRECTORY,
    uid, gid, ins->dir);
  if (status.status != INSTALL_STATUS_OK) ++install_failed;

  install_uid_free (&uid);
  install_gid_free (&gid);
  return status;
}

struct install_status_t
instchk_liblink (struct install_item *ins, unsigned int flags)
{
  return instchk_link (ins, flags);
}

/*
 * deinstall operator callbacks
 */

struct install_status_t
deinst_copy (struct install_item *ins, unsigned int flags)
{
  static char msg_buffer [INSTALL_MAX_MSGLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  /* call info callback */
  if (install_callback_info) {
    snprintf (msg_buffer, sizeof (msg_buffer), "unlink %s", ins->dst);
    install_callback_info (msg_buffer, install_callback_data);
  }

  if (flags & INSTALL_DRYRUN) goto END;

  if (unlink (ins->dst) == -1) {
    status.status = INSTALL_STATUS_ERROR;
    status.message = "could not unlink file";
    return status;
  }

  END:
  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
deinst_link (struct install_item *ins, unsigned int flags)
{
  static char msg_buffer [INSTALL_MAX_MSGLEN];
  static char path_buf [INSTALL_MAX_PATHLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  if (install_callback_info) {
    snprintf (msg_buffer, sizeof (msg_buffer), "unlink %s/%s", ins->dir, ins->dst);
    install_callback_info (msg_buffer, install_callback_data);
  }

  if (flags & INSTALL_DRYRUN) goto END;

  if (snprintf (path_buf, sizeof (path_buf), "%s/%s", ins->dir, ins->dst) < 0) {
    status.message = "could not format string";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }
  if (unlink(path_buf) == -1) {
    status.message = "could not unlink";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }

  END:
  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
deinst_mkdir (struct install_item *ins, unsigned int flags)
{
  static char msg_buffer [INSTALL_MAX_MSGLEN];
  struct install_status_t status = INSTALL_STATUS_INIT;

  if (install_callback_info) {
    snprintf (msg_buffer, sizeof (msg_buffer), "rmdir %s", ins->dir);
    install_callback_info (msg_buffer, install_callback_data);
  }

  if (flags & INSTALL_DRYRUN) goto END;

  if (rmdir (ins->dir) == -1) {
    status.message = "could not remove directory";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }

  END:
  status.status = INSTALL_STATUS_OK;
  return status;
}

struct install_status_t
deinst_liblink (struct install_item *ins, unsigned int flags)
{
  return deinst_link (ins, flags);
}

/*
 * operator callback tables
 */

struct instop {
  struct install_status_t (*oper) (struct install_item *, unsigned int);
  struct install_status_t (*trans) (struct install_item *);
};
struct instop install_opers [] = {
  { inst_copy,    ntran_copy },
  { inst_copy,    ntran_copy_exec },
  { inst_link,    ntran_link },
  { inst_mkdir,   ntran_mkdir },
  { inst_liblink, ntran_liblink },
};
struct instop instchk_opers [] = {
  { instchk_copy,    ntran_copy },
  { instchk_copy,    ntran_copy_exec },
  { instchk_link,    ntran_chk_link },
  { instchk_mkdir,   ntran_mkdir },
  { instchk_liblink, ntran_chk_liblink },
};
struct instop deinst_opers [] = {
  { deinst_copy,    ntran_copy },
  { deinst_copy,    ntran_copy_exec },
  { deinst_link,    ntran_link },
  { deinst_mkdir,   ntran_mkdir },
  { deinst_liblink, ntran_liblink },
};

/*
 * interface
 */

void
install_suffix_sanitize (char *buffer, unsigned int size)
{
  char ch;
  unsigned int index;

  /* sanitize suffix */
  for (index = 0; index < size; ++index) {
    ch = buffer [index];
    if (ch == '.') continue;
    if ((ch >= '0') && (ch <= '9')) continue;
    if ((ch >= 'A') && (ch <= 'Z')) continue;
    if ((ch >= 'a') && (ch <= 'z')) continue;
    buffer [index] = 0;
    break;
  }
}

struct install_status_t
install_init (void)
{
  struct install_status_t status = INSTALL_STATUS_INIT;
  FILE *fp;

  fp = fopen ("conf-sosuffix", "rb");
  if (fp == NULL) {
    status.message = "could not open conf-sosuffix";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }

  memset (inst_exec_suffix, 0, sizeof (inst_exec_suffix));
  memset (inst_dlib_suffix, 0, sizeof (inst_dlib_suffix));

  inst_dlib_suffix [0] = '.';
  if (fread (inst_dlib_suffix + 1, 1, sizeof (inst_dlib_suffix) - 2, fp) == 0) {
    if (ferror (fp)) {
      status.message = "error reading conf-sosuffix";
      status.status = INSTALL_STATUS_ERROR;
    }
    if (feof (fp)) {
      status.message = "empty conf-sosuffix";
      status.status = INSTALL_STATUS_ERROR;
    }
    fclose (fp);
    return status;
  }

  install_suffix_sanitize (inst_dlib_suffix, sizeof (inst_dlib_suffix));

  if (fclose (fp) != 0) {
    status.message = "could not close conf-sosuffix";
    status.status = INSTALL_STATUS_ERROR;
    return status;
  }

#if INSTALL_OS_TYPE == INSTALL_OS_POSIX
  return iposix_install_init ();
#endif
#if INSTALL_OS_TYPE == INSTALL_OS_WIN32
  return iwin32_install_init ();
#endif
}

struct install_status_t
install (struct install_item *ins, unsigned int flags)
{
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = install_opers [ins->op].trans (ins);
  if (status.status != INSTALL_STATUS_OK) goto CLEANUP;
  status = install_opers [ins->op].oper (ins, flags);

  CLEANUP:
  fflush (0);
  return status;
}

struct install_status_t
install_check (struct install_item *ins)
{
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = instchk_opers [ins->op].trans (ins);
  if (status.status != INSTALL_STATUS_OK) goto CLEANUP;
  status = instchk_opers [ins->op].oper (ins, 0);

  CLEANUP:
  fflush (0);
  return status;
}

struct install_status_t
deinstall(struct install_item *ins, unsigned int flags)
{
  struct install_status_t status = INSTALL_STATUS_INIT;

  status = deinst_opers [ins->op].trans (ins);
  if (status.status != INSTALL_STATUS_OK) goto CLEANUP;
  status = deinst_opers [ins->op].oper (ins, flags);

  CLEANUP:
  fflush (0);
  return status;
}

void
install_callback_warn_set (void (*callback)(const char *, void *))
{
  install_callback_warn = callback;
}

void
install_callback_info_set (void (*callback)(const char *, void *))
{
  install_callback_info = callback;
}

void
install_callback_data_set (void *data)
{
  install_callback_data = data;
}

