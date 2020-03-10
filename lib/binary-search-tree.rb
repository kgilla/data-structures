class Tree 
  attr_accessor :root

  def initialize (array)
    @root = build_tree(array)
  end 

  def build_tree (array)
    return nil unless array[0]
    array.sort!.uniq!
    middle = array.length / 2
    mid_plus = middle + 1
    root = Node.new(array[middle])
    root.left = build_tree(array[0...middle])
    root.right = build_tree(array[mid_plus..-1])
    return root
  end

  def insert (value, node = @root)
    if node.value == value
      puts "Value already exists"
    elsif value < node.value
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    elsif value > node.value
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end 
  end

  def delete (value, node = @root)
    temp = find(value); parent = nil
    level_order { |a| parent = a if (a.left == temp || a.right == temp)}
    if temp.left.nil? && temp.right.nil?
      parent.left == temp ? parent.left = nil : parent.right = nil
    elsif temp.left.nil? && temp.right != nil
      parent.left == temp ? parent.left = temp.right : parent.right = temp.right
    elsif temp.right.nil? && temp.left != nil
      parent.left == temp ? parent.left = temp.left : parent.right = temp.left
    else 
      min = temp.right
      node = min
      parent.left == temp ? parent.left = min : parent.right = min
      delete(node.value, node)
    end 
  end

  def find (value, node = @root)
    return "No node found!" if node.nil?
    case value <=> node.value
    when 0 then return node
    when -1 then find(value, node.left)
    when 1 then find(value, node.right)
    end
  end

  def level_order
    queue = [@root]
    block = []
    until queue.empty?
      current = queue.shift
      block_given? ? yield(current) : block << current
      queue << current.left if current.left != nil
      queue << current.right if current.right != nil
    end
    return block unless block_given?
  end

  def inorder (node = @root, array = [], &block)
    return if node.nil?
    inorder(node.left, array, &block)
    block_given? ? yield(node) : array << node
    inorder(node.right, array, &block)
    array unless block_given?
  end

  def preorder (node = @root, array = [], &block)
    return if node.nil?
    block_given? ? yield(node) : array << node
    preorder(node.left, array, &block)
    preorder(node.right, array, &block)
    array unless block_given?
  end

  def postorder (node = @root, array = [], &block)
    return if node.nil?
    postorder(node.left, array, &block)
    postorder(node.right, array, &block)
    block_given? ? yield(node) : array << node
    array unless block_given?
  end

  def depth (node = @root)
    return -1 if node.nil?
    left_depth = depth(node.left)
    right_depth = depth(node.right)
    return left_depth > right_depth ? left_depth + 1 : right_depth + 1 
  end

  def balanced?
    return (depth(@root.left) - depth(@root.right)).abs <= 1 ? true : false
  end

  def rebalance!
    array = []
    level_order { |a| array << a.value }
    @root = build_tree(array)
  end
end

class Node < Tree
  attr_reader :value
  attr_accessor :left, :right

  def initialize (value)
    @value = value
    @left = nil
    @right = nil
  end 
end

# tests
array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)
puts tree.balanced?
tree.level_order { |a| print a.value.to_s + ", " }
puts " "
tree.preorder { |a| print a.value.to_s + ", " }
puts " "
tree.postorder { |a| print a.value.to_s + ", " }
puts " "
tree.inorder { |a| print a.value.to_s + ", " }
puts " "
tree.insert(100)
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(104)
puts tree.balanced?
tree.rebalance!
puts tree.balanced?
tree.delete(54)
tree.level_order { |a| print a.value.to_s + ", " }
puts " "
tree.preorder { |a| print a.value.to_s + ", " }
puts " "
tree.postorder { |a| print a.value.to_s + ", " }
puts " "
tree.inorder { |a| print a.value.to_s + ", " }
puts " "
