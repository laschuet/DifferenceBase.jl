# Custom pretty-printing

function Base.show(io::IO, ::MIME"text/plain", a::Union{VectorDifference,MatrixDifference})
    println(io, nameof(typeof(a)), " with indices:")
    print(io, " modified: ", a.modinds, "\n added: ", a.addinds, "\n removed: ", a.reminds)
    println(io, "\nand values:")
    println(io, " common: ", a.modvals)
    println(io, " added: ", a.addvals)
    print(io, " removed: ", a.remvals)
end

function Base.show(io::IO, ::MIME"text/plain", a::Union{DictDifference,NamedTupleDifference})
    println(io, nameof(typeof(a)), " with values:")
    println(io, " modified: ", a.modvals)
    println(io, " added: ", a.addvals)
    print(io, " removed: ", a.remvals)
end

function Base.show(io::IO, ::MIME"text/plain", a::SetDifference)
    println(io, nameof(typeof(a)), " with values:")
    println(io, " added: ", a.addvals)
    print(io, " removed: ", a.remvals)
end
