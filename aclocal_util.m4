dnl Nesting safe macros for saving variables
dnl Usage: PAC_PUSH_VAR(CFLAGS)
AC_DEFUN([PAC_PUSH_VAR],[
	if test -z "${pac_save_$1_nesting}" ; then
	   pac_save_$1_nesting=0
	fi
	eval pac_save_$1_${pac_save_$1_nesting}='"$$1"'
	pac_save_$1_nesting=`expr ${pac_save_$1_nesting} + 1`
])

dnl Usage: PAC_POP_VAR(CFLAGS)
AC_DEFUN([PAC_POP_VAR],[
	pac_save_$1_nesting=`expr ${pac_save_$1_nesting} - 1`
	eval $1="\$pac_save_$1_${pac_save_$1_nesting}"
	eval pac_save_$1_${pac_save_$1_nesting}=""
])

dnl Usage: PAC_SAVE_FLAGS
AC_DEFUN([PAC_SAVE_FLAGS],[
	PAC_PUSH_VAR(CFLAGS)
	PAC_PUSH_VAR(CXXFLAGS)
	PAC_PUSH_VAR(FFLAGS)
	PAC_PUSH_VAR(F90FLAGS)
	PAC_PUSH_VAR(LDFLAGS)
	PAC_PUSH_VAR(LIBS)
])

dnl Usage: PAC_RESTORE_FLAGS
AC_DEFUN([PAC_RESTORE_FLAGS],[
	PAC_POP_VAR(CFLAGS)
	PAC_POP_VAR(CXXFLAGS)
	PAC_POP_VAR(FFLAGS)
	PAC_POP_VAR(F90FLAGS)
	PAC_POP_VAR(LDFLAGS)
	PAC_POP_VAR(LIBS)
])

dnl Usage: PAC_APPEND_FLAG([-02], [$CFLAGS])
dnl need a clearer explanation and definition of how this is called
AC_DEFUN([PAC_APPEND_FLAG],[
	AC_REQUIRE([AC_PROG_FGREP])
	AS_IF(
		[echo "$$2" | $FGREP -e '$1' >/dev/null 2>&1],
		[echo "$2(='$$2') contains '$1', not appending" >&AS_MESSAGE_LOG_FD],
		[echo "$2(='$$2') does not contain '$1', appending" >&AS_MESSAGE_LOG_FD
		$2="$$2 $1"]
	)
])

dnl PAC_MKDIRS(path)
dnl Create any missing directories in the path
AC_DEFUN([PAC_MKDIRS],[
# Build any intermediate directories
for dir in $1 ; do
    saveIFS="$IFS"
    IFS="/"
    tmp_curdir=""
    for tmp_subdir in $dir ; do
	tmp_curdir="${tmp_curdir}$tmp_subdir"
	if test ! -d "$tmp_curdir" ; then mkdir "$tmp_curdir" ; fi
        tmp_curdir="${tmp_curdir}/"
    done
    IFS="$saveIFS"
done
])

dnl Test for a clean VPATH directory.  Provide this command with the names
dnl of all of the generated files that might cause problems 
dnl (Makefiles won't cause problems because there's no VPATH usage for them)
dnl
dnl Synopsis
dnl PAC_VPATH_CHECK([file-names],[directory-names])
dnl  file-names should be files other than config.status and any header (e.g.,
dnl fooconf.h) file that should be removed.  It is optional
AC_DEFUN([PAC_VPATH_CHECK],[
rm -f conftest*
date >conftest$$
# If creating a file in the current directory does not show up in the srcdir
# then we're doing a VPATH build (or something is very wrong)
if test ! -s $srcdir/conftest$$ ; then
    pac_dirtyfiles=""
    pac_dirtydirs=""
    pac_header=""
    ifdef([AC_LIST_HEADER],[pac_header=AC_LIST_HEADER])
    for file in config.status $pac_header $1 ; do
        if test -f $srcdir/$file ; then 
	    pac_dirtyfiles="$pac_dirtyfiles $file"
	fi
    done
    ifelse($2,,,[
 	for dir in $2 ; do 
            if test -d $srcdir/$dir ; then
                pac_dirtydirs="$pac_dirtydirs $dir"
	    fi
	done
    ])

    if test -n "$pac_dirtyfiles" -o -n "$pac_dirtydirs" ; then
	# Create a nice message about what to remove
	rmmsg=""
	if test -n "$pac_dirtyfiles" ; then
	    rmmsg="files $pac_dirtyfiles"
        fi
 	if test -n "$pac_dirtydirs" ; then
	    if test -n "$rmmsg" ; then
	        rmmsg="$rmmsg and directories $pac_dirtydirs"
            else
                rmmsg="directories $pac_dirtydirs"
            fi
        fi
        if test -f $srcdir/Makefile ; then
            AC_MSG_ERROR([You cannot do a VPATH build if the source directory has been
    configured.  Run "make distclean" in $srcdir first and make sure that the
    $rmmsg have been removed.])
        else
            AC_MSG_ERROR([You cannot do a VPATH build if the source directory has been
    configured.  Remove the $rmmsg in $srcdir.])
        fi
    fi
fi
rm -f conftest*
])
