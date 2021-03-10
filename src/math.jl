# Addition operator

Base.:(+)(::AbstractSet, d::SetDifference) = union(d.comvals, d.addvals)
Base.:(+)(d::SetDifference, a::AbstractSet) = +(a, d)

function Base.:(+)(a::AbstractDict, d::DictDifference)
    result = d.addvals
    modkeys = keys(d.modvals)
    for k in modkeys
        typeof(a[k]) != typeof(d.modvals[k]) &&
            throw(ArgumentError("type of values of common keys in `a` and `d` must match"))
        result = merge(result, Dict(k=>a[k] + d.modvals[k]))
    end
    return result
end
Base.:(+)(d::DictDifference, a::AbstractDict) = +(a, d)
