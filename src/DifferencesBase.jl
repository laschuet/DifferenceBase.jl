module DifferencesBase

using OrderedCollections
using SparseArrays

import Base: ==, diff, hash, replace, replace!

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
include("utils.jl")

end # module
