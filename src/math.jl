# Addition operator

Base.:(+)(::AbstractSet, d::SetDifference) = union(d.comvals, d.addvals)
Base.:(+)(d::SetDifference, a::AbstractSet) = +(a, d)

function Base.:(+)(a::NamedTuple, d::NamedTupleDifference)
    result = d.addvals
    modkeys = keys(d.modvals)
    for key in modkeys
        result = merge(result, [key => a[key] + d.modvals[key]])
    end
    return result
end
Base.:(+)(d::NamedTupleDifference, a::NamedTuple) = +(a, d)
