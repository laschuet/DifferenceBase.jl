using DifferencesBase
using SparseArrays
using Test

@testset "DifferencesBase" begin
    include("vector.jl")
    include("matrix.jl")
    include("dict.jl")
    include("namedtuple.jl")
    include("set.jl")
    include("show.jl")
end
