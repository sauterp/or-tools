# This is an attempt at supporting the language Go and it imitates and copies heavily from Makefile.gothon.mk
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
