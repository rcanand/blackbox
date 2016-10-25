#!/usr/bin/env ruby -wU
require 'set'
class Blackbox
    attr_reader :dimension, :num_atoms, 
        :outer_dimension, :outer_grid_area, 
        :square_numbers_from_positions,
        :positions_from_square_numbers,
        :min_inner_square, :max_inner_square,
        :atoms,
        :guesses

    def initialize dimension, num_atoms
        raise ArgumentError.new("dimension and num_atoms must be integers") unless dimension.instance_of?(Fixnum) && num_atoms.instance_of?(Fixnum)
        raise ArgumentError.new("dimension must be between 2 and 50 inclusive") unless dimension > 0 && dimension < 51
        raise ArgumentError.new("num_atoms must be between 0 and dimension inclusive") unless num_atoms >= 0 && num_atoms <= dimension
        @dimension = dimension
        @outer_dimension = dimension + 2
        @outer_grid_area = @outer_dimension * @outer_dimension
        @min_inner_square = @dimension*4 +1
        @max_inner_square = @dimension*(4 + @dimension)

        @square_numbers_from_positions = {}
        @positions_from_square_numbers = Hash.new {|hash, key| hash[key] = Array.new}
        @outer_dimension.times do |row|
            @outer_dimension.times do |column|
                square = get_square_number_from_position(row, column)
                @square_numbers_from_positions[[row, column]] = square
                @positions_from_square_numbers[square] << [row, column]
            end
        end

        

        @num_atoms = num_atoms
        @atoms = []
        @num_atoms.times do 
            atom = @min_inner_square + rand(@dimension * @dimension)
            while(@atoms.include?(atom))
                atom = @min_inner_square + rand(@dimension * @dimension)
            end
            @atoms << atom
        end

        @guesses = Set.new

        # @probe_map = {}
        # build_probe_map
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

    def inner_square?(square)
        (@min_inner_square..@max_inner_square).include?(square)
    end

    def edge_square?(square)
        (1..(@min_inner_square - 1)).include?(square)
    end  

    def toggle_guess(square)
        raise ArgumentError.new("Invalid guess square") unless (@min_inner_square..@max_inner_square).include?(square)
        if(@guesses.include?(square))
            @guesses.delete(square)
        else
            @guesses << square
        end
    end   



    def probe(square)
        raise ArgumentError.new("Invalid probe square") unless (1..(@min_inner_square-1)).include?(square)
        positions = get_positions_from_square_numbers(square)
        
        row, column = positions.first
        if(row == 0) 
            @square_numbers_from_positions[[@outer_dimension - 1, column]]
        elsif(row == @outer_dimension - 1) 
            @square_numbers_from_positions[[0, column]]
        elsif(column == 0)
            @square_numbers_from_positions[[row, @outer_dimension - 1]]
        elsif(column == @outer_dimension - 1)
            @square_numbers_from_positions[[row, 0]]
        end
    end

    def get_positions_from_square_numbers(square)
        @positions_from_square_numbers[square]
    end
end
