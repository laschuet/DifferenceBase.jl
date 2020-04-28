"""
    MatrixDifference{Tm<:AbstracArray,Ta<:AbstractArray,Tr<:AbstractArray} <: AbstractDifference

Matrix difference.
"""
struct MatrixDifference{Tm<:AbstractArray,Ta<:AbstractArray,Tr<:AbstractArray} <: AbstractDifference
    modvals::Tm
    addvals::Ta
    remvals::Tr
end

# Matrix difference equality operator
==(a::MatrixDifference, b::MatrixDifference) =
    (a.modvals == b.modvals && a.addvals == b.addvals && a.remvals == b.remvals)

# Matrix difference hash code
hash(a::MatrixDifference, h::UInt) =
    hash(a.modvals, hash(a.addvals, hash(a.remvals,
        hash(:MatrixDifference, h))))

"""
    modified(a::MatrixDifference)

Access the modified elements.
"""
modified(a::MatrixDifference) = a.modvals

"""
    diff(A::AbstractMatrix, B::AbstractMatrix)

Compute the difference between matrix `A` and matrix `B`, and return a tuple
containing the elements that have been modified, added (per row and column), and
removed (per row and column).
"""
function diff(A::AbstractMatrix, B::AbstractMatrix)
    iadict = OrderedDict{Int,Int}(i => i for i = 1:size(A, 1))
    jadict = OrderedDict{Int,Int}(j => j for j = 1:size(A, 2))
    ibdict = OrderedDict{Int,Int}(i => i for i = 1:size(B, 1))
    jbdict = OrderedDict{Int,Int}(j => j for j = 1:size(B, 2))
    return _diff(A, B, iadict, jadict, ibdict, jbdict)
end

"""
    diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractVector, ja::AbstractVector, ib::AbstractVector, jb::AbstractVector)

Like [`diff`](@ref), but provide integer vectors that number the rows and
columns of the matrices `A` and `B`. The vector `ia` represents the row numbers
of `A`, and the vector `jb` represents the column numbers of `B` etc. The
position of each vector element refers to the row index (or column index
respectively) of `A` or `B`.
"""
function diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractVector,
            ja::AbstractVector, ib::AbstractVector, jb::AbstractVector)
    iadict = OrderedDict(zip(ia, 1:length(ia)))
    jadict = OrderedDict(zip(ja, 1:length(ja)))
    ibdict = OrderedDict(zip(ib, 1:length(ib)))
    jbdict = OrderedDict(zip(jb, 1:length(jb)))
    return _diff(A, B, iadict, jadict, ibdict, jbdict)
end

# Core matrix difference implementation
function _diff(A::AbstractMatrix, B::AbstractMatrix, ia::OrderedDict,
            ja::OrderedDict, ib::OrderedDict, jb::OrderedDict)
    T = promote_type(eltype(A), eltype(B))
    modvals = sparse([], [], T[])
    addvals = view(Vector{T}(undef, 0), :)
    remvals = view(Vector{T}(undef, 0), :)

    if size(A) == (0, 0) || size(B) == (0, 0)
        return modvals, addvals, remvals
    end

    iakeys = collect(keys(ia))
    jakeys = collect(keys(ja))
    ibkeys = collect(keys(ib))
    jbkeys = collect(keys(jb))

    # Compute modified values
    i = intersect(iakeys, ibkeys)
    j = intersect(jakeys, jbkeys)
    ia2 = replace(i, ia)
    ja2 = replace(j, ja)
    ib2 = replace(i, ib)
    jb2 = replace(j, jb)
    modvals = sparse(view(A, ia2, ja2) - view(B, ib2, jb2))

    # Compute added values
    indicesb = CartesianIndices(B)
    modindicesb = CartesianIndex.(Iterators.product(ib2, jb2))
    addindices = setdiff(indicesb, modindicesb)
    addvals = view(B, addindices)

    # Compute removed values
    indicesa = CartesianIndices(A)
    modindicesa = CartesianIndex.(Iterators.product(ia2, ja2))
    remindices = setdiff(indicesa, modindicesa)
    remvals = view(A, remindices)

    return modvals, addvals, remvals
end
