using DifferencesBase
using SparseArrays
using Test

@testset "DifferencesBase" begin
    include("difference.jl")
    include("matrix.jl")
    include("set.jl")
    include("utils.jl")
end