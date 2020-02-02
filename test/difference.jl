@testset "difference" begin
    @testset "set" begin
        a = Set([1, 2, 3, 3])
        b = Set([4, 2, 1])
        @test diff(a, a) == (Set([1, 2, 3]), Set([]), Set([]))
        @test diff(a, b) == (Set([1, 2]), Set([4]), Set([3]))
        @test diff(b, a) == (Set([2, 1]), Set([3]), Set([4]))
    end
end
