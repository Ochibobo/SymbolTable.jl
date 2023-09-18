"""
SymbolTable backend interface for every element that interacts with the SymbolTable to implement
"""
module Backend
# ---------------------------------------------------------------------------------------------------------------------------------------------------------

export STBackend, put!, get, delete!, delete_max!, delete_min!, contains,
       is_empty, size, keys, min, max, floor, ceil, rank, select

"""
Backend Structure any DataStructure that will serve as the backend of the symbol table should implement
"""
abstract type STBackend{K, V} end


"""
Backend Structrure any tree node should implement
"""
abstract type STNode{K, V} end


put!(b::STBackend{K, V}, key::K, value::V) where {K, V} = error("missing 'put' implentation")

function get(b::STBackend{K, V}, key::K)::V where {K, V} 
    error("missing 'get' implementation")
end

function delete!(b::STBackend{K, V}, key::K)::Any where {K, V}
    error("missing 'delete!' implementation")
end

function contains(b::STBackend{K, V}, key::K)::Bool where {K, V}
    error("missing 'contains' implemention")
end

function is_empty(b::STBackend{K, V})::Bool where {K, V}
    error("missing 'is_empty' implementation")
end

function size(b::STBackend{K, V})::Int64 where{K, V} 
    error("missing 'size' implementation")
end

function size(b::STBackend{K, V}, key₁::K, key₂::K)::Int64 where {K, V}
    error("missing 'size' with key range implemetation")
end

function keys(b::STBackend{K, V})::Vector{K} where {K, V}
    error("missing 'keys' implementation")
end

function keys(b::STBackend{K, V}, key₁::K, key₂::K)::Vector{K} where {K, V} 
    error("missing 'keys' with key range implementation")
end

function min(b::STBackend{K, V})::K where {K, V} 
    error("missing 'min' implementation")
end

function max(b::STBackend{K, V})::K where {K, V}
    error("missing 'max' implementation")
end

function floor(b::STBackend{K, V}, key::K)::K where {K, V}
    error("missing 'floor' implementation")
end

function ceil(b::STBackend{K, V}, key::K)::K where {K, V}
    error("missing 'ceil' implementation")
end

function rank(b::STBackend{K, V}, key::K)::Int64 where {K, V}
    error("missing 'rank' implementation")
end

function select(b::STBackend{K, V}, n::Int64)::K where {K, V}
    error("missing 'select' implementation")
end

function delete_min!(b::STBackend{K, V})::Any where{K, V}
    error("missing 'delete_min! implementation")
end

function delete_max!(b::STBackend{K, V})::Any where {K,V}
    error("missing 'delete_max!' implementation")
end
"""
Supported API operations
- put(key::Key, value::Value)::Bool
- get(key::Key)::Value
- delete(key::Key)::Bool
- contains(key::Key)::Bool
- isEmpty()::Bool
- size()::Int64
- keys()::Vector{Key}
- min()::Key
- max()::Key
- floor(key::Key)::Key
- ceil(key::Key)::Key
- rank(key:Key)::Int64
- select(k::int)::Key - key of rank k
- deleteMin()::Bool
- deleteMax()::Bool
- size(low::Key, high::Key) - number of keys in [low..high]
- keys(low::Key, high::Key) - keys in [low..high] in sorted order
- values(low::Key, high::Key) - a collection of the values
"""
# ---------------------------------------------------------------------------------------------------------------------------------------------------------
end