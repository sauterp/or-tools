# This is an attempt at supporting the language Go and it imitates and copies heavily from Makefile.python.mk
# ---------- Go support using SWIG ----------
.PHONY: help_go # Generate list of Go targets with descriptions.
help_go:
	@echo Use one of the following Go targets:
ifeq ($(SYSTEM),win)
	@$(GREP) "^.PHONY: .* #" $(CURDIR)/makefiles/Makefile.go.mk | $(SED) "s/\.PHONY: \(.*\) # \(.*\)/\1\t\2/"
	@echo off & echo(
else
	@$(GREP) "^.PHONY: .* #" $(CURDIR)/makefiles/Makefile.go.mk | $(SED) "s/\.PHONY: \(.*\) # \(.*\)/\1\t\2/" | expand -t24
	@echo
endif

OR_TOOLS_GOPATH = $(OR_ROOT_FULL)$(CPSEP)$(OR_ROOT_FULL)$Sdependencies$Ssources$Sprotobuf-$(PROTOBUF_TAG)$Sgo

# Check for required build tools
ifeq ($(SYSTEM),win)
GO_COMPILER ?= go.exe
ifneq ($(WINDOWS_PATH_TO_GO),)
GO_EXECUTABLE := $(WINDOWS_PATH_TO_GO)\$(GO_COMPILER)
else
GO_EXECUTABLE := $(shell $(WHICH) $(GO_COMPILER) 2>nul)
endif
SET_GOPATH = set GOPATH=$(OR_TOOLS_GOPATH) &&
else # UNIX
GO_COMPILER ?= go
GO_EXECUTABLE := $(shell which $(GO_COMPILER))
SET_GOPATH = GOPATH=$(OR_TOOLS_GOPATH) # TODO set the correct GOPATH
endif

# All libraries and dependecies
GOALGORITHMS_LIBS = $(LIB_DIR)/_gowrapknapsack_solver.$(SWIG_GO_LIB_SUFFIX)
GOGRAPH_LIBS = $(LIB_DIR)/_gowrapgraph.$(SWIG_GO_LIB_SUFFIX)
GOCP_LIBS = $(LIB_DIR)/_gowrapcp.$(SWIG_GO_LIB_SUFFIX)
GOLP_LIBS = $(LIB_DIR)/_gowraplp.$(SWIG_GO_LIB_SUFFIX)
GOSAT_LIBS = $(LIB_DIR)/_gowrapsat.$(SWIG_GO_LIB_SUFFIX)
GODATA_LIBS = $(LIB_DIR)/_gowraprcpsp.$(SWIG_GO_LIB_SUFFIX)
GOSORTED_INTERVAL_LIST_LIBS = $(LIB_DIR)/_sorted_interval_list.$(SWIG_GO_LIB_SUFFIX)
GO_OR_TOOLS_LIBS = \
 $(GEN_DIR)/ortools/ \
 $(GOALGORITHMS_LIBS) \
 $(GOGRAPH_LIBS) \
 $(GOCP_LIBS) \
 $(GOLP_LIBS) \
 $(GOSAT_LIBS) \
 $(GODATA_LIBS) \
 $(GOSORTED_INTERVAL_LIST_LIBS)

# Main target
.PHONY: go # Build Go OR-Tools.
.PHONY: check_go # Quick check only running Go OR-Tools samples.
.PHONY: test_go # Run all Go OR-Tools test targets.
ifneq ($(GO_EXECUTABLE),)
go: $(GO_OR_TOOLS_LIBS)
check_go: check_go_pimpl
test_go: test_go_pimpl
BUILT_LANGUAGES +=, Go$(GO_VERSION)
else
go:
	@echo GO_EXECUTABLE = "${GO_EXECUTABLE}"
	$(warning Cannot find '$(GO_COMPILER)' command which is needed for build. Please make sure it is installed and in system path.)
check_go: go
test_go: go
endif

# TODO add target for ortools go package here.

#######################
##  Go Wrappers  ##
#######################
# gowrapknapsack_solver
ifeq ($(PLATFORM),MACOSX)
GOALGORITHMS_LDFLAGS = -install_name @rpath/_gowrapknapsack_solver.$(SWIG_GO_LIB_SUFFIX) #
endif

$(GEN_DIR)/ortools/algorithms/pywrapknapsack_solver.py: \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/util/go/vector.i \
 $(SRC_DIR)/ortools/algorithms/go/knapsack_solver.i \
 $(SRC_DIR)/ortools/algorithms/knapsack_solver.h \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/algorithms
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -go $(SWIG_GO_FLAG) $(SWIG_GO_DOXYGEN) \
 -o $(GEN_PATH)$Sortools$Salgorithms$Sknapsack_solver_go_wrap.cc \
 -module gowrapknapsack_solver \
 ortools$Salgorithms$Sgo$Sknapsack_solver.i

$(GEN_DIR)/ortools/algorithms/knapsack_solver_go_wrap.cc: \
 $(GEN_DIR)/ortools/algorithms/pywrapknapsack_solver.py

$(OBJ_DIR)/swig/knapsack_solver_go_wrap.$O: \
 $(GEN_DIR)/ortools/algorithms/knapsack_solver_go_wrap.cc \
 $(ALGORITHMS_DEPS) \
 | $(OBJ_DIR)/swig
	$(CCC) $(CFLAGS) $(GO_INC) $(GO_CFLAGS) \
 -c $(GEN_PATH)$Sortools$Salgorithms$Sknapsack_solver_go_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sknapsack_solver_go_wrap.$O

$(GOALGORITHMS_LIBS): $(OBJ_DIR)/swig/knapsack_solver_go_wrap.$O $(OR_TOOLS_LIBS)
	$(DYNAMIC_LD) \
 $(GOALGORITHMS_LDFLAGS) \
 $(LD_OUT)$(LIB_DIR)$S_gowrapknapsack_solver.$(SWIG_GO_LIB_SUFFIX) \
 $(OBJ_DIR)$Sswig$Sknapsack_solver_go_wrap.$O \
 $(OR_TOOLS_LNK) \
 $(SYS_LNK) \
 $(GO_LNK) \
 $(GO_LDFLAGS)
ifeq ($(SYSTEM),win)
	copy $(LIB_DIR)$S_gowrapknapsack_solver.$(SWIG_GO_LIB_SUFFIX) $(GEN_PATH)\\ortools\\algorithms\\_pywrapknapsack_solver.pyd
else
	cp $(GOALGORITHMS_LIBS) $(GEN_PATH)/ortools/algorithms
endif

# gowrapgraph
ifeq ($(PLATFORM),MACOSX)
GOGRAPH_LDFLAGS = -install_name @rpath/_gowrapgraph.$(SWIG_GO_LIB_SUFFIX) #
endif

$(GEN_DIR)/ortools/graph/pywrapgraph.py: \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/util/go/vector.i \
 $(SRC_DIR)/ortools/graph/go/graph.i \
 $(SRC_DIR)/ortools/graph/min_cost_flow.h \
 $(SRC_DIR)/ortools/graph/max_flow.h \
 $(SRC_DIR)/ortools/graph/ebert_graph.h \
 $(SRC_DIR)/ortools/graph/shortestpaths.h \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/graph
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -go $(SWIG_GO_FLAG) \
 -o $(GEN_PATH)$Sortools$Sgraph$Sgraph_go_wrap.cc \
 -module gowrapgraph \
 ortools$Sgraph$Sgo$Sgraph.i

$(GEN_DIR)/ortools/graph/graph_go_wrap.cc: \
 $(GEN_DIR)/ortools/graph/pywrapgraph.py

$(OBJ_DIR)/swig/graph_go_wrap.$O: \
 $(GEN_DIR)/ortools/graph/graph_go_wrap.cc \
 $(GRAPH_DEPS) \
 | $(OBJ_DIR)/swig
	$(CCC) $(CFLAGS) $(GO_INC) $(GO_CFLAGS) \
 -c $(GEN_PATH)/ortools/graph/graph_go_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sgraph_go_wrap.$O

$(GOGRAPH_LIBS): $(OBJ_DIR)/swig/graph_go_wrap.$O $(OR_TOOLS_LIBS)
	$(DYNAMIC_LD) \
 $(GOGRAPH_LDFLAGS) \
 $(LD_OUT)$(LIB_DIR)$S_gowrapgraph.$(SWIG_GO_LIB_SUFFIX) \
 $(OBJ_DIR)$Sswig$Sgraph_go_wrap.$O \
 $(OR_TOOLS_LNK) \
 $(SYS_LNK) \
 $(GO_LNK) \
 $(GO_LDFLAGS)
ifeq ($(SYSTEM),win)
	copy $(LIB_DIR)$S_gowrapgraph.$(SWIG_GO_LIB_SUFFIX) $(GEN_PATH)\\ortools\\graph\\_pywrapgraph.pyd
else
	cp $(GOGRAPH_LIBS) $(GEN_PATH)/ortools/graph
endif

# gowrapcp
ifeq ($(PLATFORM),MACOSX)
GOCP_LDFLAGS = -install_name @rpath/_gowrapcp.$(SWIG_GO_LIB_SUFFIX) #
endif

$(GEN_DIR)/ortools/constraint_solver/search_limit_pb2.py: \
 $(SRC_DIR)/ortools/constraint_solver/search_limit.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/constraint_solver
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)$Sortools$Sconstraint_solver$Ssearch_limit.proto

$(GEN_DIR)/ortools/constraint_solver/assignment_pb2.py: \
 $(SRC_DIR)/ortools/constraint_solver/assignment.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/constraint_solver
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)$Sortools$Sconstraint_solver$Sassignment.proto

$(GEN_DIR)/ortools/constraint_solver/solver_parameters_pb2.py: \
 $(SRC_DIR)/ortools/constraint_solver/solver_parameters.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/constraint_solver
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)$Sortools$Sconstraint_solver$Ssolver_parameters.proto

$(GEN_DIR)/ortools/constraint_solver/routing_enums_pb2.py: \
 $(SRC_DIR)/ortools/constraint_solver/routing_enums.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/constraint_solver
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)$Sortools$Sconstraint_solver$Srouting_enums.proto

$(GEN_DIR)/ortools/constraint_solver/routing_parameters_pb2.py: \
 $(SRC_DIR)/ortools/constraint_solver/routing_parameters.proto \
 $(GEN_DIR)/ortools/constraint_solver/solver_parameters_pb2.py \
 $(GEN_DIR)/ortools/constraint_solver/routing_enums_pb2.py \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/constraint_solver
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)$Sortools$Sconstraint_solver$Srouting_parameters.proto

$(GEN_DIR)/ortools/constraint_solver/pywrapcp.py: \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/util/go/vector.i \
 $(SRC_DIR)/ortools/constraint_solver/go/constraint_solver.i \
 $(SRC_DIR)/ortools/constraint_solver/go/routing.i \
 $(SRC_DIR)/ortools/constraint_solver/constraint_solver.h \
 $(SRC_DIR)/ortools/constraint_solver/constraint_solveri.h \
 $(GEN_DIR)/ortools/constraint_solver/assignment_pb2.py \
 $(GEN_DIR)/ortools/constraint_solver/routing_enums_pb2.py \
 $(GEN_DIR)/ortools/constraint_solver/routing_parameters_pb2.py \
 $(GEN_DIR)/ortools/constraint_solver/search_limit_pb2.py \
 $(GEN_DIR)/ortools/constraint_solver/solver_parameters_pb2.py \
 $(GEN_DIR)/ortools/constraint_solver/assignment.pb.h \
 $(GEN_DIR)/ortools/constraint_solver/search_limit.pb.h \
 $(CP_LIB_OBJS) \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/constraint_solver
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -go -nofastunpack $(SWIG_GO_FLAG) $(SWIG_GO_DOXYGEN) \
 -o $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_go_wrap.cc \
 -module gowrapcp \
 $(SRC_DIR)/ortools/constraint_solver$Sgo$Srouting.i
	$(SED) -i -e 's/< long long >/< int64 >/g' \
 $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_go_wrap.cc
	$(SED) -i -e 's/< long long,long long >/< int64, int64 >/g' \
 $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_go_wrap.cc
	$(SED) -i -e 's/< long long,std::allocator/< int64, std::allocator/g' \
 $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_go_wrap.cc
	$(SED) -i -e 's/,long long,/,int64,/g' \
 $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_go_wrap.cc

$(GEN_DIR)/ortools/constraint_solver/constraint_solver_go_wrap.cc: \
 $(GEN_DIR)/ortools/constraint_solver/pywrapcp.py

$(OBJ_DIR)/swig/constraint_solver_go_wrap.$O: \
 $(GEN_DIR)/ortools/constraint_solver/constraint_solver_go_wrap.cc \
 $(CP_DEPS) \
 | $(OBJ_DIR)/swig
	$(CCC) $(CFLAGS) $(GO_INC) $(GO_CFLAGS) \
 -c $(GEN_PATH)$Sortools$Sconstraint_solver$Sconstraint_solver_go_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Sconstraint_solver_go_wrap.$O

$(GOCP_LIBS): $(OBJ_DIR)/swig/constraint_solver_go_wrap.$O $(OR_TOOLS_LIBS)
	$(DYNAMIC_LD) \
 $(GOCP_LDFLAGS) \
 $(LD_OUT)$(LIB_DIR)$S_gowrapcp.$(SWIG_GO_LIB_SUFFIX) \
 $(OBJ_DIR)$Sswig$Sconstraint_solver_go_wrap.$O \
 $(OR_TOOLS_LNK) \
 $(SYS_LNK) \
 $(GO_LNK) \
 $(GO_LDFLAGS)
ifeq ($(SYSTEM),win)
	copy $(LIB_DIR)$S_gowrapcp.$(SWIG_GO_LIB_SUFFIX) $(GEN_PATH)\\ortools\\constraint_solver\\_pywrapcp.pyd
else
	cp $(GOCP_LIBS) $(GEN_PATH)/ortools/constraint_solver
endif

# gowraplp
ifeq ($(PLATFORM),MACOSX)
GOLP_LDFLAGS = -install_name @rpath/_gowraplp.$(SWIG_GO_LIB_SUFFIX) #
endif

$(GEN_DIR)/ortools/util/optional_boolean_pb2.py: \
 $(SRC_DIR)/ortools/util/optional_boolean.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/util
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)/ortools/util/optional_boolean.proto

$(GEN_DIR)/ortools/linear_solver/linear_solver_pb2.py: \
 $(SRC_DIR)/ortools/linear_solver/linear_solver.proto \
 $(GEN_DIR)/ortools/util/optional_boolean_pb2.py \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/linear_solver
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)/ortools/linear_solver/linear_solver.proto

$(GEN_DIR)/ortools/linear_solver/pywraplp.py: \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/util/go/vector.i \
 $(SRC_DIR)/ortools/linear_solver/go/linear_solver.i \
 $(SRC_DIR)/ortools/linear_solver/linear_solver.h \
 $(GEN_DIR)/ortools/linear_solver/linear_solver.pb.h \
 $(GEN_DIR)/ortools/linear_solver/linear_solver_pb2.py \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/linear_solver
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -go $(SWIG_GO_FLAG) $(SWIG_GO_DOXYGEN) \
 -o $(GEN_PATH)$Sortools$Slinear_solver$Slinear_solver_go_wrap.cc \
 -module gowraplp \
 $(SRC_DIR)/ortools/linear_solver$Sgo$Slinear_solver.i

$(GEN_DIR)/ortools/linear_solver/linear_solver_go_wrap.cc: \
 $(GEN_DIR)/ortools/linear_solver/pywraplp.py

$(OBJ_DIR)/swig/linear_solver_go_wrap.$O: \
 $(GEN_DIR)/ortools/linear_solver/linear_solver_go_wrap.cc \
 $(LP_DEPS) \
 | $(OBJ_DIR)/swig
	$(CCC) $(CFLAGS) $(GO_INC) $(GO_CFLAGS) \
 -c $(GEN_PATH)$Sortools$Slinear_solver$Slinear_solver_go_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Slinear_solver_go_wrap.$O

$(GOLP_LIBS): $(OBJ_DIR)/swig/linear_solver_go_wrap.$O $(OR_TOOLS_LIBS)
	$(DYNAMIC_LD) \
 $(GOLP_LDFLAGS) \
 $(LD_OUT)$(LIB_DIR)$S_gowraplp.$(SWIG_GO_LIB_SUFFIX) \
 $(OBJ_DIR)$Sswig$Slinear_solver_go_wrap.$O \
 $(OR_TOOLS_LNK) \
 $(SYS_LNK) \
 $(GO_LNK) \
 $(GO_LDFLAGS)
ifeq ($(SYSTEM),win)
	copy $(LIB_DIR)$S_gowraplp.$(SWIG_GO_LIB_SUFFIX) $(GEN_PATH)\\ortools\\linear_solver\\_pywraplp.pyd
else
	cp $(GOLP_LIBS) $(GEN_PATH)/ortools/linear_solver
endif

# gowrapsat
ifeq ($(PLATFORM),MACOSX)
GOSAT_LDFLAGS = -install_name @rpath/_gowrapsat.$(SWIG_GO_LIB_SUFFIX) #
endif

$(GEN_DIR)/ortools/sat/cp_model_pb2.py: \
 $(SRC_DIR)/ortools/sat/cp_model.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/sat
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)/ortools/sat/cp_model.proto

$(GEN_DIR)/ortools/sat/sat_parameters_pb2.py: \
 $(SRC_DIR)/ortools/sat/sat_parameters.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/sat
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)/ortools/sat/sat_parameters.proto

$(GEN_DIR)/ortools/sat/pywrapsat.py: \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/util/go/vector.i \
 $(SRC_DIR)/ortools/sat/go/sat.i \
 $(GEN_DIR)/ortools/sat/cp_model_pb2.py \
 $(GEN_DIR)/ortools/sat/sat_parameters_pb2.py \
 $(SAT_DEPS) \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/sat
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -go $(SWIG_GO_FLAG) \
 -o $(GEN_PATH)$Sortools$Ssat$Ssat_go_wrap.cc \
 -module gowrapsat \
 $(SRC_DIR)/ortools/sat$Sgo$Ssat.i

$(GEN_DIR)/ortools/sat/sat_go_wrap.cc: \
 $(GEN_DIR)/ortools/sat/pywrapsat.py

$(OBJ_DIR)/swig/sat_go_wrap.$O: \
 $(GEN_DIR)/ortools/sat/sat_go_wrap.cc \
 $(SAT_DEPS) \
 | $(OBJ_DIR)/swig
	$(CCC) $(CFLAGS) $(GO_INC) $(GO_CFLAGS) \
 -c $(GEN_PATH)$Sortools$Ssat$Ssat_go_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Ssat_go_wrap.$O

$(GOSAT_LIBS): $(OBJ_DIR)/swig/sat_go_wrap.$O $(OR_TOOLS_LIBS)
	$(DYNAMIC_LD) \
 $(GOSAT_LDFLAGS) \
 $(LD_OUT)$(LIB_DIR)$S_gowrapsat.$(SWIG_GO_LIB_SUFFIX) \
 $(OBJ_DIR)$Sswig$Ssat_go_wrap.$O \
 $(OR_TOOLS_LNK) \
 $(SYS_LNK) \
 $(GO_LNK) \
 $(GO_LDFLAGS)
ifeq ($(SYSTEM),win)
	copy $(LIB_DIR)$S_gowrapsat.$(SWIG_GO_LIB_SUFFIX) $(GEN_PATH)\\ortools\\sat\\_pywrapsat.pyd
else
	cp $(GOSAT_LIBS) $(GEN_PATH)/ortools/sat
endif

# gowraprcpsp
ifeq ($(PLATFORM),MACOSX)
GORCPSP_LDFLAGS = -install_name @rpath/_gowraprcpsp.$(SWIG_GO_LIB_SUFFIX) #
endif

$(GEN_DIR)/ortools/data/rcpsp_pb2.py: \
 $(SRC_DIR)/ortools/data/rcpsp.proto \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/data
	$(PROTOC) --proto_path=$(INC_DIR) --go_out=$(GEN_PATH) $(MYPY_OUT) \
 $(SRC_DIR)/ortools/data/rcpsp.proto

$(GEN_DIR)/ortools/data/pywraprcpsp.py: \
 $(SRC_DIR)/ortools/data/rcpsp_parser.h \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/data/go/rcpsp.i \
 $(GEN_DIR)/ortools/data/rcpsp_pb2.py \
 $(DATA_DEPS) \
 $(PROTOBUF_GO_DESC) \
 | $(GEN_DIR)/ortools/data
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -go $(SWIG_GO_FLAG) \
 -o $(GEN_PATH)$Sortools$Sdata$Srcpsp_go_wrap.cc \
 -module gowraprcpsp \
 $(SRC_DIR)/ortools/data$Sgo$Srcpsp.i

$(GEN_DIR)/ortools/data/rcpsp_go_wrap.cc: \
 $(GEN_DIR)/ortools/data/pywraprcpsp.py

$(OBJ_DIR)/swig/rcpsp_go_wrap.$O: \
 $(GEN_DIR)/ortools/data/rcpsp_go_wrap.cc \
 $(DATA_DEPS) \
 | $(OBJ_DIR)/swig
	$(CCC) $(CFLAGS) $(GO_INC) $(GO_CFLAGS) \
 -c $(GEN_PATH)$Sortools$Sdata$Srcpsp_go_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Srcpsp_go_wrap.$O

$(GODATA_LIBS): $(OBJ_DIR)/swig/rcpsp_go_wrap.$O $(OR_TOOLS_LIBS)
	$(DYNAMIC_LD) \
 $(GORCPSP_LDFLAGS) \
 $(LD_OUT)$(LIB_DIR)$S_gowraprcpsp.$(SWIG_GO_LIB_SUFFIX) \
 $(OBJ_DIR)$Sswig$Srcpsp_go_wrap.$O \
 $(OR_TOOLS_LNK) \
 $(SYS_LNK) \
 $(GO_LNK) \
 $(GO_LDFLAGS)
ifeq ($(SYSTEM),win)
	copy $(LIB_DIR)$S_gowraprcpsp.$(SWIG_GO_LIB_SUFFIX) $(GEN_PATH)\\ortools\\data\\_pywraprcpsp.pyd
else
	cp $(GODATA_LIBS) $(GEN_PATH)/ortools/data
endif

# sorted_interval_list
ifeq ($(PLATFORM),MACOSX)
GOSORTED_INTERVAL_LIST_LDFLAGS = -install_name @rpath/_sorted_interval_list.$(SWIG_GO_LIB_SUFFIX) #
endif

$(GEN_DIR)/ortools/util/sorted_interval_list.py: \
 $(SRC_DIR)/ortools/util/sorted_interval_list.h \
 $(SRC_DIR)/ortools/base/base.i \
 $(SRC_DIR)/ortools/util/go/vector.i \
 $(SRC_DIR)/ortools/util/go/sorted_interval_list.i \
 $(UTIL_DEPS) \
 | $(GEN_DIR)/ortools/util
	$(SWIG_BINARY) $(SWIG_INC) -I$(INC_DIR) -c++ -go $(SWIG_GO_DOXYGEN) $(SWIG_GO_FLAG) \
 -o $(GEN_PATH)$Sortools$Sutil$Ssorted_interval_list_go_wrap.cc \
 -module sorted_interval_list \
 $(SRC_DIR)$Sortools$Sutil$Sgo$Ssorted_interval_list.i
	$(SED) -i -e 's/< long long >/< int64 >/g' \
 $(GEN_PATH)$Sortools$Sutil$Ssorted_interval_list_go_wrap.cc

$(GEN_DIR)/ortools/util/sorted_interval_list_go_wrap.cc: \
 $(GEN_DIR)/ortools/util/sorted_interval_list.py

$(OBJ_DIR)/swig/sorted_interval_list_go_wrap.$O: \
 $(GEN_DIR)/ortools/util/sorted_interval_list_go_wrap.cc \
 $(UTIL_DEPS) \
 | $(OBJ_DIR)/swig
	$(CCC) $(CFLAGS) $(GO_INC) $(GO_CFLAGS) \
 -c $(GEN_PATH)$Sortools$Sutil$Ssorted_interval_list_go_wrap.cc \
 $(OBJ_OUT)$(OBJ_DIR)$Sswig$Ssorted_interval_list_go_wrap.$O

$(GOSORTED_INTERVAL_LIST_LIBS): $(OBJ_DIR)/swig/sorted_interval_list_go_wrap.$O $(OR_TOOLS_LIBS)
	$(DYNAMIC_LD) \
 $(GOSORTED_INTERVAL_LIST_LDFLAGS) \
 $(LD_OUT)$(LIB_DIR)$S_sorted_interval_list.$(SWIG_GO_LIB_SUFFIX) \
 $(OBJ_DIR)$Sswig$Ssorted_interval_list_go_wrap.$O \
 $(OR_TOOLS_LNK) \
 $(SYS_LNK) \
 $(GO_LNK) \
 $(GO_LDFLAGS)
ifeq ($(SYSTEM),win)
	copy $(LIB_DIR)$S_sorted_interval_list.$(SWIG_GO_LIB_SUFFIX) $(GEN_PATH)\\ortools\\util\\_sorted_interval_list.pyd
else
	cp $(GOSORTED_INTERVAL_LIST_LIBS) $(GEN_PATH)/ortools/util
endif


# TODO imitate section from Makefile.python.mk
#######################
##  Python SOURCE  ##
#######################

# TODO imitate section from Makefile.python.mk
###############################
##  Python Examples/Samples  ##
###############################

# TODO imitate section from Makefile.python.mk
################
##  Cleaning  ##
################

# TODO imitate section from Makefile.python.mk
#############
##  DEBUG  ##
#############
