// This is an attempt at implementing a SWIG interface to linear_solver and it copies from and imitates ../python.linear_solver.i

%include "std_string.i"
%include "stdint.i"

%include "ortools/base/base.i"

%include "std_vector.i"

namespace std {
  %template(IntVector) vector<int>;
  %template(Float32Vector) vector<float>;
  %template(Float64Vector) vector<double>;
  %template(StringVector) vector<string>;
}

using namespace std;
typedef std::vector Vector;

// We need to forward-declare the proto here, so that the PROTO_* macros
// involving them work correctly. The order matters very much: this declaration
// needs to be before the %{ #include ".../linear_solver.h" %}.
namespace operations_research {
class MPModelProto;
class MPModelRequest;
class MPSolutionResponse;
}  // namespace operations_research

%{
#include "ortools/linear_solver/linear_solver.h"
#include "ortools/linear_solver/model_exporter.h"
#include "ortools/linear_solver/model_exporter_swig_helper.h"
%}

%ignoreall

%unignore operations_research;

// Strip the "MP" prefix from the exposed classes.
%rename (Solver) operations_research::MPSolver;
%rename (Solver) operations_research::MPSolver::MPSolver;
%rename (Constraint) operations_research::MPConstraint;
%rename (Variable) operations_research::MPVariable;
%rename (Objective) operations_research::MPObjective;

// Expose the MPSolver::OptimizationProblemType enum.
%unignore operations_research::MPSolver::OptimizationProblemType;
%unignore operations_research::MPSolver::GLOP_LINEAR_PROGRAMMING;
%unignore operations_research::MPSolver::CLP_LINEAR_PROGRAMMING;
%unignore operations_research::MPSolver::GLPK_LINEAR_PROGRAMMING;
%unignore operations_research::MPSolver::SCIP_MIXED_INTEGER_PROGRAMMING;
%unignore operations_research::MPSolver::CBC_MIXED_INTEGER_PROGRAMMING;
%unignore operations_research::MPSolver::GLPK_MIXED_INTEGER_PROGRAMMING;
%unignore operations_research::MPSolver::BOP_INTEGER_PROGRAMMING;
%unignore operations_research::MPSolver::SAT_INTEGER_PROGRAMMING;
// These aren't unit tested, as they only run on machines with a Gurobi license.
%unignore operations_research::MPSolver::GUROBI_LINEAR_PROGRAMMING;
%unignore operations_research::MPSolver::GUROBI_MIXED_INTEGER_PROGRAMMING;
%unignore operations_research::MPSolver::CPLEX_LINEAR_PROGRAMMING;
%unignore operations_research::MPSolver::CPLEX_MIXED_INTEGER_PROGRAMMING;
%unignore operations_research::MPSolver::XPRESS_LINEAR_PROGRAMMING;
%unignore operations_research::MPSolver::XPRESS_MIXED_INTEGER_PROGRAMMING;


// Expose the MPSolver::ResultStatus enum.
%unignore operations_research::MPSolver::ResultStatus;
%unignore operations_research::MPSolver::OPTIMAL;
%unignore operations_research::MPSolver::FEASIBLE;  // No unit test
%unignore operations_research::MPSolver::INFEASIBLE;
%unignore operations_research::MPSolver::UNBOUNDED;  // No unit test
%unignore operations_research::MPSolver::ABNORMAL;
%unignore operations_research::MPSolver::NOT_SOLVED;  // No unit test

// Expose the MPSolver's basic API, with some renames.
%rename (Objective) operations_research::MPSolver::MutableObjective;
%rename (BoolVar) operations_research::MPSolver::MakeBoolVar;  // No unit test
%rename (IntVar) operations_research::MPSolver::MakeIntVar;
%rename (NumVar) operations_research::MPSolver::MakeNumVar;
%rename (Var) operations_research::MPSolver::MakeVar;
// We intentionally don't expose MakeRowConstraint(LinearExpr), because this
// "natural language" API is specific to C++: other languages may add their own
// syntactic sugar on top of MPSolver instead of this.
%rename (Constraint) operations_research::MPSolver::MakeRowConstraint(double, double);
%rename (Constraint) operations_research::MPSolver::MakeRowConstraint();
%rename (Constraint) operations_research::MPSolver::MakeRowConstraint(double, double, const std::string&);
%rename (Constraint) operations_research::MPSolver::MakeRowConstraint(const std::string&);
%unignore operations_research::MPSolver::~MPSolver;
%unignore operations_research::MPSolver::Solve;
%unignore operations_research::MPSolver::VerifySolution;
%unignore operations_research::MPSolver::infinity;
%unignore operations_research::MPSolver::set_time_limit;  // No unit test

// Proto-based API of the MPSolver. Use is encouraged.
%unignore operations_research::MPSolver::SolveWithProto;
%unignore operations_research::MPSolver::ExportModelToProto;
%unignore operations_research::MPSolver::FillSolutionResponseProto;
// LoadModelFromProto() is also visible: it's overridden by an %extend, above.
%unignore operations_research::MPSolver::LoadSolutionFromProto;  // No test

// Expose some of the more advanced MPSolver API.
%unignore operations_research::MPSolver::InterruptSolve;
%unignore operations_research::MPSolver::SupportsProblemType;  // No unit test
%unignore operations_research::MPSolver::wall_time;  // No unit test
%unignore operations_research::MPSolver::Clear;  // No unit test
%unignore operations_research::MPSolver::constraints;
%unignore operations_research::MPSolver::variables;
%unignore operations_research::MPSolver::NumConstraints;
%unignore operations_research::MPSolver::NumVariables;
%unignore operations_research::MPSolver::EnableOutput;  // No unit test
%unignore operations_research::MPSolver::SuppressOutput;  // No unit test
%rename (LookupConstraint)
    operations_research::MPSolver::LookupConstraintOrNull;
%rename (LookupVariable) operations_research::MPSolver::LookupVariableOrNull;
%unignore operations_research::MPSolver::SetSolverSpecificParametersAsString;
%unignore operations_research::MPSolver::NextSolution;
// %unignore operations_research::MPSolver::ExportModelAsLpFormat;
// %unignore operations_research::MPSolver::ExportModelAsMpsFormat;

// Expose very advanced parts of the MPSolver API. For expert users only.
%unignore operations_research::MPSolver::ComputeConstraintActivities;
%unignore operations_research::MPSolver::ComputeExactConditionNumber;
%unignore operations_research::MPSolver::nodes;
%unignore operations_research::MPSolver::iterations;  // No unit test
%unignore operations_research::MPSolver::BasisStatus;
%unignore operations_research::MPSolver::FREE;  // No unit test
%unignore operations_research::MPSolver::AT_LOWER_BOUND;
%unignore operations_research::MPSolver::AT_UPPER_BOUND;
%unignore operations_research::MPSolver::FIXED_VALUE;  // No unit test
%unignore operations_research::MPSolver::BASIC;

// MPVariable: writer API.
%unignore operations_research::MPVariable::SetLb;
%unignore operations_research::MPVariable::SetUb;
%unignore operations_research::MPVariable::SetBounds;

// MPVariable: reader API.
%unignore operations_research::MPVariable::solution_value;
%unignore operations_research::MPVariable::lb;
%unignore operations_research::MPVariable::ub;
%unignore operations_research::MPVariable::integer;  // No unit test
%unignore operations_research::MPVariable::name;  // No unit test
%unignore operations_research::MPVariable::index;  // No unit test
%unignore operations_research::MPVariable::basis_status;
%unignore operations_research::MPVariable::reduced_cost;  // For experts only.

// MPConstraint: writer API.
%unignore operations_research::MPConstraint::SetCoefficient;
%unignore operations_research::MPConstraint::SetLb;
%unignore operations_research::MPConstraint::SetUb;
%unignore operations_research::MPConstraint::SetBounds;
%unignore operations_research::MPConstraint::set_is_lazy;

// MPConstraint: reader API.
%unignore operations_research::MPConstraint::GetCoefficient;
%unignore operations_research::MPConstraint::lb;
%unignore operations_research::MPConstraint::ub;
%unignore operations_research::MPConstraint::name;
%unignore operations_research::MPConstraint::index;
%unignore operations_research::MPConstraint::basis_status;
%unignore operations_research::MPConstraint::dual_value;  // For experts only.

// MPObjective: writer API.
%unignore operations_research::MPObjective::SetCoefficient;
%unignore operations_research::MPObjective::SetMinimization;
%unignore operations_research::MPObjective::SetMaximization;
%unignore operations_research::MPObjective::SetOptimizationDirection;
%unignore operations_research::MPObjective::Clear;  // No unit test
%unignore operations_research::MPObjective::SetOffset;
%unignore operations_research::MPObjective::AddOffset;  // No unit test

// MPObjective: reader API.
%unignore operations_research::MPObjective::Value;
%unignore operations_research::MPObjective::GetCoefficient;
%unignore operations_research::MPObjective::minimization;
%unignore operations_research::MPObjective::maximization;
%unignore operations_research::MPObjective::offset;
%unignore operations_research::MPObjective::Offset;
%unignore operations_research::MPObjective::BestBound;

// MPSolverParameters API. For expert users only.
// TODO(user): also strip "MP" from the class name.
%unignore operations_research::MPSolverParameters;
%unignore operations_research::MPSolverParameters::MPSolverParameters;

// Expose the MPSolverParameters::DoubleParam enum.
%unignore operations_research::MPSolverParameters::DoubleParam;
%unignore operations_research::MPSolverParameters::RELATIVE_MIP_GAP;
%unignore operations_research::MPSolverParameters::PRIMAL_TOLERANCE;
%unignore operations_research::MPSolverParameters::DUAL_TOLERANCE;
%unignore operations_research::MPSolverParameters::GetDoubleParam;
%unignore operations_research::MPSolverParameters::SetDoubleParam;
%unignore operations_research::MPSolverParameters::kDefaultRelativeMipGap;
%unignore operations_research::MPSolverParameters::kDefaultPrimalTolerance;
%unignore operations_research::MPSolverParameters::kDefaultDualTolerance;
// TODO(user): unit test kDefaultPrimalTolerance.

// Expose the MPSolverParameters::IntegerParam enum.
%unignore operations_research::MPSolverParameters::IntegerParam;
%unignore operations_research::MPSolverParameters::PRESOLVE;
%unignore operations_research::MPSolverParameters::LP_ALGORITHM;
%unignore operations_research::MPSolverParameters::INCREMENTALITY;
%unignore operations_research::MPSolverParameters::SCALING;
%unignore operations_research::MPSolverParameters::GetIntegerParam;
%unignore operations_research::MPSolverParameters::SetIntegerParam;
%unignore operations_research::MPSolverParameters::RELATIVE_MIP_GAP;
%unignore operations_research::MPSolverParameters::kDefaultPrimalTolerance;
// TODO(user): unit test kDefaultPrimalTolerance.

// Expose the MPSolverParameters::PresolveValues enum.
%unignore operations_research::MPSolverParameters::PresolveValues;
%unignore operations_research::MPSolverParameters::PRESOLVE_OFF;
%unignore operations_research::MPSolverParameters::PRESOLVE_ON;
%unignore operations_research::MPSolverParameters::kDefaultPresolve;

// Expose the MPSolverParameters::LpAlgorithmValues enum.
%unignore operations_research::MPSolverParameters::LpAlgorithmValues;
%unignore operations_research::MPSolverParameters::DUAL;
%unignore operations_research::MPSolverParameters::PRIMAL;
%unignore operations_research::MPSolverParameters::BARRIER;

// Expose the MPSolverParameters::IncrementalityValues enum.
%unignore operations_research::MPSolverParameters::IncrementalityValues;
%unignore operations_research::MPSolverParameters::INCREMENTALITY_OFF;
%unignore operations_research::MPSolverParameters::INCREMENTALITY_ON;
%unignore operations_research::MPSolverParameters::kDefaultIncrementality;

// Expose the MPSolverParameters::ScalingValues enum.
%unignore operations_research::MPSolverParameters::ScalingValues;
%unignore operations_research::MPSolverParameters::SCALING_OFF;
%unignore operations_research::MPSolverParameters::SCALING_ON;

// Expose the model exporters.
%rename (ModelExportOptions) operations_research::MPModelExportOptions;
%rename (ModelExportOptions) operations_research::MPModelExportOptions::MPModelExportOptions;
%rename (ExportModelAsLpFormat) operations_research::ExportModelAsLpFormatReturnString;
%rename (ExportModelAsMpsFormat) operations_research::ExportModelAsMpsFormatReturnString;

// Added to prevent the SWIG error:
// ../../../ortools/linear_solver/linear_solver.h:734: Error: Syntax error in input(3).
// TODO there needs to be a better solution for this.
%define ABSL_MUST_USE_RESULT
%enddef

%include "ortools/linear_solver/linear_solver.h"
%include "ortools/linear_solver/model_exporter.h"
%include "ortools/linear_solver/model_exporter_swig_helper.h"

%unignoreall
