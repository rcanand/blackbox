#!/usr/bin/env ruby -wU
require "matrix"
require 'set'

class BlackBox
    CORNER = 0

    def initialize grid_size, num_atoms
        @inner_grid_dimension = grid_size
        @outer_grid_dimension = grid_size + 2
        @grid_square_count = @outer_grid_dimension*@outer_grid_dimension
        @num_atoms = num_atoms
        @square_to_pos = Hash.new { Array.new }
        @grid = Matrix.build(@outer_grid_dimension, @outer_grid_dimension) do |row, col| 
            square_number = get_square_number(row, col)
            @square_to_pos[square_number] << [row, col]
            square_number
        end

        @original_grid = @grid.dup

        @inner_square_min = 4*@inner_grid_dimension + 1
        @inner_square_max = (4 + @inner_grid_dimension) * @inner_grid_dimension

        @atom_squares = []
        @atom_positions = []
        @num_atoms.each do
            atom_square = 4*@inner_grid_dimension + rand(@inner_grid_dimension * @inner_grid_dimension)
            while(@atom_squares.include?(atom_square))
                atom_square = 4*@inner_grid_dimension + rand(@inner_grid_dimension * @inner_grid_dimension)
            end
            @atom_squares << atom_square
            @atom_positions << @square_to_pos[atom_square]
        end
        @guess_positions = Set.new
        @marked_edge_positions = {}
    end

    def draw
        # TODO: print game summary

        # TODO: print grid
        grid_str = ""
        square_str_size = @grid_square_count.to_s.length + 10
        @grid.to_a.each do |col|
            col.each do |value|
                grid_str += value.to_s.center(square_str_size)
            end
            grid_str += "\n"
        end
        print grid_str

        if game_over?
            # TODO: print game over message and draw final board state
        else
            puts "Enter move as a grid location"
            puts "If number is on periphery, a beam is shot from that position"
            puts "If number is inside the board, the position state is toggled - free or locked"
            puts "When guesses have covered all the correct spots, game ends"
        end

    end

    def get_square_number(row, col)
        corners = [@outer_grid_dimension - 1, 0]
        if(corners.include?(row) && corners.include?(col))
            return CORNER
        elsif(row == 0) # top edge
            return col 
        elsif(col == @outer_grid_dimension - 1) # right edge
            return (@inner_grid_dimension + row)
        elsif(row == @outer_grid_dimension - 1) # bottom edge
            return ((2*@inner_grid_dimension) + @inner_grid_dimension - col + 1)
        elsif(col == 0) # left edge
            return ((3*@inner_grid_dimension) + @inner_grid_dimension - row + 1)
        else
            return ((4*@inner_grid_dimension) + ((row - 1) * @inner_grid_dimension) + col)
        end
    end

    def game_over?
        false
    end

    def move(square)
        if edge_square?(square)
            return shoot(square)
        elsif inner_square?(square)
            toggle_guess(square)
        else
            raise ArgumentError("Invalid move: #{square}")
        end
    end

    def edge_square?(square)
        square.kind_of?(Integer) && square > 0 && square < @inner_square_min
    end

    def inner_square?(square)
        square.kind_of?(Integer) && square >= @inner_square_min && square <= @inner_square_max
    end

    def shoot(square)
        unless edge_square?(start_square)
            raise ArgumentError("Invalid shoot square: #{square}")
        end

        start_pos = @square_to_pos[square]

    end

    def toggle_guess(square)
        unless inner_square?(square)
            raise ArgumentError("Invalid guess square: #{square}")
        end

        pos = @square_to_pos[square]
        if(@guess_positions.include?(pos))
            @guess_positions.delete(pos)
        else
            @guess_positions << pos
        end
    end
end

# main
grid_size = ARGV[0] || 8
num_atoms = ARGV[1] || 3

bb = BlackBox.new(grid_size, num_atoms)

bb.draw
while(!bb.game_over)    
    square = gets.strip.to_i
    result = bb.move(square)
    bb.draw
end
bb.draw