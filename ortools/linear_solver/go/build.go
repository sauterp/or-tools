// This file adds all the necessary cgo directives that enable the user to build and run the linear_solver package without modifying his environment variables etc.
package linear_solver

/*
#cgo CXXFLAGS: -I${SRCDIR}/../../
#cgo CXXFLAGS: -I${SRCDIR}/../../../../
#cgo CXXFLAGS: -I${SRCDIR}/../../../../dependencies/install/include/
#cgo CXXFLAGS: -DUSE_CLP
#cgo CXXFLAGS: -DUSE_CBC
#cgo CXXFLAGS: -DUSE_GLOP
#cgo CXXFLAGS: -DUSE_BOP
#cgo LDFLAGS: ${SRCDIR}/../../../../ortools/gen/ortools/linear_solver/_gowraplp.so
#cgo LDFLAGS: ${SRCDIR}/../../../../dependencies/install/lib/libglog.so
#cgo LDFLAGS: -L ${SRCDIR}/../../../../lib
#cgo LDFLAGS: -L ${SRCDIR}/../../../../dependencies/install/lib/
#cgo LDFLAGS: -lprotobuf
#cgo LDFLAGS: -lprotobuf-lite
#cgo LDFLAGS: -lortools
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/../../../../ortools/gen/ortools/linear_solver/
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/../../../../dependencies/install/lib/
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/../../../../lib
#cgo LDFLAGS: -Wl,-rpath ${SRCDIR}/../../../../dependencies/install/lib/
#cgo pkg-config: --define-variable=prefix=${SRCDIR}/../../../../dependencies/install/lib/pkgconfig/
#cgo pkg-config: cbc
#cgo pkg-config: clp
#cgo pkg-config: gflags
#cgo pkg-config: osi-clp
#cgo pkg-config: osi
#cgo pkg-config: cgl
#cgo pkg-config: coinutils
#cgo pkg-config: osi-cbc
#cgo pkg-config: osi-unittests
*/
import "C"