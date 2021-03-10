@testset "set difference" begin
    comvals = Set([1])
    addvals = Set([2, 3])
    remvals = Set([4, 5])
    a = SetDifference(comvals, addvals, remvals)
    b = SetDifference(comvals, addvals, remvals)
    c = SetDifference(comvals, addvals, remvals)

    @testset "constructors" begin
        @test isa(a, SetDifference)
        @test a.comvals == comvals && a.addvals == addvals && a.remvals == remvals
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
        @test common(a) == comvals
        @test added(a) == addvals
        @test removed(a) == remvals
    end

    @testset "difference" begin
        a = Set([1, 2, 3, 3])
        b = Set([4, 2, 1])
        ei = Int[]
        @test diff(a, a) == SetDifference(Set([1, 2, 3]), Set(ei), Set(ei))
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
