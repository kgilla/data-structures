class LinkedList
  attr_accessor :head, :tail, :size

  def initialize (value)
    @head = Node.new(value)
    @tail = @head
    @size = 1
  end

  def append (value)
    node = Node.new(value)
    @tail.next_node = node
    @tail = node
    @size += 1
  end

  def prepend (value)
    node = Node.new(value, @head)
    @head = node
    @size += 1
  end

  def at (index)
    node = @head
    index.times { node = node.next_node }
    return node.value
  end

  def pop
    node = @tail; prev = @head; new_size = @size - 2
    new_size.times { prev = prev.next_node}
    @tail = prev
    @size -= 1
  end

  def contains? (value)
    node = @head
    until node.next_node == nil
      if node.value == value
        return true
      else
        node = node.next_node
      end
    end
    return false
  end

  def find (value)
    index = 0 
    node = @head
    until node.next_node == nil
      if node.value == value 
        return index
      else 
        node = node.next_node
        index += 1
      end
    end
    return nil
  end

  def to_s
    node = @head
    @size.times do 
      if node == @tail
        puts "( #{node.value} ) -> nil"
      else  
        print "( #{node.value} ) -> " 
        node = node.next_node
      end
    end
  end

  def insert_at (value, index)
    node = Node.new(value)
    finder = @head; prev = @head; prev_index = index - 1
    index.times { finder = finder.next_node }
    prev_index.times { prev = prev.next_node }
    node.next_node = finder
    prev.next_node = node
    @size += 1
  end

  def remove_at (index)
  finder = @head; prev = @head; post = @head
  prev_index = index - 1; post_index = index + 1
  index.times { finder = finder.next_node }
  prev_index.times { prev = prev.next_node }
  post_index.times { post = post.next_node }
  prev.next_node = post
  @size -= 1
  end
end

class Node < LinkedList
  attr_accessor :next_node
  attr_reader :value

  def initialize (value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end

node = Node.new(10)
puts node.next_node