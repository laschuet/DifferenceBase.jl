"""
    diff(a::Set, b::Set)

Compute the difference between set `a` and set `b`, and return a tuple
containing the unique elements that have been shared, added and removed.

# Examples
```jldoctest
julia> diff(Set([1, 2, 3, 3]), Set([4, 2, 1]))
(Set([1, 2]), Set([4]), Set([3]))
```
"""
diff(a::Set, b::Set) = intersect(a, b), setdiff(b, a), setdiff(a, b)
