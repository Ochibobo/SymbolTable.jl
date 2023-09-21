module BTreeModule
include("../Backend.jl")
import .Backend: STBackend, put!, get, delete!, delete_max!, delete_min!, contains,
                is_empty, size, keys, min, max, floor, ceil, rank, select

## Implementation of a BTree Data Structure

"""
    const M = Ref(4)

The `number of entries` in a `node`. This value can be altered to a value that you find convenient.
"""
const M = Ref(4)


"""
    mutable struct NodeEntry{K, V}
        key::Union{Nothing, K}
        value::Union{Nothing, V}
        next::Union{Nothing, NodeEntry{K, V}}

        ## Used to create a node
        function NodeEntry{K, V}(key::K, value::V) where  {K, V}
            new{K, V}(key, value, nothing)
        end

        ## Used to create an internal node
        function NodeEntry{K, V}(key::K, next::NodeEntry{K, V}) where {K, V}
            new{K, V}(key, nothing, next)
        end
    end

Structure defining an entry in a `Node`

`next` - used for internal nodes
`value` - used for external (leaf) nodes
"""
mutable struct NodeEntry{K, V}
    key::Union{Nothing, K}
    value::Union{Nothing, V}
    next::Union{Nothing, NodeEntry{K, V}}

    ## Used to create a node
    function NodeEntry{K, V}(key::K, value::V) where  {K, V}
        new{K, V}(key, value, nothing)
    end

    ## Used to create an internal node
    function NodeEntry{K, V}(key::K, next::NodeEntry{K, V}) where {K, V}
        new{K, V}(key, nothing, next)
    end
end


"""
    mutable struct Node
        size::Int  ## Number of children
        children::Vector{NodeEntry}

        function Node()
            children = Vector{NodeEntry}(undef, M)

            new(0, children)
        end
    end

`Node` belonging to the BTree
"""
mutable struct Node
    size::Int  ## Number of children
    children::Vector{NodeEntry}

    function Node()
        children = Vector{NodeEntry}(undef, M)

        new(0, children)
    end
end


"""
    mutable struct BTree{K, V} <: STBackend{K, V}
        height::Int
        root::Node

        function BTree{K, V}()
            new{K, V}(0, Node())
        end
    end

The actual `BTree` implementation
"""
mutable struct BTree{K, V} <: STBackend{K, V}
    height::Int
    root::Node

    function BTree{K, V}()
        new{K, V}(0, Node())
    end
end


"""
    put!(tree::BTree{K, V}, key::K, value::V) where {K, V}

`put!` function to add a key-value pair to the `BTree`
"""
function put!(tree::BTree{K, V}, key::K, value::V) where {K, V}
    
end


"""
Helper function for `put!`
"""
function put!(root::Node, key::K, value::V) where {K, V}
    
end


end