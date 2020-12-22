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
    added(a::MatrixDifference)

Access the added elements.
"""
added(a::MatrixDifference) = a.addvals

"""
    removed(a::MatrixDifference)

Access the removed elements.
"""
removed(a::MatrixDifference) = a.remvals

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
    ia = collect(1:size(A, 1))
    ja = collect(1:size(A, 2))
    ib = collect(1:size(B, 1))
    jb = collect(1:size(B, 2))
    return diff(A, B, ia, ja, ib, jb)
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
    if size(A) == (0, 0) || size(B) == (0, 0)
        T = promote_type(eltype(A), eltype(B))
        modvals = sparse([], [], T[])
        addvals = view(Vector{T}(undef, 0), :)
        remvals = view(Vector{T}(undef, 0), :)
        return MatrixDifference(modvals, addvals, remvals)
    end

    iamap = Dict(zip(ia, 1:length(ia)))
    jamap = Dict(zip(ja, 1:length(ja)))
    ibmap = Dict(zip(ib, 1:length(ib)))
    jbmap = Dict(zip(jb, 1:length(jb)))

    # Compute modified values
    i = intersect(ia, ib)
    j = intersect(ja, jb)
    ia2 = replace(i, iamap)
    ja2 = replace(j, jamap)
    ib2 = replace(i, ibmap)
    jb2 = replace(j, jbmap)
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

    return MatrixDifference(modvals, addvals, remvals)
end
