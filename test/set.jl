@testset "set difference" begin
    a = SetDifference(Set([1]), Set([2, 3]), Set([4, 5]))
    b = SetDifference(Set([1]), Set([2, 3]), Set([4, 5]))
    c = SetDifference(Set([1]), Set([2, 3]), Set([4, 5]))

    @testset "constructors" begin
        @test isa(a, SetDifference)
        @test (
            a.comvals == Set([1]) && a.addvals == Set([2, 3]) && a.remvals == Set([4, 5])
        )
    end

    @testset "equality operator" begin
        @test a == a
        @test a == b && b == a
        @test a == b && b == c && a == c
    end

    @testset "hash" begin
        @test hash(a) == hash(a)
        @test a == b && hash(a) == hash(b)
    end

    @testset "accessors" begin
        @test common(a) == Set([1])
        @test added(a) == Set([2, 3])
        @test removed(a) == Set([4, 5])
    end

    @testset "difference" begin
        a = Set([1, 2, 3, 3])
        b = Set([4, 2, 1])
        @test diff(a, a) == SetDifference(Set([1, 2, 3]), Set(Int[]), Set(Int[]))
        @test diff(a, b) == SetDifference(Set([1, 2]), Set([4]), Set([3]))
        @test diff(b, a) == SetDifference(Set([2, 1]), Set([3]), Set([4]))
    end

    @testset "math" begin
        a = Set([1, 5, 3])
        b = Set([1, 4, 2, 3])
        d = SetDifference(Set([1, 3]), Set([4, 2]), Set([5]))
        @test a + d == b
        @test d + a == b
    end
end
