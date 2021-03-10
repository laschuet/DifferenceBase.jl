@testset "dictionary difference" begin
    modvals = Dict(:x1=>1, :x2=>[0.0, 1.0])
    addvals = Dict()
    remvals = Dict(:z=>3)
    a = DictDifference(modvals, addvals, remvals)
    b = DictDifference(modvals, addvals, remvals)
    c = DictDifference(modvals, addvals, remvals)

    @testset "constructors" begin
        @test isa(a, DictDifference)
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
        a = Dict(:x=>1)
        b = Dict(:x=>Dict(:s=>1, :t=>2))
        c = Dict(:x=>[1, 2])
        d = Dict(:x=>2, :y=>1)
        ev = []
        evi = Int[]
        ed = Dict()
        @test diff(a, a) == DictDifference(Dict(:x=>0), ed, ed)
        @test diff(b, b) == DictDifference(
            Dict(:x => DictDifference(Dict(:s=>0, :t=>0), ed, ed)), ed, ed
        )
        @test diff(c, c) == DictDifference(
            Dict(:x => VectorDifference([1, 2], evi, evi, [0, 0], ev, ev)), ed, ed
        )
        @test diff(a, d) == DictDifference(Dict(:x=>-1), Dict(:y=>1), ed)
        @test diff(d, a) == DictDifference(Dict(:x=>1), ed, Dict(:y=>1))
    end

    @testset "math" begin
        a = Dict(:x=>1, :y=>2)
        b = Dict(:y=>4, :z=>8)
        d = DictDifference(Dict(:y=>2), Dict(:z=>8), Dict(:x=>1))
        @test a + d == b
        @test d + a == b
    end
end
