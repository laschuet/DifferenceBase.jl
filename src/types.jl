"""
    AbstractDifference

Supertype for differences.
"""
abstract type AbstractDifference end

"""
    ArrayDifference{Tm<:AbstractVector,Ta<:AbstractVector,Tr<:AbstractVector} <: AbstractDifference

Array difference.
"""
struct ArrayDifference{Tm<:AbstractVector,Ta<:AbstractVector,Tr<:AbstractVector} <: AbstractDifference
    modvals::Tm
    addvals::Ta
    remvals::Tr
end
const VectorDifference = ArrayDifference
const MatrixDifference = ArrayDifference

"""
    NamedTupleDifference <: AbstractDifference

Named tuple difference.
"""
struct NamedTupleDifference{Tm<:NamedTuple,Ta<:NamedTuple,Tr<:NamedTuple} <: AbstractDifference
    modvals::Tm
    addvals::Ta
    remvals::Tr
end

"""
    SetDifference{T} <: AbstractDifference

Set difference.
"""
struct SetDifference{Tc,Ta,Tr} <: AbstractDifference
    comvals::Set{Tc}
    addvals::Set{Ta}
    remvals::Set{Tr}
end

# Equality operator
function Base.:(==)(a::Ta, b::Tb) where {Ta<:AbstractDifference,Tb<:AbstractDifference}
    a === b && return true
    nameof(Ta) == nameof(Tb) || return false
    fields = fieldnames(Ta)
    fields === fieldnames(Tb) || return false
    for f in fields
        getfield(a, f) == getfield(b, f) || return false
    end
    return true
end

# Hash code
function Base.hash(a::T, h::UInt) where T<:AbstractDifference
    hashval = hash(:T, h)
    for f in fieldnames(T)
        hashval = hash(getfield(a, f), hashval)
    end
    return hashval
end

"""
    added(a::AbstractDifference)

Access the added elements.
"""
added(a::AbstractDifference) = a.addvals

"""
    removed(a::AbstractDifference)

Access the removed elements.
"""
removed(a::AbstractDifference) = a.remvals

"""
    modified(a::Union{ArrayDifference,NamedTupleDifference})

Access the modified elements.
"""
modified(a::Union{ArrayDifference,NamedTupleDifference}) = a.modvals

"""
    common(a::SetDifference)

Access the common elements.
"""
common(a::SetDifference) = a.comvals
