module DifferenceBase

import Base: ==, hash

export
    MatrixDifference,
    SetDifference,
    added,
    common,
    modified,
    removed

include("matrix.jl")
include("set.jl")

end # module
