AC_DEFUN([BANSHEE_CHECK_TAGLIB_SHARP],
[
	PKG_CHECK_MODULES(TAGLIB_SHARP, taglib-sharp >= 2.0.3.7)
	AC_SUBST(TAGLIB_SHARP_LIBS)
])
