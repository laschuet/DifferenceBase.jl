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
    addivals = view(Matrix{T}(undef, 0, 0), :, :)
    addjvals = view(Matrix{T}(undef, 0, 0), :, :)
    remivals = view(Matrix{T}(undef, 0, 0), :, :)
    remjvals = view(Matrix{T}(undef, 0, 0), :, :)

    if size(A) == (0, 0) || size(B) == (0, 0)
        return modvals, addivals, addjvals, remivals, remjvals
    end

    iakeys = collect(keys(ia))
    jakeys = collect(keys(ja))
    ibkeys = collect(keys(ib))
    jbkeys = collect(keys(jb))

    # Compute modified values
    i = intersect(iakeys, ibkeys)
    j = intersect(jakeys, jbkeys)
    if length(i) > 0 && length(j) > 0
        ia2 = replace(i, ia)
        ja2 = replace(j, ja)
        ib2 = replace(i, ib)
        jb2 = replace(j, jb)
        modvals = sparse(view(A, ia2, ja2) - view(B, ib2, jb2))
    end

    # Compute added values
    i = setdiff(ibkeys, iakeys)
    j = setdiff(jbkeys, jakeys)
    if length(i) > 0 && length(j) <= 0
        # Only rows have been added
        replace!(i, ib)
        addivals = view(B, i, :)
    end
    if length(i) <= 0 && length(j) > 0
        # Only columns have been added
        replace!(j, jb)
        addjvals = view(B, :, j)
    end
    if length(i) > 0 && length(j) > 0
        # Rows and columns have been added
        replace!(i, ib)
        replace!(j, jb)
        addivals = view(B, i, :)
        addjvals = view(B, :, j)
    end

    # Compute removed values
    i = setdiff(iakeys, ibkeys)
    j = setdiff(jakeys, jbkeys)
    if length(i) > 0 && length(j) <= 0
        # Only rows have been removed
        replace!(i, ia)
        remivals = view(A, i, :)
    end
    if length(i) <= 0 && length(j) > 0
        # Only columns have been removed
        replace!(j, ja)
        remjvals = view(A, :, j)
    end
    if length(i) > 0 && length(j) > 0
        # Rows and columns have been removed
        replace!(i, ia)
        replace!(j, ja)
        remivals = view(A, i, :)
        remjvals = view(A, :, j)
    end

    return modvals, addivals, addjvals, remivals, remjvals
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
diff(a::AbstractSet, b::AbstractSet) =
    intersect(a, b), setdiff(b, a), setdiff(a, b)
