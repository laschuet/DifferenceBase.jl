module DifferenceBase

import Base: ==, diff, hash

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

end # module
