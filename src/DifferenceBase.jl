module DifferenceBase

using OrderedCollections

import Base: ==, diff, hash, replace, replace!

export
    MatrixDifference,
    SetDifference,
    added,
    common,
    modified,
    removed

include("difference.jl")
include("matrix.jl")
include("set.jl")
include("utils.jl")

end # module
