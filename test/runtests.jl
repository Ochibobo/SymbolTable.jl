using SymbolTable
using Test

@testset "SymbolTable.jl" begin
    ## Binary Search Tree Test
    # bst = SymbolTable.BST{Char, Int64}()
    # st = ST{Char, Int64}(bst)

    @testset "BinarySearchTree Test" begin
        # SymbolTable.put!(bst, 'S', 1)
    end

    # Example SymbolTable
    rbTree = SymbolTable.RBTree{Char, Int64}()
    st = ST{Char, Int64}(rbTree)

    ## RedBlackTree Test
    @testset "RedBlackTree Test" begin
        ## Insert S
        SymbolTable.put!(st, 'S', 1)
        @test SymbolTable.get(st, 'S') == 1
        ## Insert E
        SymbolTable.put!(st, 'E', 2)
        @test SymbolTable.get(st, 'E') == 2

        node = SymbolTable.getNode(rbTree, 'S')

        @test node.key == 'S'
        @test node.value == 1

        @test node.left.key == 'E'
        @test node.left.value == 2
        @test node.left.color == true

        @test isnothing(node.right)

        ## Insert A
        SymbolTable.put!(st, 'A', 3)

        @test rbTree.root.key == 'E'

        node = SymbolTable.getNode(rbTree, 'E')

        @test node.value == 2
        @test node.color == true

        @test node.left.key == 'A'
        @test node.left.value == 3
        @test node.left.color == false
        
        @test node.right.key == 'S'
        @test node.right.value == 1
        @test node.right.color == false

        ## Insert R
        SymbolTable.put!(st, 'R', 4)

        node = SymbolTable.getNode(rbTree, 'S')

        @test node.left.key == 'R'
        @test node.left.value == 4
        @test node.left.color == true

        ## Insert C
        SymbolTable.put!(st, 'C', 5)
        
        @test rbTree.root.left.key == 'C'
        @test rbTree.root.left.value == 5
        @test rbTree.root.left.color == false

        ## Insert H
        SymbolTable.put!(st, 'H', 6)

        @test rbTree.root.key == 'R'
        @test rbTree.root.left.key == 'E'

        node = SymbolTable.getNode(rbTree, 'E')
        @test node.right.key == 'H'
        @test node.right.value == 6
        @test node.right.color == false

        ## Insert X
        SymbolTable.put!(st, 'X', 7)

        @test rbTree.root.right.key == 'X'
        @test rbTree.root.right.value == 7
        @test rbTree.root.right.color == false

        ## Insert M
        SymbolTable.put!(st, 'M', 8)

        node = SymbolTable.getNode(rbTree, 'E')
        @test node.right.key == 'M'
        @test node.right.value == 8
        @test node.right.color == false

        ## Insert P
        SymbolTable.put!(st, 'P', 9)

        @test rbTree.root.key == 'M'
        node = SymbolTable.getNode(rbTree, 'R')
        @test node.left.key == 'P'
        @test node.left.value == 9
        @test node.left.color == false

        ## Insert L
        SymbolTable.put!(st, 'L', 10)
        
        node = SymbolTable.getNode(rbTree, 'E')
        @test node.right.key == 'L'
        @test node.right.value == 10
        @test node.right.color == false
        @test node.right.left.key == 'H'
    end
end
