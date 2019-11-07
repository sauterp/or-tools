// This file adds all the necessary cgo directives that enable the user to build and run the linear_solver package without modifying his environment variables etc.
// This version is supposed to be copied into the final install directory.
package linear_solver

/*
#cgo CXXFLAGS: -std=c++11
#cgo CXXFLAGS: -I${SRCDIR}/ortools/gen/
#cgo CXXFLAGS: -I${SRCDIR}/dependencies/install/include/
#cgo CXXFLAGS: -DUSE_CLP
#cgo CXXFLAGS: -DUSE_CBC
#cgo CXXFLAGS: -DUSE_GLOP
#cgo CXXFLAGS: -DUSE_BOP
#cgo LDFLAGS: -L ${SRCDIR}/lib
#cgo LDFLAGS: -L ${SRCDIR}/dependencies/install/lib/
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/lib
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/dependencies/install/lib/
#cgo LDFLAGS: ${SRCDIR}/lib/_gowraplp.so
#cgo LDFLAGS: -lprotobuf
#cgo LDFLAGS: -lprotobuf-lite
#cgo LDFLAGS: -lortools
#cgo LDFLAGS: -lglog
#cgo LDFLAGS: -lCbc
#cgo LDFLAGS: -lClp
#cgo LDFLAGS: -lgflags
#cgo LDFLAGS: -lOsiClp
#cgo LDFLAGS: -lOsi
#cgo LDFLAGS: -lCgl
#cgo LDFLAGS: -lCoinUtils
#cgo LDFLAGS: -lOsiCbc
*/
import "C"
