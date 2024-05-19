# AVL Tree
Self-balancing binary search tree
Named after Adelson-Velsky and Landis
Similar to red-black trees
Perform fixes after insert and delete
Height balanced
Guarantess specific time complexities for operations
O(log n) - search , insert and delete

Height = number of nodes on the longest path from the root to a leaf
For any node, the height of its two subtrees differs by at most one
Balance factor = height of the left subtree - height of right subtree
This means that valid values for balance factor are -1, 0, 1
Empty tree = height 0
Leaf = heigh 1


## Examples

### AVL Tree

![avl tree example](avl_tree.png)

### NOT AVL Tree
Balance factor is 2

![not avl tree example](NOT_avl_tree.png)
