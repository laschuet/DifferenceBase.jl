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

include("types.jl")
include("differences.jl")

end # module
