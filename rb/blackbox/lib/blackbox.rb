require 'byebug'
require 'set'

class Blackbox
    attr_reader :dimension, :num_atoms, 
        :outer_dimension, :outer_grid_area, 
        :square_numbers_from_positions,
        :positions_from_square_numbers,
        :min_inner_square, :max_inner_square,
        :atoms,
        :guesses,
        :probes, 
        :probe_map,
        :toggle_guess_count

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
        @probes = Set.new
        @probe_map = {}
        build_probe_map

        @toggle_guess_count = 0
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

    def get_square_string square
        if(@guesses.include?(square))
            return "(#{square}G)"
        elsif(@probes.include?(square) || @probes.include?(@probe_map[square]))
            pair_square = @probe_map[square]
            if(pair_square.instance_of?(Fixnum))
                return "(#{square}.#{@probe_map[square]})"
            else
                return "(#{square}.#{@probe_map[square].to_s[0].upcase})"
            end    
        end

        return square.to_s
    end

    def draw_grid
        str = "\n\n"
        max_column_width = (2*@max_inner_square.to_s.length + 1) + 2
        @outer_dimension.times do |row|
            @outer_dimension.times do |column|
                square = @square_numbers_from_positions[[row, column]]
                str += get_square_string(square).center(max_column_width)
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

        @toggle_guess_count += 1
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

        if((row1 == row2 && row1 == 0) ||
            (row1 == row2 && row1 == @outer_dimension - 1) ||
            (column1 == column2 && column1 == 0) ||
            (column1 == column2 && column1 == @outer_dimension - 1)
            )
            raise ArgumentError.new("#{square1} and #{square2} are on the same edge")  
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

    def get_edge_direction edge_square
        raise ArgumentError.new("#{edge_square} is not an edge square") unless edge_square?(edge_square)
        positions = get_positions_from_square_numbers(edge_square)
        row, column = positions.first
        if(row == 0) 
            return :down
        elsif(row == @outer_dimension - 1) 
            return :up
        elsif(column == 0)
            return :right
        elsif(column == @outer_dimension - 1)
            return :left
        end
        raise ArgumentError.new("Should never reach here")
    end

    def get_front_square(square, direction)
        raise ArgumentError.new("#{square} is not a valid square") unless (edge_square?(square) || inner_square?(square))
        positions = get_positions_from_square_numbers(square)
        row, column = positions.first
        case direction
        when :up
            if(row == 0)
                raise ArgumentError.new("Attempting to move out of bounds in up direction")
            else
                return @square_numbers_from_positions[[row - 1, column]]
            end
        when :down
            if(row == @outer_dimension - 1)
                raise ArgumentError.new("Attempting to move out of bounds in down direction")
            else
                return @square_numbers_from_positions[[row + 1, column]]
            end
        when :left
            if(column == 0)
                raise ArgumentError.new("Attempting to move out of bounds in left direction")
            else
                return @square_numbers_from_positions[[row, column - 1]]
            end
        when :right
            if(column == @outer_dimension - 1)
                raise ArgumentError.new("Attempting to move out of bounds in right direction")
            else
                return @square_numbers_from_positions[[row, column + 1]]
            end
        else
            raise RuntimeError.new("Should never land here!")
        end
    end

    def get_front_left_square(square, direction)
        raise ArgumentError.new("#{square} is not a valid square") unless (edge_square?(square) || inner_square?(square))
        positions = get_positions_from_square_numbers(square)
        row, column = positions.first
        case direction
        when :up
            if(row == 0 || column == 0)
                return nil
            end
            return @square_numbers_from_positions[[row - 1, column - 1]]
        when :down
            if(row == @outer_dimension - 1 || column == @outer_dimension - 1)
                return nil
            end
            return @square_numbers_from_positions[[row + 1, column+1]]
        when :left
            if(column == 0 || row == @outer_dimension - 1)
                return nil
            end
            return @square_numbers_from_positions[[row + 1, column - 1]]
            
        when :right
            if(column == @outer_dimension - 1 || row == 0)
                return nil
            end
            return @square_numbers_from_positions[[row - 1, column + 1]]
        else
            raise RuntimeError.new("Should never land here!")
        end
    end

    def get_front_right_square(square, direction)
        raise ArgumentError.new("#{square} is not a valid square") unless (edge_square?(square) || inner_square?(square))
        positions = get_positions_from_square_numbers(square)
        row, column = positions.first
        case direction
        when :up
            if(row == 0 || column == @outer_dimension - 1)
                return nil
            end
            return @square_numbers_from_positions[[row - 1, column + 1]]
        when :down
            if(row == @outer_dimension - 1 || column == 0)
                return nil
            end
            return @square_numbers_from_positions[[row + 1, column - 1]]
        when :left
            if(column == 0 || row == 0)
                return nil
            end
            return @square_numbers_from_positions[[row - 1, column - 1]]
            
        when :right
            if(column == @outer_dimension - 1 || row == @outer_dimension - 1)
                return nil
            end
            return @square_numbers_from_positions[[row + 1, column + 1]]
        else
            raise RuntimeError.new("Should never land here!")
        end
    end

    def reverse(direction)
        case direction
        when :up
            return :down
        when :down
            return :up
        when :left
            return :right
        when :right
            return :left
        else
            raise ArgumentError.new("Invalid direction")
        end
    end

    def turn_left(direction)
        case direction
        when :up
            return :left
        when :down
            return :right
        when :left
            return :down
        when :right
            return :up
        else
            raise ArgumentError.new("Invalid direction")
        end
    end

    def turn_right(direction)
        case direction
        when :up
            return :right
        when :down
            return :left
        when :left
            return :up
        when :right
            return :down
        else
            raise ArgumentError.new("Invalid direction")
        end
    end    

    def step(start, current, direction)
        raise ArgumentError.new("#{start} is not an edge square") unless edge_square?(start) 
        raise ArgumentError.new("#{current} is not a valid square") unless (edge_square?(current) || inner_square?(current))
        if(start == current && get_edge_direction(start) == reverse(direction))
            return :reflection
        end

        front_square = get_front_square(current, direction)
        if(edge_square?(front_square))
            return [front_square, direction]
        elsif(@atoms.include?(front_square))
            return :hit
        end

        front_left_square = get_front_left_square(current, direction)
        front_right_square = get_front_right_square(current, direction)
        if(front_left_square && front_right_square)
            front_left_atom = @atoms.include?(front_left_square) 
            front_right_atom = @atoms.include?(front_right_square)
            if front_left_atom && front_right_atom
                return [current, reverse(direction)]
            end
            if(front_left_atom)
                return [current, turn_right(direction)]
            end
            if(front_right_atom)
                return [current, turn_left(direction)]
            end
            return [front_square, direction]
        end
        
        if(front_left_square) # (and !front_right_square)
            front_left_atom = @atoms.include?(front_left_square)
            if(front_left_atom)
                return [current, turn_right(direction)]
            end
            return [front_square, direction]
        end

        if(front_right_square) # (and !front_left_square)
            front_right_atom = @atoms.include?(front_right_square)
            if(front_right_atom)
                return [current, turn_left(direction)]
            end
            return [front_square, direction]
        end

        return [front_square, direction]

    end



    def probe(start, record = true)
        raise ArgumentError.new("#{start} is not an edge square") unless edge_square?(start)
        if record
            @probes << start
        end
        
        direction = get_edge_direction(start)
        current = start
        next_step = step(start, current, direction)
        if(!next_step.instance_of?(Array))
            return next_step
        else
            current = next_step[0]
            direction = next_step[1]
            while(!edge_square?(current))
                next_step = step(start, current, direction)
                if(!next_step.instance_of?(Array))
                    return next_step
                else
                    current = next_step[0]
                    direction = next_step[1]
                end    
            end
            if(current == start)
                return :reflection
            else
                return current
            end
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
        @probes = Set.new
        build_probe_map
    end

    def game_over?
        @atoms == @guesses
    end

    def draw_move
        if(game_over?)
            puts "Congratulations! Game Over."
            puts 
        end
        puts "Game with #{@dimension} x #{@dimension} grid, and #{num_atoms} hidden atoms"
        puts 
        puts "Guesses on board: #{@guesses.count}"
        puts "Guesses made so far: #{@toggle_guess_count}"
        puts "Moves made so far: #{@probes.count}"
        puts 
        draw_grid
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

    def build_probe_map
        (1..@min_inner_square - 1).each do |square|
            @probe_map[square] = probe(square, false)
        end
    end
end
