require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if board.over?
      return board.won? && board.winner != evaluator
    end

    if self.next_mover_mark == evaluator
      self.children.all? { |node| node.losing_node?(evaluator)}
    else
      self.children.any? { |node| node.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
    # base case: the game is over and we've won
    if board.over?
      return board.winner == evaluator
    end

    # recursive case/inductive step
    if self.next_mover_mark == evaluator
      # if we can place any mark that could eventually lead to a win
      # then this is a winning node
      self.children.any?{ |node| node.winning_node?(evaluator)}
    else
      # if its the opponent's turn, and no matter where they move
      # we'll be able to force a win, then this is a winning node
      self.children.all?{ |node| node.winning_node?(evaluator)}
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    kids = Array.new()

    (0..2).each do |row_idx|
      (0..2).each do |col_idx|
        pos = [row_idx, col_idx]

        # can't move here unless it's free
        next unless @board.empty?(pos)

        new_board = @board.dup
        new_board[pos] = self.next_mover_mark
        next_mover_mark = (self.next_mover_mark == :x ? :o : :x)

        kids << TicTacToeNode.new(new_board, next_mover_mark, pos)
      end
    end

    kids
  end
end
