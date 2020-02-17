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
end
