"""
    MatrixDifference{Tm<:AbstracArray,Ta<:AbstractArray,Tr<:AbstractArray}

Matrix difference.
"""
struct MatrixDifference{Tm<:AbstractArray,Ta<:AbstractArray,Tr<:AbstractArray}
    modvals::Tm
    addvals::Ta
    remvals::Tr
end

# Matrix difference equality operator
==(a::MatrixDifference, b::MatrixDifference) =
    (a.modvals == b.modvals && a.addvals == b.addvals && a.remvals == b.remvals)

# Matrix difference hash code
hash(a::MatrixDifference, h::UInt) =
    hash(a.modvals, hash(a.addvals, hash(a.remvals,
        hash(:MatrixDifference, h))))

"""
    modified(a::MatrixDifference)

Access the modified elements.
"""
modified(a::MatrixDifference) = a.modvals

"""
    added(a::MatrixDifference)

Access the added elements.
"""
added(a::MatrixDifference) = a.addvals

"""
    removed(a::MatrixDifference)

Access the removed elements.
"""
removed(a::MatrixDifference) = a.remvals
