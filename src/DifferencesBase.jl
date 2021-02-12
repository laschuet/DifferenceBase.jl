module DifferencesBase

using SparseArrays

export
    AbstractDifference,
    MatrixDifference,
    NamedTupleDifference,
    SetDifference,
    added,
    common,
    modified,
    removed

include("difference.jl")
include("matrix.jl")
include("namedtuple.jl")
include("set.jl")

end # module
