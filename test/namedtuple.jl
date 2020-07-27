@testset "named tuple difference" begin
    a = NamedTupleDifference((x1=1, x2=[0.0, 1.0]), NamedTuple(), (z=3,))
    b = NamedTupleDifference((x1=1, x2=[0.0, 1.0]), NamedTuple(), (z=3,))
    c = NamedTupleDifference((x1=1, x2=[0.0, 1.0]), NamedTuple(), (z=3,))

    @testset "constructors" begin
        @test isa(a, NamedTupleDifference)
        @test (a.modvals == (x1=1, x2=[0.0, 1.0]) && a.addvals == NamedTuple()
                && a.remvals == (z=3,))
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
        @test modified(a) == (x1=1, x2=[0.0, 1.0])
        @test added(a) == NamedTuple()
        @test removed(a) == (z=3,)
    end

    @testset "difference" begin
        a = (x=1,)
        b = (x=(s=1, t=2),)
        c = (x=[1 2],)
        d = (x=2, y=1)

        @test diff(a, a) == NamedTupleDifference(
            (x=0,),
            NamedTuple(),
            NamedTuple(),
        )
        @test diff(b, b) == NamedTupleDifference(
            (x=NamedTupleDifference((s=0, t=0), NamedTuple(), NamedTuple()),),
            NamedTuple(),
            NamedTuple(),
        )
        @test diff(c, c) == NamedTupleDifference(
            (x=MatrixDifference([0 0], [], []),),
            NamedTuple(),
            NamedTuple(),
        )

        @test diff(a, d) == NamedTupleDifference((x=-1,), (y=1,), NamedTuple())
        @test diff(d, a) == NamedTupleDifference((x=1,), NamedTuple(), (y=1,))
    end
end
