"""
    SetDifference{Tc,Ta,Tr} <: AbstractDifference

Set difference.
"""
struct SetDifference{Tc,Ta,Tr} <: AbstractDifference
    comvals::Set{Tc}
    addvals::Set{Ta}
    remvals::Set{Tr}
end
SetDifference(comvals::AbstractVector{T}, addvals::AbstractVector{T},
            remvals::AbstractVector{T}) where {T} =
    SetDifference(Set(comvals), Set(addvals), Set(remvals))

# Set difference equality operator
Base.:(==)(a::SetDifference, b::SetDifference) =
    a.comvals == b.comvals && a.addvals == b.addvals && a.remvals == b.remvals

# Set difference hash code
Base.hash(a::SetDifference, h::UInt) =
    hash(a.comvals, hash(a.addvals, hash(a.remvals, hash(:SetDifference, h))))

"""
    added(a::SetDifference)

Access the added elements.
"""
added(a::SetDifference) = a.addvals

"""
    removed(a::SetDifference)

Access the removed elements.
"""
removed(a::SetDifference) = a.remvals

"""
    common(a::SetDifference)

Access the modified elements.
"""
common(a::SetDifference) = a.comvals

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
