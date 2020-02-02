@testset "matrix difference" begin
    modvals = [1 2; 3 4]
    E = Matrix(undef, 0, 0)
    a = MatrixDifference(modvals, view([1 2], :, :), view([3 4], :, :), E, E)
    b = MatrixDifference(sparse(modvals), [1 2], [3 4], E, E)
    c = MatrixDifference(modvals, [1 2], [3 4], E, E)

    @testset "constructors" begin
        @test isa(a, MatrixDifference) && isa(b, MatrixDifference)
        @test (a.modvals == modvals && a.addivals == [1 2]
                && a.addjvals == [3 4] && a.remivals == E && a.remjvals == E)
        @test (b.modvals == sparse(modvals) && b.addivals == [1 2]
                && b.addjvals == [3 4] && b.remivals == E && b.remjvals == E)
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
        @test modified(a) == modvals
        @test added(a) == ([1 2], [3 4])
        @test added(a, 1) == [1 2] && added(a, 2) == [3 4]
        @test removed(a) == (E, E)
        @test removed(a, 1) == E && removed(a, 2) == E
    end
end
