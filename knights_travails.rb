class ChessBoard
  attr_reader :squares_hash, :first, :last

  def initialize (first, last)
    @first = first
    @last = last
    @squares_hash = make_hash
    add_possible_moves
  end
  
  def make_hash
    squares_hash = {}
    for x in 0..7 
      for y in 0..7 
        squares_hash[[x,y]] = Square.new([x, y])
      end
    end
    return squares_hash
  end

  def add_possible_moves
    knight_moves = [[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[-1,2]]
    @squares_hash.values.each do |square|
      knight_moves.each do |move|
        if @squares_hash[make_moves(square.location, move)]
          square.possible_moves.push(
            @squares_hash[make_moves(square.location, move)])
        end
      end
    end
  end

  def make_moves (location, move)
    new_location = [location[0] + move[0], location[1] + move[1]]
  end

  def level_order
    queue = [@squares_hash[@first]]; squares_checked = []
    until queue.length == 0
      current_square = queue.shift
      if current_square.location == last
        return find(current_square)
      else
        squares_checked.push(current_square)  
        current_square.possible_moves.each do |move|
        unless squares_checked.include?(move)
          move.previous_move = current_square
          queue.push(move)
        end
        end
      end
    end
  end
  
  def find(current_square)
      path_to_last = [current_square.location]
      until current_square.previous_move.nil?
        current_square = current_square.previous_move
        path_to_last.unshift(current_square.location)
      end
    return path_to_last
  end
end

class Square
  attr_accessor :previous_move, :possible_moves
  attr_reader :location

  def initialize (location)
    @location = location
    @previous_move = nil
    @possible_moves = []
  end
end

  board = ChessBoard.new([0,0],[7,7])
  p board.level_order

