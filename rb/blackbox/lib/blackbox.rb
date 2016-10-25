#!/usr/bin/env ruby -wU
require 'matrix'
class Blackbox
    attr_reader :dimension, :num_atoms, 
        :outer_dimension, :outer_grid_area, 
        :grid, :square_numbers_from_positions,
        :min_inner_square, :max_inner_square

    def initialize dimension, num_atoms
        raise ArgumentError.new("dimension and num_atoms must be integers") unless dimension.instance_of?(Fixnum) && num_atoms.instance_of?(Fixnum)
        raise ArgumentError.new("dimension must be between 2 and 50 inclusive") unless dimension > 0 && dimension < 51
        raise ArgumentError.new("num_atoms must be between 0 and dimension inclusive") unless num_atoms >= 0 && num_atoms <= dimension
        @dimension = dimension
        @outer_dimension = dimension + 2
        @outer_grid_area = @outer_dimension * @outer_dimension
        @square_numbers_from_positions = {}
        @outer_dimension.times do |row|
            @outer_dimension.times do |column|
                @square_numbers_from_positions[[row, column]] = get_square_number_from_position(row, column)
            end
        end

        @min_inner_square = @dimension*4 +1
        @max_inner_square = @dimension*(4 + @dimension)

        @num_atoms = num_atoms
    end

    def get_square_number_from_position row, column
        extremes = [0, @outer_dimension - 1]
        if(extremes.include?(row) && extremes.include?(column)) # corners
            return 0
        elsif(row == 0) # top edge
            return column
        elsif(column == @outer_dimension - 1) # right edge
            return (@dimension + row)
        elsif(row == @outer_dimension - 1) # bottom edge
            return (2*@dimension + (@dimension - column + 1))
        elsif(column == 0) # left edge
            return (3*@dimension + dimension - row + 1)
        else # inner square
            return (4 * @dimension + (row - 1) * @dimension + column)
        end
    end

    def draw_grid
        str = "\n\n"
        max_column_width = @max_inner_square.to_s.length + 2
        @outer_dimension.times do |row|
            @outer_dimension.times do |column|
                str += @square_numbers_from_positions[[row, column]].to_s.center(max_column_width)
            end
            str += "\n"
        end 
        str += "\n"
        puts str
    end

    def valid_move?(square)
        (1..@max_inner_square).include?(square)
    end
end