@testset "matrix difference" begin
    modvals = [1 2; 3 4]
    a = MatrixDifference(modvals, view([1 2], :, :), view([3 4], :, :))
    b = MatrixDifference(sparse(modvals), [1 2], [3 4])
    c = MatrixDifference(modvals, [1 2], [3 4])

    @testset "constructors" begin
        @test isa(a, MatrixDifference) && isa(b, MatrixDifference)
        @test a.modvals == modvals && a.addvals == [1 2] && a.remvals == [3 4]
        @test (b.modvals == sparse(modvals) && b.addvals == [1 2]
                && b.remvals == [3 4])
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
        @test added(a) == [1 2]
        @test removed(a) == [3 4]
    end

    @testset "difference" begin
        A = [1 0 1; 0 1 0; 0 0 1]
        B = [1 1 1 1; 1 1 1 1]
        ia = [1, 2, 5]
        ja = [2, 8, 11]
        ib = [1, 8]
        jb = [2, 3, 4, 11]
        E = Vector(undef, 0)
        @test diff(A, A, ia, ja, ia, ja) == (sparse([0 0 0; 0 0 0; 0 0 0]), E, E)
        @test diff(A, B, ia, ja, ib, jb) == (sparse([0 0]), [1, 1, 1, 1, 1, 1], [0, 0, 0, 1, 0, 0, 1])
        @test diff(B, A, ib, jb, ia, ja) == (sparse([0 0]), [0, 0, 0, 1, 0, 0, 1], [1, 1, 1, 1, 1, 1])
        @test diff(A, A) == (sparse([0 0 0; 0 0 0; 0 0 0]), E, E)
        @test diff(A, B) == (sparse([0 -1 0; -1 0 -1]), [1, 1], [0, 0, 1])
        @test diff(B, A) == (sparse([0 1 0; 1 0 1]), [0, 0, 1], [1, 1])
    end
end
