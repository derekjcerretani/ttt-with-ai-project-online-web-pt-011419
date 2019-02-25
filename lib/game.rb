class Game

  attr_accessor :board, :player_1, :player_2, :winner, :user_input

  WIN_COMBINATIONS = [[0,1,2],
                      [3,4,5],
                      [6,7,8],
                      [0,3,6],
                      [1,4,7],
                      [2,5,8],
                      [0,4,8],
                      [6,4,2]]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
    @board.display
  end

  def current_player
    x = self.board.cells.count { |x| x == "X"}
    o = self.board.cells.count{ |o| o == "O"}
    if x <= o
      current_player = player_1
    else
      current_player = player_2
    end
    current_player
  end

  def won?
    WIN_COMBINATIONS.each do |combination|   #[0,1,2] which is board range (0-8)
      if @board.cells[combination[0]] == @board.cells[combination[1]] &&
        @board.cells[combination[1]] == @board.cells[combination[2]] &&
        @board.taken?(combination[0]+1)
        #Need to +1, because #taken? rspec test is working off user_input range (1-9)
        return combination
        end
      end
    return false
  end

  def draw?
    #won? == false
    @board.full? && !won? ? true : false
  end

  def over?
    # if won? || draw?
    #   true unless self.board.cells.include?(" ")
    # end
    (won? || draw?) ? true : false
  end

  def winner
    if won?
      combination = won?
      self.board.cells[combination[0]]
    end
  end

  def turn
    puts "Enter a number 1 - 9:"
    @user_input = current_player.move(@board)
    if @board.valid_move?(@user_input)
      @board.update(@user_input, current_player)
    else puts "Please enter a number 1-9:"
      @board.display
      turn
    end
    @board.display
  end

  def play
    turn until over?
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end

end
