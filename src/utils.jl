"""
    replace(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}

Return a copy of `a` where each element `x` in `a` is replaced by the value
stored for the key `x` in `d`. If no mapping for the key `x` is present in `d`,
`x` is not replaced.
"""
function replace(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}
    t = similar(a)
    @inbounds for i = 1:length(a)
        t[i] = get(d, a[i], a[i])
    end
    return t
end

"""
    replace!(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}

Like [`replace`](@ref), but replace the values in-place.
"""
function replace!(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}
    @inbounds for i = 1:length(a)
        a[i] = get(d, a[i], a[i])
    end
    return a
end
