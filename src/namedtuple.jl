"""
    NamedTupleDifference <: AbstractDifference

Named tuple difference.
"""
struct NamedTupleDifference <: AbstractDifference
    modvals::NamedTuple
    addvals::NamedTuple
    remvals::NamedTuple
end

# Named tuple difference equality operator
Base.:(==)(a::NamedTupleDifference, b::NamedTupleDifference) =
    a.modvals == b.modvals && a.addvals == b.addvals && a.remvals == b.remvals

# Named tuple difference hash code
Base.hash(a::NamedTupleDifference, h::UInt) =
    hash(a.modvals, hash(a.addvals, hash(a.remvals,
        hash(:NamedTupleDifference, h))))

"""
    added(a::NamedTupleDifference)

Access the added elements.
"""
added(a::NamedTupleDifference) = a.addvals

"""
    removed(a::NamedTupleDifference)

Access the removed elements.
"""
removed(a::NamedTupleDifference) = a.remvals

"""
    modified(a::NamedTupleDifference)

Access the modified elements.
"""
modified(a::NamedTupleDifference) = a.modvals

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
