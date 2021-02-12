using DifferencesBase
using SparseArrays
using Test

@testset "DifferencesBase" begin
    include("array.jl")
    include("namedtuple.jl")
    include("set.jl")
end
