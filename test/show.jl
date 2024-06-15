@testset "show" begin
    @testset "vector" begin
        a = VectorDifference([3], [1], [2], [-1], [3], [4])
        @test sprint(show, MIME("text/plain"), a) == """
        VectorDifference with indices:
         modified: [3]
         added: [1]
         removed: [2]
        and values:
         common: [-1]
         added: [3]
         removed: [4]"""
    end

    @testset "matrix" begin
        a = MatrixDifference(([1], [1]), ([2], [2]), ([3], [3]), [1], [2, 2], [3, 3])
        @test sprint(show, MIME("text/plain"), a) == """
        MatrixDifference with indices:
         modified: ([1], [1])
         added: ([2], [2])
         removed: ([3], [3])
        and values:
         common: [1]
         added: [2, 2]
         removed: [3, 3]"""
    end

    @testset "dictionary" begin
        a = DictDifference(Dict(:x=>1, :y=>[0.0, 1.0]), Dict(), Dict(:z=>3))
        @test sprint(show, MIME("text/plain"), a) == """
        DictDifference with values:
         modified: Dict{Symbol, Any}(:y => [0.0, 1.0], :x => 1)
         added: Dict{Any, Any}()
         removed: Dict(:z => 3)"""
    end

    @testset "named tuple" begin
        a = NamedTupleDifference((x=1, y=[0.0, 1.0]), NamedTuple(), (z=3,))
        @test sprint(show, MIME("text/plain"), a) == """
        NamedTupleDifference with values:
         modified: (x = 1, y = [0.0, 1.0])
         added: NamedTuple()
         removed: (z = 3,)"""
    end

    @testset "set" begin
        a = SetDifference(Set([]), Set([]))
        @test sprint(show, MIME("text/plain"), a) == """
        SetDifference with values:
         added: Set{Any}()
         removed: Set{Any}()"""
    end
end
