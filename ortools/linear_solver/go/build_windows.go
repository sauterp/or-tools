// This file adds all the necessary cgo directives that enable the user to build and run the linear_solver package without modifying his environment variables etc.
package linear_solver

/*
#cgo CXXFLAGS: -std=c++11
#cgo CXXFLAGS: -I${SRCDIR}/../../
#cgo CXXFLAGS: -I${SRCDIR}/../../../../
#cgo CXXFLAGS: -I${SRCDIR}/../../../../dependencies/install/include/
#cgo CXXFLAGS: -DUSE_CLP
#cgo CXXFLAGS: -DUSE_CBC
#cgo CXXFLAGS: -DUSE_GLOP
#cgo CXXFLAGS: -DUSE_BOP
#cgo LDFLAGS: -L ${SRCDIR}/../../../../lib
#cgo LDFLAGS: -L ${SRCDIR}/../../../../dependencies/install/lib/
#cgo LDFLAGS: -L ${SRCDIR}/../../../../dependencies/install/lib/coin/
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/../../../../ortools/gen/ortools/linear_solver/
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/../../../../lib
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/../../../../dependencies/install/lib/
#cgo LDFLAGS: -lortools
#cgo LDFLAGS: -llibprotobuf
#cgo LDFLAGS: -llibprotobuf-lite
#cgo LDFLAGS: -lglog
#cgo LDFLAGS: -llibCbc
#cgo LDFLAGS: -llibClp
#cgo LDFLAGS: -lgflags_static
#cgo LDFLAGS: -llibOsiClp
#cgo LDFLAGS: -llibOsi
#cgo LDFLAGS: -llibCgl
#cgo LDFLAGS: -llibCoinUtils
*/
import "C"
