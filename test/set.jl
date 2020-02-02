@testset "set difference" begin
    a = SetDifference([1], [2, 3], [4, 5])
    b = SetDifference([1], [2, 3], [4, 5])
    c = SetDifference([1], [2, 3], [4, 5])

    @testset "constructors" begin
        @test isa(a, SetDifference)
        @test a.comvals == [1] && a.addvals == [2, 3] && a.remvals == [4, 5]
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
        @test common(a) == [1]
        @test added(a) == [2, 3]
        @test removed(a) == [4, 5]
    end
end
