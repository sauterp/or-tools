/* Unfortunately SWIG doesn't allow %insert to the top of the output file and the following macro cannot be inserted where it needs to be to make the wrapper compilable for MSVC.
/* If we're not using GNU C, elide __attribute__ */
#ifndef __GNUC__
#  define  __attribute__(x)  /*NOTHING*/
#endif

#include "linear_solver_go_wrap.cc"
