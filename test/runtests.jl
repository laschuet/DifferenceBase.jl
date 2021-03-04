using DifferencesBase
using SparseArrays
using Test

@testset "DifferencesBase" begin
    include("vector.jl")
    include("matrix.jl")
    include("namedtuple.jl")
    include("set.jl")
end
