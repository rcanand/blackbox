#!/usr/bin/env ruby -wU
require 'byebug'
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
        @atoms = Set.new
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

    def pass_through?(edge_square)
        raise ArgumentError.new("#{edge_square} is not an edge square") unless edge_square?(edge_square)
        if(@num_atoms == 0)
            return true
        end
        false
    end

    def any_atom_between? square1, square2
        raise ArgumentError.new("#{square1} is not a valid square") unless (square1 > 0 && square1 <= @max_inner_square)
        raise ArgumentError.new("#{square2} is not a valid square") unless (square2 > 0 && square2 <= @max_inner_square)
        return false if square1 == square2
        return false if @atoms.empty?

        positions1 = get_positions_from_square_numbers(square1)
        row1, column1 = positions1.first 

        positions2 = get_positions_from_square_numbers(square2)
        row2, column2 = positions2.first 

        if(row1 != row2 && column1 != column2)
            raise ArgumentError.new("#{square1} and #{square2} are not in the same row or column") 
        end

        min_row = [row1, row2].min
        max_row = [row1, row2].max
        row_range = (min_row..max_row)
        min_column = [column1, column2].min
        max_column = [column1, column2].max
        column_range = (min_column..max_column)

        @atoms.each do |atom|
            atom_positions = get_positions_from_square_numbers(atom)
            atom_row, atom_column = atom_positions.first 
            if(row_range.include?(atom_row) && column_range.include?(atom_column))
                return true
            end
        end
        return false
    end

    def hit?(edge_square)
        raise ArgumentError.new("#{edge_square} is not an edge square") unless edge_square?(edge_square)
        if @atoms.empty?
            return false
        end

        facing_edge_square = get_facing_edge_square(edge_square)
        any_atom_between?(edge_square, facing_edge_square)
    end

    def probe(edge_square)
        raise ArgumentError.new("#{edge_square} is not an edge square") unless edge_square?(edge_square)
        
        if(pass_through?(edge_square))
            return get_facing_edge_square(edge_square)
        elsif hit?(edge_square)
            return :hit
        end 
    end

    def get_positions_from_square_numbers(square)
        @positions_from_square_numbers[square]
    end

    def set_atoms *squares
        squares.each do |square|
            raise ArgumentError.new("#{square} is not an inner square") unless inner_square?(square)
        end
        @atoms = squares.to_set
        @num_atoms = @atoms.length
    end

    private

    def get_facing_edge_square edge_square
        raise ArgumentError.new("#{edge_square} is not an edge square") unless edge_square?(edge_square)
        positions = get_positions_from_square_numbers(edge_square)
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
end
