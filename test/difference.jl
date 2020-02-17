@testset "difference" begin
    @testset "matrix" begin
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

    @testset "set" begin
        a = Set([1, 2, 3, 3])
        b = Set([4, 2, 1])
        @test diff(a, a) == (Set([1, 2, 3]), Set([]), Set([]))
        @test diff(a, b) == (Set([1, 2]), Set([4]), Set([3]))
        @test diff(b, a) == (Set([2, 1]), Set([3]), Set([4]))
    end
end
