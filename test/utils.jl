@testset "utils" begin
    @testset "replace, replace!" begin
        a = [1, 2, 3]
        dict = Dict(1 => 11, 2 => 22)

        @test replace(a, dict) == [11, 22, 3]
        @test a == [1, 2, 3]

        @test replace!(a, dict) == [11, 22, 3]
        @test a == [11, 22, 3]
    end
end
