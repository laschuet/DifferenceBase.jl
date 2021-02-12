"""
    diff(A::AbstractMatrix, B::AbstractMatrix)

Compute the difference between matrix `A` and matrix `B`, and return a tuple
containing the elements that have been modified, added (per row and column), and
removed (per row and column).
"""
function Base.diff(A::AbstractMatrix, B::AbstractMatrix)
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
function Base.diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractVector,
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
    ia2 = getindex.(Ref(iamap), i)
    ja2 = getindex.(Ref(jamap), j)
    ib2 = getindex.(Ref(ibmap), i)
    jb2 = getindex.(Ref(jbmap), j)
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

"""
    diff(a::NamedTuple, b::NamedTuple)

Compute the difference between named tuple `a` and named tuple `b`, and return a
tuple containing the unique elements that have been modified, added, and
removed.
"""
function Base.diff(a::NamedTuple, b::NamedTuple)
    modnames = intersect(keys(a), keys(b))
    addnames = setdiff(keys(b), keys(a))
    remnames = setdiff(keys(a), keys(b))

    # Compute modified values
    modvalues = []
    for n in modnames
        typeof(a[n]) != typeof(b[n]) && throw(ArgumentError("type of values of common names in `a` and `b` must match"))
        v = typeof(a[n]) <: Number ? a[n] - b[n] : diff(a[n], b[n])
        push!(modvalues, v)
    end
    modvals = (; zip(modnames, modvalues)...)

    # Compute added values
    addvalues = []
    for n in addnames
        push!(addvalues, b[n])
    end
    addvals = (; zip(addnames, addvalues)...)

    # Compute removed values
    remvalues = []
    for n in remnames
        push!(remvalues, a[n])
    end
    remvals = (; zip(remnames, remvalues)...)

    return NamedTupleDifference(modvals, addvals, remvals)
end

"""
    diff(a::AbstractSet, b::AbstractSet)

Compute the difference between set `a` and set `b`, and return a tuple
containing the unique elements that have been shared, added, and removed.

# Examples
```jldoctest
julia> diff(Set([1, 2, 3, 3]), Set([4, 2, 1]))
(Set([1, 2]), Set([4]), Set([3]))
```
"""
Base.diff(a::AbstractSet, b::AbstractSet) =
    SetDifference(intersect(a, b), setdiff(b, a), setdiff(a, b))
