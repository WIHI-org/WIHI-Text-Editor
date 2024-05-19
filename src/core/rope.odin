package core

/*
  Summary: 
  Big-O Performance (Average)
  Access (index) -> O(log n)
  Search -> O(n)
  Insert -> O(log n)
  Delete -> O(log n)
  Append -> O(log n)
  Prepend -> O(log n)
  Concatenate -> O(log n)
  Substring -> O(log n + m)

  Rules:
  Balancing required to maintan log-n perf
  Branches contain full weight of left subtree and left children must not be null
  Leaves contains string slice

                            13
                          /    \
                         /      \
                        /        \
                       5          4
                      / \        / \
                     /   \      /   \
                  Ropes   3   Easy  Peasy
                         / \
                        /   \
                      Are   _NOT_



    TODO:
    Implement AVL tree first
     -> Mutable Keys (cursor weights) is not a good place to start
    Use Paper, draw the trees stp by step , at least 3 levels deep  
    Printing helper:
      print_in_order :: proc(node: ^Node, prefix: string = "")
        Prefix:: [WEIGHT](LEFT_CHILD, RIGHT_CHILD)
        Example:: [13]([5](Ropes, [3](Are, _NOT_)), [4](Easy, Peasy))

    Recursive Asserts for Tree Correctness:
      assert_node_parentage :: proc(node: ^Node, parent: ^Node)
        node.parent == parent
      assert_node_weights :: proc(node: ^Node)
        node.weight == get_weight(node.left)
  */

Rope :: struct {
  head: ^Node
}

Node :: struct {
  parent: ^Node,
  kind:   union {
    Leaf,
    Branch
  }
}

Leaf :: string

Branch :: struct {
  weight: int,
  left:   ^Node,
  right:  ^Node, 
}