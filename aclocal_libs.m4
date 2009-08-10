
dnl PAC_SET_HEADER_LIB_PATH(with_option)
dnl This macro looks for the --with-xxx=, --with-xxx-include and --with-xxx-lib=
dnl options and sets the library and include paths.
AC_DEFUN([PAC_SET_HEADER_LIB_PATH],[
    AC_ARG_WITH($1, 
    		AC_HELP_STRING([--with-$1=path],
			       [specify path where $1 include directory and lib directory can be found]),
        if test "${with_$1}" != "yes" -a "${with_$1}" != "no" ; then
            LDFLAGS="$LDFLAGS -L${with_$1}/lib64 -L${with_$1}/lib"
    	    CPPFLAGS="$CPPFLAGS -I${with_$1}/include"
        fi,
    )
    AC_ARG_WITH($1-include, 
    		AC_HELP_STRING([--with-$1-include=path],
			       [specify path where $1 include directory can be found]),
        if test "${with_$1_include}" != "yes" -a "${with_$1_include}" != "no" ; then
    	    CPPFLAGS="$CPPFLAGS -I${with_$1_include}/include"
        fi,
    )
    AC_ARG_WITH($1-lib, 
    		AC_HELP_STRING([--with-$1-lib=path],
			       [specify path where $1 lib directory can be found]),
        if test "${with_$1_lib}" != "yes" -a "${with_$1_lib}" != "no" ; then
            LDFLAGS="$LDFLAGS -L${with_$1_lib}/lib64 -L${with_$1_lib}/lib"
        fi,
    )
])


dnl PAC_CHECK_HEADER_LIB(with_option, header.h, libname, function)
dnl This macro checks for a header and lib.  It is assumed that the
dnl user can specify a path to the includes and libs using --with-xxx=.
dnl The xxx is specified in the "with_option" parameter.
AC_DEFUN([PAC_CHECK_HEADER_LIB],[
    AC_CHECK_HEADER([$2], , [
        AC_MSG_ERROR(['$2 not found.  Did you specify --with-$1= or --with-$1-include=?'])
    ])
    AC_CHECK_LIB($3, $4, , [
        AC_MSG_ERROR(['$3 library not found.  Did you specify --with-$1= or --with-$1-lib=?'])
    ])
])