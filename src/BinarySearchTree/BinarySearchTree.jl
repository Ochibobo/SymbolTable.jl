"""
BinarySearchTree backend to the symbol table
"""
module BinarySearchTree
# -------------------------------------------------------------------------------------------------------------------------------------------
# include("../Backend.jl")
import ..Backend: STBackend, put!, get, delete!, delete_max!, delete_min!, contains,
                  is_empty, size, keys, min, max, floor, ceil, rank, select

## Export only tree-based functions
export put!, get, contains, size, is_empty, keys, min, max,
       delete_min!, delete_max!, rank, select, floor, ceil,
       delete!, BST, BSTNode

"""
    mutable struct BSTNode{K, V}
        key::K
        value::V
        left::Union{Nothing, BSTNode{K, V}}
        right::Union{Nothing, BSTNode{K, V}}
        N::Int64

        ## Constructor to create a root object
        BSTNode{K,V}(key::K, value::V) where {K, V} = new{K, V}(key, value, nothing, nothing, 0)
    end

`BinarySearchTree Node`
"""
mutable struct BSTNode{K, V}
    key::K
    value::V
    left::Union{Nothing, BSTNode{K, V}}
    right::Union{Nothing, BSTNode{K, V}}
    N::Int64

    ## Constructor to create a root object
    BSTNode{K,V}(key::K, value::V) where {K, V} = new{K, V}(key, value, nothing, nothing, 0)
end

"""
    mutable struct BST{K, V} <: STBackend{K, V}
        root::Union{Nothing, BSTNode{K, V}}

        BST{K, V}() where {K, V} = new{K, V}(nothing)
    end

`BinarySearchTree` object
"""
mutable struct BST{K, V} <: STBackend{K, V}
    root::Union{Nothing, BSTNode{K, V}}

    BST{K, V}() where {K, V} = new{K, V}(nothing)
end


"""
    put!(tree::BST{K, V}, key::K, value::V) where {K, V}

`put!` function to add a key, value pair to the `BST{K, V}`
"""
function put!(tree::BST{K, V}, key::K, value::V) where {K, V}
    if isnothing(tree) return error("tree cannot be of type Nothing") end
    tree.root = put!(tree.root, key, value) 
end


"""
    put!(root::Union{Nothing, BSTNode{K, V}}, key::K, value::V)::BSTNode{K,V} where {K, V}

`put!` helper function
"""
function put!(root::Union{Nothing, BSTNode{K, V}}, key::K, value::V)::BSTNode{K,V} where {K, V}
    if isnothing(root) return BSTNode{K,V}(key, value) end
    ## Build left subtree if the current key is lesser than the current node's key
    if key < root.key
        root.left = put!(root.left, key, value)
    ## Build right subtree if the current key is greater than the current node's key
    elseif key > root.key
        root.right = put!(root.right, key, value)
    else
        root.value = value
    end

    ## Update the size of the root node
    root.N = size(root.left) + size(root.right) + 1
    return root
end


"""
    get(tree::BST{K, V}, key::K) where {K, V} 

Get a key's value from the tree
"""
get(tree::BST{K, V}, key::K) where {K, V} = get(tree.root, key)


"""
    get(root::Union{Nothing, BSTNode{K, V}}, key::K)::V where {K, V}

Get helper function
"""
function get(root::Union{Nothing, BSTNode{K, V}}, key::K)::Union{Nothing,V} where {K, V}
    ## If the root is Nothing, return nothing
    if isnothing(root) return nothing end
    ## Search the left subtree if the key is smaller than the current node's value
    if key < root.key return get(root.left, key) end
    ## Search the right subtree if the key is larger then the current node's value
    if key > root.key return get(root.right, key) end
    ## Return the value otherwise
    return root.value
end


"""
    contains(tree::BST{K, V}, key::K) where {K, V}

Check if the BinarySearchTree contains the `key`
"""
contains(tree::BST{K, V}, key::K) where {K, V} = contains(tree.root, key)


"""
    contains(root::Union{Nothing, BSTNode{K, V}}, key::K)::Bool where {K, V}

Helper function to traverse nodes
"""
function contains(root::Union{Nothing, BSTNode{K, V}}, key::K)::Bool where {K, V}
    ## False if the root is nothing
    if isnothing(root) return false end
    
    if key < root.key return contains(root.left, key) end
    if key > root.key return contains(root.right, key) end
    return true
end


"""
    size(tree::BST)

Get the tree size
"""
size(tree::BST) = size(tree.root)


"""
    size(node::Union{Nothing, BSTNode{K, V}})::Integer where {K, V}

Get the size of the BSTNode
"""
function size(node::Union{Nothing, BSTNode{K, V}})::Integer where {K, V}
    if isnothing(node) return 0 end
    return node.N
end


"""
    is_empty(tree::BST)

Check if the tree is empty
"""
is_empty(tree::BST) = is_empty(tree.root)


"""
    is_empty(root::Union{Nothing, BSTNode{K, V}}) where {K, V}

Check if the BST is empty
"""
function is_empty(root::Union{Nothing, BSTNode{K, V}}) where {K, V}
    return isnothing(root)
end


"""
    keys(tree::BST{K, V})::Vector{K} where {K, V}

Ordered list of keys present in the tree
"""
function keys(tree::BST{K, V})::Vector{K} where {K, V} 
    return keys(tree.root)
end


"""
    keys(root::Union{Nothing, BSTNode{K, V}})::Vector{K} where {K, V}

Get the ordered list of keys 
"""
function keys(root::Union{Nothing, BSTNode{K, V}})::Vector{K} where {K, V}
    if isnothing(root) return [] end
    _keys::Vector{K} = []
    keys(root, min(root), max(root), _keys)
    return _keys
end


"""
    keys(root::Union{Nothing, BSTNode{K, V}}, low::K, high::K)::Vector{K} where {K, V}

Get the set of keys between the specified high & low values
"""
function keys(root::Union{Nothing, BSTNode{K, V}}, low::K, high::K)::Vector{K} where {K, V}
    _keys::Vector{K} = []
    keys(root, low, high, _keys)
    return _keys
end


"""
    keys(root::Union{Nothing, BSTNode{K, V}}, low::K, high::K, _keys::Vector{K}) where {K, V}

Helper `keys` function
"""
function keys(root::Union{Nothing, BSTNode{K, V}}, low::K, high::K, _keys::Vector{K}) where {K, V}
    if isnothing(root) return end
    ## If the low range is lesser than the current key, traverse the left subtree
    if low < root.key keys(root.left, low, high, _keys) end
    if root.key >= low  && root.key <= high
        push!(_keys, root.key)
    end
    if high > root.key keys(root.right, low, high, _keys) end
end


"""
    values(tree::BST{K, V})::Vector{V} where {K, V}

Get the set of values
"""
function values(tree::BST{K, V})::Vector{V} where {K, V}
    _values = Vector{V}()
    values(tree.root, min(tree.root), max(tree.root), _values)
    return _values
end


"""
    values(tree::BST{K, V}, low::K, high::K)::Vector{K} where {K, V}

Helper `values` function
"""
function values(tree::BST{K, V}, low::K, high::K)::Vector{K} where {K, V}
    _values = Vector{V}()
    values(tree.root, low, high, values)
    return _values
end


"""
    values(root::Union{Nothing, BSTNode{K, V}}, low::K, high::K, values::Vector{V}) where {K, V}

Helper function to get the set of values
"""
function values(root::Union{Nothing, BSTNode{K, V}}, low::K, high::K, values::Vector{V}) where {K, V}
    if isnothing(root) return end

    ## If low range is lesser than the current key traverse the left subtree
    if low < root.key values(root.left, low, high, values) end
    if high > root.key values(root.right, low, high, values) end
    if root.key >= low && root.key <= high
        push!(values, root.value)
    end
end


"""
    min(tree::BST{K, V})::K where {K, V}

Minimum tree value
"""
function min(tree::BST{K, V})::K where {K, V}
    min(tree.root)
end


"""
    min(root::Union{Nothing, BSTNode{K, V}})::K where {K,V}

Get the minimum key value
"""
function min(root::Union{Nothing, BSTNode{K, V}})::K where {K,V}
    if isnothing(root) return nothing end
    if isnothing(root.left) return root.key end
    return min(root.left).key
end


"""
    max(tree::BST{K, V})::K where {K, V}

Maximum tree value
"""
function max(tree::BST{K, V})::K where {K, V}
    return max(tree.root)
end


"""
    max(root::Union{Nothing, BSTNode{K, V}})::K where {K, V}

Get the maximum key value
"""
function max(root::Union{Nothing, BSTNode{K, V}})::K where {K, V}
    if isnothing(root) return nothing end
    if isnothing(root.right) return root.key end
    return max(root.right)
end


"""
    delete_min!(tree::BST{K, V}) where {K, V}

Delete a tree's minimum value
"""
function delete_min!(tree::BST{K, V}) where {K, V}
    tree.root = delete_min!(tree.root)
end


"""
    delete_min!(root::Union{Nothing, BSTNode{K, V}})::BSTNode{K,V} where {K, V}

Delete the minimum key node
"""
function delete_min!(root::Union{Nothing, BSTNode{K, V}})::BSTNode{K,V} where {K, V}
    if isnothing(root) return nothing end
    if isnothing(root.left) return root.right end
    root.left = delete_min!(root.left)
    root.N = size(root.left) + size(root.right) + 1

    return root
end


"""
    delete_max!(tree::BST{K, V}) where {K, V}

Delete the tree's maximum value
"""
function delete_max!(tree::BST{K, V}) where {K, V}
    tree.root = delete_max!(tree.root)
end


"""
    delete_max!(root::Union{Nothing, BSTNode{K, V}})::BSTNode{K,V} where {K, V}

Delete the maximum key node
"""
function delete_max!(root::Union{Nothing, BSTNode{K, V}})::BSTNode{K,V} where {K, V}
    if isnothing(root) return nothing end
    if isnothing(root.right) return root.left end
    root.right = delete_max!(root.right)
    root.N = size(root.right) + size(root.left) + 1

    return root
end


"""
    rank(tree::BST{K,V}, key::K)::Int64 where {K, V}

Get the rank of a key in the tree
"""
function rank(tree::BST{K,V}, key::K)::Int64 where {K, V} 
    return rank(tree.root, key)
end


"""
    rank(root::Union{Nothing, BSTNode{K, V}}, key::K)::Int64 where {K, V}

Helper function to get the rank of a key
"""
function rank(root::Union{Nothing, BSTNode{K, V}}, key::K)::Int64 where {K, V}
    if isnothing(root) return -1 end
    if key < root.key return rank(root.left, key) end
    if key > root.key return 1 + size(root.left) + rank(root.right, key) end
    return size(root.left)
end


"""
    select(tree::BST{K, V}, k::Int64)::K where {K, V}

Select the key with the passed rank
"""
function select(tree::BST{K, V}, k::Int64)::K where {K, V}
    return select(tree.root, k)
end


"""
    select(root::Union{Nothing, BSTNode{K, V}}, k::Int64)::BSTNode{K, V} where {K, V}

Helper function to get a key
"""
function select(root::Union{Nothing, BSTNode{K, V}}, k::Int64)::BSTNode{K, V} where {K, V}
    if isnothing(root) return nothing end
    t = size(root.left)
end


"""
    floor(tree::BST{K, V}, key::K)::K where {K, V}

Get the floor value of a particular key
"""
function floor(tree::BST{K, V}, key::K)::K where {K, V}
    node = floor(tree.root, key)
    if isnothing(key) return nothing end
    return node.key
end


"""
    floor(root::Union{Nothing, BSTNode{K, V}}, key::K)::BSTNode{K, V} where {K, V}

Helper function to get the floor value
"""
function floor(root::Union{Nothing, BSTNode{K, V}}, key::K)::BSTNode{K, V} where {K, V}
    ## If the root is empty, return nothing
    if isnothing(root) return nothing end

    ## If the current node's key match is successful, return it
    if root.key == key return root end
    
    ## Search for the floor in the left subtree if the key is lesser than the current node
    if key < root.key
        return floor(root.left, key)
    end

    ## Else traverse the right tree for the floor value
    t = floor(root.right, key)
    if !isnothing(t) return t end
    return root
end


"""
    ceil(tree::BST{K, V}, key::K)::K where {K, V}

Get the ceiling value of a particular key
"""
function ceil(tree::BST{K, V}, key::K)::K where {K, V}
    node = ceil(tree.root, key)
    if isnothing(node) return nothing end
    return node.key
end


"""
    ceil(root::Union{Nothing, BSTNode{K, V}}, key::K)::BSTNode{K, V} where {K, V}

Helper `ceil` function
"""
function ceil(root::Union{Nothing, BSTNode{K, V}}, key::K)::BSTNode{K, V} where {K, V}
    if isnothing(root) return nothing end 

    ## If the current node's key match is successful, return it
    if root.key == key return root end

    ## If the key > root.key, traverse the right subtree
    if key > root.key return ceil(root.right, key) end

    t = ceil(root.left, key)
    if !isnothing(t) return t end
    return root
end


"""
    delete!(tree::BST{K, V}, key::K) where {K, V}

Delete a key from the tree (Hibbard Deletion)
"""
function delete!(tree::BST{K, V}, key::K) where {K, V}
    tree.root = delete!(tree.root, key)
end


"""
    delete!(root::Union{Nothing, BSTNode{K, V}}, key::K)::BSTNode{K, V} where {K, V}

Helper function to delete a key from the tree
Cases:
    Deleted Node has no children
    Deleted Node has 1 child
    Deleted Node has 2 children
"""
function delete!(root::Union{Nothing, BSTNode{K, V}}, key::K)::BSTNode{K, V} where {K, V}
    if isnothing(root) return nothing end

    if key < root.key 
        root.left = delete!(root.left, key) 
    elseif key > root.key 
        root.right = delete!(root.right, key) 
    else
        ## This means the node to be deleted has been identified
        ## Return the left node if the right node is empty
        if isnothing(root.right) return root.left end
        ## Return the right node if the left node is empty
        if isnothing(root.left) return root.right end

        ## Swap the node to be deleted with the minimum node in its right subtree
        t = root
        root = min(t.right)
        root.right = delete_min!(t.right)
        root.left = t.left
    end

    root.N = size(root.left) + sixe(root.right) + 1
    return root
end

# ---------------------------------------------------------------------------------------------------------------------
end