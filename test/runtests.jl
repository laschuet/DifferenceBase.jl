using DifferenceBase
using SparseArrays
using Test

@testset "DifferenceBase" begin
    include("difference.jl")
    include("matrix.jl")
    include("set.jl")
    include("utils.jl")
end
