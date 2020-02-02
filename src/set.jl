"""
    SetDifference{T}

Set difference.
"""
struct SetDifference{T}
    comvals::Vector{T}
    addvals::Vector{T}
    remvals::Vector{T}
end

# Set difference equality operator
==(a::SetDifference, b::SetDifference) =
    a.comvals == b.comvals && a.addvals == b.addvals && a.remvals == b.remvals

# Set difference hash code
hash(a::SetDifference, h::UInt) =
    hash(a.comvals, hash(a.addvals, hash(a.remvals, hash(:SetDifference, h))))

"""
    common(a::SetDifference)

Access the common elements.
"""
common(a::SetDifference) = a.comvals

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
