@testset "named tuple difference" begin
    modvals = (x1=1, x2=[0.0, 1.0])
    addvals = NamedTuple()
    remvals = (z=3,)
    a = NamedTupleDifference(modvals, addvals, remvals)
    b = NamedTupleDifference(modvals, addvals, remvals)
    c = NamedTupleDifference(modvals, addvals, remvals)

    @testset "constructors" begin
        @test isa(a, NamedTupleDifference)
        @test a.modvals == modvals && a.addvals == addvals && a.remvals == remvals
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
        a = (x=1,)
        b = (x=(s=1, t=2),)
        c = (x=[1, 2],)
        d = (x=2, y=1)
        e = []
        ei = Int[]
        ent = NamedTuple()
        @test diff(a, a) == NamedTupleDifference((x=0,), ent, ent)
        @test diff(b, b) == NamedTupleDifference(
            (x=NamedTupleDifference((s=0, t=0), ent, ent),), ent, ent
        )
        @test diff(c, c) == NamedTupleDifference(
            (x=VectorDifference([1, 2], ei, ei, [0, 0], e, e),), ent, ent
        )
        @test diff(a, d) == NamedTupleDifference((x=-1,), (y=1,), ent)
        @test diff(d, a) == NamedTupleDifference((x=1,), ent, (y=1,))
    end
end
