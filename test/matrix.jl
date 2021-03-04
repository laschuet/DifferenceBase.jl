@testset "matrix difference" begin
    modinds = ([1, 2], [1, 2])
    addinds = ([3, 4], [3])
    reminds = ([5, 6], [5])
    modvals = [1, 2, 3, 4]
    addvals = [1, 2]
    remvals = [3, 4]
    a = MatrixDifference(modinds, addinds, reminds, modvals, view(addvals, :), view(remvals, :))
    b = MatrixDifference(modinds, addinds, reminds, sparse(modvals), addvals, remvals)
    c = MatrixDifference(modinds, addinds, reminds, modvals, addvals, remvals)

    @testset "constructors" begin
        @test isa(a, MatrixDifference) && isa(b, MatrixDifference)
        @test (a.modinds == modinds && a.addinds == addinds
                && a.reminds == reminds && a.modvals == modvals
                && a.addvals == addvals && a.remvals == remvals)
        @test (b.modinds == modinds && b.addinds == addinds
                && b.reminds == reminds && b.modvals == sparse(modvals)
                && b.addvals == addvals && b.remvals == remvals)
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
        @test added(a) == addvals
        @test removed(a) == remvals
    end

    @testset "difference" begin
        A = [1 0 1; 0 1 0; 0 0 1]
        B = [1 1 1 1; 1 1 1 1]
        ia = [1, 2, 5]
        ja = [2, 8, 11]
        ib = [1, 8]
        jb = [2, 3, 4, 11]
        E = Matrix(undef, 0, 0)
        e = Int[]
        @test diff(E, E) == MatrixDifference((e, e), (e, e), (e, e), sparse([]), [], [])
        @test diff(E, A) == MatrixDifference((e, e), (e, e), (e, e), sparse([]), vec(A), vec(E))
        @test diff(A, E) == MatrixDifference((e, e), (e, e), (e, e), sparse([]), vec(A), vec(E))
        @test diff(A, A) == MatrixDifference(([1, 2, 3], [1, 2, 3]), (e, e), (e, e),
                sparse([0, 0, 0, 0, 0, 0, 0, 0, 0]), [], [])
        @test diff(A, B) == MatrixDifference(([1, 2], [1, 2, 3]), (e, [4]), ([3], e),
                sparse([0, -1, -1, 0, 0, -1]), [1, 1], [0, 0, 1])
        @test diff(B, A) == MatrixDifference(([1, 2], [1, 2, 3]), ([3], e), (e, [4]),
                sparse([0, 1, 1, 0, 0, 1]), [0, 0, 1], [1, 1])
        @test diff(A, A, ia, ja, ia, ja) == MatrixDifference(([1, 2, 5], [2, 8, 11]), (e, e), (e, e),
                sparse([0, 0, 0, 0, 0, 0, 0, 0, 0]), [], [])
        @test diff(A, B, ia, ja, ib, jb) == MatrixDifference(([1], [2, 11]), ([8], [3, 4]), ([2, 5], [8]),
                sparse([0, 0]), [1, 1, 1, 1, 1, 1], [0, 0, 0, 1, 0, 0, 1])
        @test diff(B, A, ib, jb, ia, ja) == MatrixDifference(([1], [2, 11]), ([2, 5], [8]), ([8], [3, 4]),
                sparse([0, 0]), [0, 0, 0, 1, 0, 0, 1], [1, 1, 1, 1, 1, 1])
    end
end
