module DifferenceBase

import Base: ==, hash

export
    MatrixDifference,
    added,
    modified,
    removed

include("matrix.jl")

end # module
