%include "std_vector.i"

namespace std {
  %template(IntVector) vector<int>;
  %template(Float32Vector) vector<float>;
  %template(Float64Vector) vector<double>;
  %template(StringVector) vector<string>;
}

using namespace std;
typedef std::vector Vector;

