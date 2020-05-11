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
==(a::NamedTupleDifference, b::NamedTupleDifference) =
    (a.modvals == b.modvals && a.addvals == b.addvals && a.remvals == b.remvals)

# Named tuple difference hash code
hash(a::NamedTupleDifference, h::UInt) =
    hash(a.modvals, hash(a.addvals, hash(a.remvals,
        hash(:NamedTupleDifference, h))))

"""
    modified(a::NamedTupleDifference)

Access the modified elements.
"""
modified(a::NamedTupleDifference) = a.modvals
