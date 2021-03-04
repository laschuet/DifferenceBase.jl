@testset "vector difference" begin
    modinds = [1, 2, 3, 4]
    addinds = [5, 6]
    reminds = [7, 8]
    modvals = [1, 2, 3, 4]
    addvals = [1, 2]
    remvals = [3, 4]
    a = VectorDifference(
        modinds, addinds, reminds, modvals, view(addvals, :), view(remvals, :)
    )
    b = VectorDifference(modinds, addinds, reminds, sparse(modvals), addvals, remvals)
    c = VectorDifference(modinds, addinds, reminds, modvals, addvals, remvals)

    @testset "constructors" begin
        @test isa(a, VectorDifference) && isa(b, VectorDifference)
        @test (
            a.modinds == modinds &&
            a.addinds == addinds &&
            a.reminds == reminds &&
            a.modvals == modvals &&
            a.addvals == addvals &&
            a.remvals == remvals
        )
        @test (
            b.modinds == modinds &&
            b.addinds == addinds &&
            b.reminds == reminds &&
            b.modvals == sparse(modvals) &&
            b.addvals == addvals &&
            b.remvals == remvals
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
        @test modified(a) == modvals
        @test added(a) == addvals
        @test removed(a) == remvals
    end

    @testset "difference" begin
        a = [1, 2, 5]
        b = [2, 3, 5, 7]
        ia = [1, 2, 5]
        ib = [2, 3, 5, 7]
        e = []
        ei = Int[]
        se = sparse(e)
        @test diff(e, e) == VectorDifference(ei, ei, ei, se, e, e)
        @test diff(e, a) == VectorDifference(ei, ei, ei, se, a, e)
        @test diff(a, e) == VectorDifference(ei, ei, ei, se, a, e)
        @test (diff(a, a) == VectorDifference([1, 2, 3], ei, ei, sparse([0, 0, 0]), e, e))
        @test (
            diff(a, b) == VectorDifference([1, 2, 3], [4], ei, sparse([-1, -1, 0]), [7], e)
        )
        @test (
            diff(b, a) == VectorDifference([1, 2, 3], ei, [4], sparse([1, 1, 0]), e, [7])
        )
        @test (
            diff(a, a, ia, ia) ==
            VectorDifference([1, 2, 5], ei, ei, sparse([0, 0, 0]), e, e)
        )
        @test (
            diff(a, b, ia, ib) ==
            VectorDifference([2, 5], [3, 7], [1], sparse([0, 0]), [3, 7], [1])
        )
        @test (
            diff(b, a, ib, ia) ==
            VectorDifference([2, 5], [1], [3, 7], sparse([0, 0]), [1], [3, 7])
        )
    end
end
