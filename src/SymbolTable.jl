module SymbolTable

include("Backend.jl")
import .Backend: STBackend, put!, get, delete!, delete_max!, delete_min!, contains,
                is_empty, size, keys, min, max, floor, ceil, rank, select

export put!, get, delete!, delete_max!, delete_min!, contains,
        is_empty, size, keys, min, max, floor, ceil, rank, select, ST

# include("BinarySearchTree/BinarySearchTree.jl")
# using .BinarySearchTree
# export BinarySearchTree

include("RedBlackTree/RedBlackTree.jl")
using .RedBlackTree
export RedBlackTree


"""
    mutable struct ST{K, V}
        backend::Union{Nothing, STBackend{K, V}}
        ## Constructor to set the backend
        function ST{K,V}(backend::STBackend{K, V}) where {K, V}
            new(backend)
        end
    
        ## Constructor without a set backend
        function ST()
            ST{Any, Any}(nothing)
        end
    end

The SymbolTable object
"""
mutable struct ST{K, V}
    backend::Union{Nothing, STBackend{K, V}}
    ## Constructor to set the backend
    function ST{K,V}(backend::STBackend{K, V}) where {K, V}
        new{K, V}(backend)
    end
end


"""
    backend(symbol_table::Union{Nothing, ST{K, V}}) where {K, V}

Expose the backend structure of the SymbolTable
"""
backend(symbol_table::Union{Nothing, ST{K, V}}) where {K, V} = symbol_table.backend


"""
    set_backend!(symbol_table::ST{K, V}, backend::STBackend{K, V})::Nothing where {K, V}

Function used to set the `SymbolTable`'s backend
"""
function set_backend!(symbol_table::ST{K, V}, backend::STBackend{K, V})::Nothing where {K, V}
    symbol_table.backend = backend

    return nothing
end


"""
    put!(st::ST{K, V}, key::K, value::V) where {K, V}

Put a key-value to the symbol table
"""
function put!(st::ST{K, V}, key::K, value::V) where {K, V}
    put!(backend(st), key, value)
end


"""
    get(st::ST{K, V}, key::K)::V where {K, V}

Get a key's value from the SymbolTable
"""
function get(st::ST{K, V}, key::K)::V where {K, V}
    return get(backend(st), key)
end


"""
    delete!(st::ST{K, V}, key::K) where {K, V}

Delete a key from the SymbolTable
"""
function delete!(st::ST{K, V}, key::K) where {K, V}
    delete!(backend(st), key)
end


"""
    contains(st::ST{K, V}, key::K)::Bool

Check if the SymbolTable contains the specified key
"""
function contains(st::ST{K, V}, key::K)::Bool where {K, V}
    return contains(backend(st), key)
end


"""
    is_empty(st::ST{K, V})::Int64

Check if the SymbolTable is empty
"""
function is_empty(st::ST{K, V})::Int64 where {K, V}
    return is_empty(backend(st))
end


"""
    size(st::ST{K, V})::Int64 where {K, V}

Get the size of the SymbolTable
"""
function size(st::ST{K, V})::Int64 where {K, V}
    return size(backend(st))
end


"""
    size(st::ST{K, V}, key₁::K, key₂::K)::Int64 where {K, V}

Get the size of the SymbolTable keys in a specified range
"""
function size(st::ST{K, V}, key₁::K, key₂::K)::Int64 where {K, V}
    return size(backend(st), key₁, key₂)
end


"""
    keys(st::ST{K, V})::Vector{K} where {K, V}

Get all keys present in the symbol table
Keys are returned in a sorted order
"""
function keys(st::ST{K, V})::Vector{K} where {K, V}
    return keys(backend(st))
end


"""
    keys(st::ST{K, V}, key₁::K, key₂::K)::Vector{K} where {K, V}

Get a range of keys between 2 specified key values (exclusive)
Keys are returned in a sorted order
"""
function keys(st::ST{K, V}, key₁::K, key₂::K)::Vector{K} where {K, V}
    return keys(backend(st), key₁, key₂)
end


"""
    min(st::ST{K, V})::K where {K, V}

Get the minimum(smallest) key from the symbol table
"""
function min(st::ST{K, V})::K where {K, V}
    return min(backend(st))
end


"""
    max(st::ST{K, V})::K where {K, V}

Get the maximum(largest) key from the symbol table
"""
function max(st::ST{K, V})::K where {K, V}
    return max(backend(st))
end


"""
    floor(st::ST{K, V}, key::K)::K where {K, V}

Get the floor value of a particular key
The key needs not be in the SymbolTable, the floor value can still, however, be retrieved, if present.
"""
function floor(st::ST{K, V}, key::K)::K where {K, V}
    return floor(backend(st), key)
end


"""
    ceil(st::ST{K, V}, key::K)::K where {K, V}

Get the ceil value of a particular key
The key needs not be in the SymbolTable, the ceil value can still, however, be retrieved, if present.
"""
function ceil(st::ST{K, V}, key::K)::K where {K, V}
    return ceil(backend(st), key)
end


"""
    rank(st::ST{K, V}, key::K)::Int64 where {K, V}

Get the rank of the passed key
"""
function rank(st::ST{K, V}, key::K)::Int64 where {K, V}
    return rank(backend(st), key)
end

"""
    select(st::ST{K, V}, key::K)::K where {K, V}

Select the rank of the passed key
"""
function select(st::ST{K, V}, n::Int64)::K where {K, V}
    return select(backend(st), n)
end


"""
    delete_min!(st::ST{K, V}) where {K, V}

Delete the minimum value from the SymbolTable
"""
function delete_min!(st::ST{K, V}) where {K, V}
    delete_min!(backend(st))
end


"""
    delete_max!(st::ST{K, V}) where {K, V}

Delete the maximum value from the SymbolTable
"""
function delete_max!(st::ST{K, V}) where {K, V}
    delete_max!(backend(st))
end


## Testing the interface
# symbol_table = ST{String, Int64}(BST{String, Int64}())

end
