package core

init :: proc() {

}



/*
insert_text :: proc(rope: ^Rope, cursor: int, text: string) {
  right_tree := split(rope, cursor)
  append_node(rope, make_leaf(text))
  rope.head = concat(rope.head, right_tree.head)
  rebalance(&rope.head)  
}

delete_text :: proc(rope: ^Rope, cursor: int, count: int) {
  middle_tree := split(rope, cursor)
  right_tree := split(middle_tree, count)
  rope.head = concat(rope.head, right_tree.head)
  delete_rope(middle_tree)
  rebalance(&rope.head)
}

concat :: proc(left: ^Node, right: ^Node) -> ^Node {
  node := new(Node)
  node^.kind = Branch {weight = get_weight(left)}
  set_left_child(node, left)
  set_right_child(node, rright)
  return node
}

split :: proc(rope: ^Rope, cursor: int) -> (right_tree: Rope) {
  node := rope.head

  current := cursor
  for {
    if current == 0 { // move entire subtree
      append_node(right_tree, node)
      break
    }
    switch n in node.kind {
      case (Branch):
        if current >= n.weight && n.right != nil {
          next = n.right
          current -= n.weight
        } else if n.left != nil {
          next = n.left
          prepend_node(right_tree, n.right)
          set_left_child(node.parent, n.left)
          update_weight(node.parent)
        }
      case (Leaf):
        parent := node.parent
        if current < len(n) {
          left, right := split_leaf(node, current)
          prepend_node(right_tree, right)
          as_branch(parent).right = nil
          set_left_child(parent, left)
          update_weight(parent)
          break
        }
    }

    node = next
  }

  return right_tree
}

rebalance :: proc(node: ^^Node) {
  if np, ok := &node^.kind.(Branch); ok {
    balance := get_height(np.left) - get_height(np.right)

    if balance > 1 {
      np_left := &np.left.kind.(Branch)
      if get_height(np_left.left) < get_height(np_left.right) {
        np.left = rotate_left(np.left)
      }
      node^ = rotate_right(node^)
    } else if balance < -1 {
      // inverse rorate
    } else {
      update_weight(node^)
    }
  }
}


*/