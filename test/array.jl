@testset "array difference" begin
    modvals = [1 2; 3 4]
    a = ArrayDifference(modvals, view([1 2], :, :), view([3 4], :, :))
    b = ArrayDifference(sparse(modvals), [1 2], [3 4])
    c = ArrayDifference(modvals, [1 2], [3 4])

    @testset "constructors" begin
        @test isa(a, ArrayDifference) && isa(b, ArrayDifference)
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

    @testset "vector difference" begin
        a = [1, 2, 5]
        b = [2, 3, 5, 7]
        ia = [1, 2, 5]
        ib = [2, 3, 5, 7]
        @test diff(a, a, ia, ia) == VectorDifference(sparse([0, 0, 0]), [], [])
        @test diff(a, b, ia, ib) == VectorDifference(sparse([0, 0]), [3, 7], [1])
        @test diff(b, a, ib, ia) == VectorDifference(sparse([0, 0]), [1], [3, 7])
        @test diff(a, a) == VectorDifference(sparse([0, 0, 0]), [], [])
        @test diff(a, b) == VectorDifference(sparse([-1, -1, 0]), [7], [])
        @test diff(b, a) == VectorDifference(sparse([1, 1, 0]), [], [7])
    end

    @testset "matrix difference" begin
        A = [1 0 1; 0 1 0; 0 0 1]
        B = [1 1 1 1; 1 1 1 1]
        ia = [1, 2, 5]
        ja = [2, 8, 11]
        ib = [1, 8]
        jb = [2, 3, 4, 11]
        @test diff(A, A, ia, ja, ia, ja) == MatrixDifference(sparse([0 0 0; 0 0 0; 0 0 0]), [], [])
        @test diff(A, B, ia, ja, ib, jb) == MatrixDifference(sparse([0 0]), [1, 1, 1, 1, 1, 1], [0, 0, 0, 1, 0, 0, 1])
        @test diff(B, A, ib, jb, ia, ja) == MatrixDifference(sparse([0 0]), [0, 0, 0, 1, 0, 0, 1], [1, 1, 1, 1, 1, 1])
        @test diff(A, A) == MatrixDifference(sparse([0 0 0; 0 0 0; 0 0 0]), [], [])
        @test diff(A, B) == MatrixDifference(sparse([0 -1 0; -1 0 -1]), [1, 1], [0, 0, 1])
        @test diff(B, A) == MatrixDifference(sparse([0 1 0; 1 0 1]), [0, 0, 1], [1, 1])
    end
end
