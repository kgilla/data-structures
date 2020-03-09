class Tree 
  attr_accessor :root

  def initialize (array)
    @root = nil 
    build_tree(array)
  end 

  def build_tree (array)
    array.uniq!
    sorted = array.sort
    middle = sorted[sorted.length / 2]
    @root = Node.new(middle)
    array.delete(middle)
    array.each do |new_value|
      insert(new_value)
    end
  end

  def insert (new_value, node = @root)
    case new_value <=> node.value
    when 1 then insert_right(new_value, node)
    when -1 then insert_left(new_value, node)
    when 0 then "Value already exists"
    end
  end

  def insert_left (new_value, node)
    if node.left.nil?
      node.left = Node.new(new_value)
    else
      insert(new_value, node.left)
    end
  end

  def insert_right (new_value, node)
    if node.right.nil?
      node.right = Node.new(new_value)
    else
      insert(new_value, node.right)
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
      puts "2 children"
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
    build_tree(array)
  end
end

class Node
  attr_reader :value
  attr_accessor :left, :right

  def initialize (value)
    @value = value
    @left = nil
    @right = nil
  end 
end

# array = Array.new(10) { rand(1..100) }
array = [34,67,56,12,44,99,87,32,2,65,78,21,52]
tree = Tree.new(array)
tree.insert(25)
# tree.level_order { |a| puts a.value}
# tree.inorder { |a| print "#{a.value} , " }
tree.preorder { |a| print "#{a.value} , " }
puts " "
# tree.postorder { |a| print "#{a.value} , " }
# puts tree.depth
# tree.balanced?
tree.delete(25)
tree.delete(44)
tree.preorder { |a| print "#{a.value} , " }
# tree.rebalance!
# tree.preorder { |a| print "#{a.value} , " }
