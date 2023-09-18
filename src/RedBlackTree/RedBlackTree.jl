## The Red-Black Tree backend
module RedBlackTree
## The BackendInterface the tree will implement
# include("../Backend.jl")
import ..Backend: STBackend, put!, get, delete!, delete_max!, delete_min!, contains,
                 is_empty, size, keys, min, max, floor, ceil, rank, select

export put!, get, RBNode, RBTree, getNode

"""
`RED` color of the link to a node
"""
const RED = true

"""
`BLACK` color of the link to a node
"""
const BLACK = false


"""
    mutable struct RBNode{K, V}
        key::K
        value::V
        color::Bool
        left::RBNode{K, V}
        right::RBNode{K, V}
        N::Int64

        ## Default constructor
        RBNode(key::K, value::V) = new(key, value, nothing, nothing, 0)
    end

`RedBlackTree Node`
Red links glue nodes with a 3-node. They are internal to 3-nodes. Black links glue nodes with a 2-node and a 3-node.
"""
mutable struct RBNode{K, V}
    key::K
    value::V
    color::Bool ## Color of parent link
    left::Union{Nothing, RBNode{K, V}}
    right::Union{Nothing, RBNode{K, V}}
    N::Int64

    ## Default constructor - everytime we add a node we create a RED link to it's parent
    RBNode{K, V}(key::K, value::V) where {K, V} = new{K, V}(key, value, RED, nothing, nothing, 0)
end


"""
    mutable struct RBTree{K, V} <: STBackend{K, V}
        root::RBNode{K, V}
    end

`RedBlackTree` object - a `left leaning red-black BST`
We use internal left-leaning links as glue for 3 nodes. The larger of the 2 nodes in the 3 nodes will always be the root of a little BST of size 2.
The left link that links the larger key to the smaller one will be colored red to distinguish them from other links in the binary tree so that we can 
tell when we are inserting things which nodes belong to 3 nodes and which ones don't
"""
mutable struct RBTree{K, V} <: STBackend{K, V}
    root::Union{Nothing, RBNode{K, V}}

    RBTree{K, V}() where {K, V} = new{K, V}(nothing)
end


"""
    put!(tree::RBTree{K, V}, key::K, value::V) where {K, V}

`put!` function to add a key, value pair to the `RBTree{K, V}`
"""
function put!(tree::RBTree{K, V}, key::K, value::V)::RBNode{K, V} where {K, V}
    tree.root = put!(tree.root, key, value)

    return tree.root
end


"""
    put!(root::Union{Nothing, RBNode{K, V}}, key::K, value::V)::RBNode{K, V} where {K, V}

`put!` helper function
"""
function put!(root::Union{Nothing, RBNode{K, V}}, key::K, value::V)::RBNode{K, V} where {K, V}
    if isnothing(root) return RBNode{K, V}(key, value) end
    
    if key < root.key root.left = put!(root.left, key, value) end
    if key > root.key root.right = put!(root.right, key, value) end
    ## Update the value if the key matches an existing key
    if key == root.key root.value = value end

    ## Rotate if necessary
    ## Rotate left of the right link is red and the left isn't - lean left
    if (is_red(root.right) && !is_red(root.left)) root = rotate_left!(root) end
    ## For consecutive reds, meaning we have a 4 node - balance 4-node
    if (!isnothing(root.left) && is_red(root.left) && is_red(root.left.left)) root = rotate_right!(root) end
    ## Flip colors if both children are red - split 4 node
    if(is_red(root.left) && is_red(root.right)) root = flip_color(root) end

    return root
end


"""
    rotate_left!(node::RBNode{K, V})::RBNode{K, V} where {K, V}

`rotate_left!` function used to rotate a node to the left. Takes a right-leaning red-link and reorient it to the left.
"""
function rotate_left!(node::RBNode{K, V})::RBNode{K, V} where {K, V}
    ## Get node x that is the right node with a red link
    x = node.right
    ## Make the top node point to the left node of x
    node.right = x.left
    ## Make x's left pointer be node
    x.left = node
    ## Update x's color
    x.color = node.color
    ## Update the node's color to red
    node.color = RED
    ## Return x
    return x
end


"""
    rotate_right!(node::RBNode{K, V})::RBNode{K, V} where {K, V}

`rotate_right!` function used to rotate a node to the right
"""
function rotate_right!(node::RBNode{K, V})::RBNode{K, V} where {K, V}
    ## Get node x that is the left node
    x = node.left
    ## Make node's left point to x's right
    node.left = x.right
    ## Make x's right the node
    x.right = node
    ## Make x's color be the node's color
    x.color = node.color
    ## Make the node's color black
    node.color = RED
    ## Return x

    return x
end


"""
    flip_color!(node::RBNode{K, V})::RBNode{K, V} where {K, V}

`flip_color!` function used to flip the link color from :red to :black. Recolor to split a (temporary) 4-node in a 2-3 Tree.
"""
function flip_color(node::RBNode{K, V})::RBNode{K, V} where {K, V}
    ## Mark the current node's color as RED - pass the center node to the root
    node.color = RED
    ## Mark it's left and right children as black - splitting the 4 node.
    node.left.color = BLACK
    node.right.color = BLACK

    return node
end


"""
    is_red(node::RBNode)::Bool

`is_red` function to check if the link of the current node is red
"""
function is_red(node::Union{RBNode, Nothing})::Bool
    isnothing(node) && return false

    return node.color == RED
end


"""
    get(tree::RBTree{K, V}, key::K)::V where {K, V}

`get` function to return the value based on the passed key
"""
function get(tree::RBTree{K, V}, key::K)::Union{Nothing, V} where {K, V}
    node = get(tree.root, key)
    return node.value
end


"""
    get(root::Union{RBNode{K, V}, Nothing}, key::K)::Union{V, Nothing} where {K, V}

`get` helper function
"""
function get(root::Union{RBNode{K, V}, Nothing}, key::K)::Union{RBNode{K, V}, Nothing} where {K, V}
    if isnothing(root) return nothing end

    if key < root.key return get(root.left, key) end
    if key > root.key return get(root.right, key) end
    if key == root.key return root end

    return nothing
end

"""
    getNode(root::Union{RBNode{K, V}, Nothing}, key::K)::Union{V, Nothing} where {K, V}
"""
function  getNode(tree::RBTree{K, V}, key::K)::Union{RBNode{K, V}, Nothing} where {K, V}
    return get(tree.root, key)    
end

end