"""
    MatrixDifference{Tm<:AbstractMatrix,Ta<:AbstractMatrix,Tr<:AbstractMatrix}

Matrix difference.
"""
struct MatrixDifference{Tm<:AbstractMatrix,Ta<:AbstractMatrix,Tr<:AbstractMatrix}
    modvals::Tm
    addivals::Ta
    addjvals::Ta
    remivals::Tr
    remjvals::Tr
end

# Matrix difference equality operator
==(a::MatrixDifference, b::MatrixDifference) =
    (a.modvals == b.modvals && a.addivals == b.addivals
            && a.addjvals == b.addjvals && a.remivals == b.remivals
            && a.remjvals == b.remjvals)

# Matrix difference hash code
hash(a::MatrixDifference, h::UInt) =
    hash(a.modvals, hash(a.addivals, hash(a.addjvals, hash(a.remivals,
        hash(a.remjvals, hash(:MatrixDifference, h))))))

"""
    modified(a::MatrixDifference)

Access the modified elements.
"""
modified(a::MatrixDifference) = a.modvals

"""
    added(a::MatrixDifference)

Access the tuple containing the elements added per dimension.
"""
added(a::MatrixDifference) = a.addivals, a.addjvals

"""
    added(a::MatrixDifference, dim::Integer)

Access the added elements of dimension `dim`.
"""
function added(a::MatrixDifference, dim::Integer)
    1 <= dim <= 2 || throw(ArgumentError("dimension $dim out of range (1:2)"))
    return added(a)[dim]
end

"""
    removed(a::MatrixDifference)

Access the tuple containing the elements removed per dimension.
"""
removed(a::MatrixDifference) = a.remivals, a.remjvals

"""
    removed(a::MatrixDifference, dim::Integer)

Access the removed elements of dimension `dim`.
"""
function removed(a::MatrixDifference, dim::Integer)
    1 <= dim <= 2 || throw(ArgumentError("dimension $dim out of range (1:2)"))
    return removed(a)[dim]
end
