# require 'byebug'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/blackbox.rb'


class TestBlackbox < Minitest::Test
    PARAMETERS = [
        [1,0],
        [1,1],
        [8,3],
        [10,0],
        [10,1],
        [10,10],
        [50,0],
        [50,1],
        [50,10],
        [50,50]
    ]

    def test_bb_class
        Blackbox
    end

    def test_bb_new_instance_no_param_errors
        assert_raises(ArgumentError) {Blackbox.new}
    end

    def test_bb_new_instance_one_param_errors
        assert_raises(ArgumentError) {Blackbox.new "foo"}
    end

    def test_bb_new_instance_two_string_params_fails
        assert_raises(ArgumentError) {Blackbox.new "foo", "bar"}
    end

    def test_valid_new_bb
        Blackbox.new 1, 0
        Blackbox.new 1, 1
        Blackbox.new 8,3
        Blackbox.new 10,0
        Blackbox.new 10, 1
        Blackbox.new 10,10
        Blackbox.new 50, 0
        Blackbox.new 50, 1
        Blackbox.new 50, 10
        Blackbox.new 50, 50
    end

    def test_dimension_must_be_between_1_and_50_inclusive
        assert_raises(ArgumentError) {Blackbox.new -1, -1}
        assert_raises(ArgumentError) {Blackbox.new 0, -1}
        assert_raises(ArgumentError) {Blackbox.new 0, 0}
        assert_raises(ArgumentError) {Blackbox.new 51, 1}
        assert_raises(ArgumentError) {Blackbox.new 100, 1}
    end
    
    def test_bb_num_atoms_must_be_between_0_and_dimension_inclusive
        assert_raises(ArgumentError) {Blackbox.new 1, -1}
        assert_raises(ArgumentError) {Blackbox.new 1, 2}
        assert_raises(ArgumentError) {Blackbox.new 1, 10}
        assert_raises(ArgumentError) {Blackbox.new 10, -1}
        assert_raises(ArgumentError) {Blackbox.new 10, 11}
        assert_raises(ArgumentError) {Blackbox.new 10, 50}
        assert_raises(ArgumentError) {Blackbox.new 50, -1}
        assert_raises(ArgumentError) {Blackbox.new 50, 51}
        assert_raises(ArgumentError) {Blackbox.new 50, 100}
    end

    def test_bb_returns_dimension
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension, num_atoms)
            assert_equal(dimension, bb.dimension)
        end
    end

    def test_bb_returns_num_atoms
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension, num_atoms)
            assert_equal(num_atoms, bb.num_atoms)
        end
    end

    def test_bb_returns_correct_outer_dimension
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension, num_atoms)
            assert_equal(dimension + 2, bb.outer_dimension)
        end
    end

    def test_bb_returns_correct_outer_grid_area
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension, num_atoms)
            assert_equal(bb.outer_dimension*bb.outer_dimension, bb.outer_grid_area)
        end
    end 

    def test_square_numbers_from_positions
        bb_1 = Blackbox.new(1, 0)
        
        assert_equal(0, bb_1.get_square_number_from_position(0, 0))
        assert_equal(1, bb_1.get_square_number_from_position(0, 1))
        assert_equal(0, bb_1.get_square_number_from_position(0, 2))
        assert_equal(4, bb_1.get_square_number_from_position(1, 0))
        assert_equal(5, bb_1.get_square_number_from_position(1, 1))
        assert_equal(2, bb_1.get_square_number_from_position(1, 2))
        assert_equal(0, bb_1.get_square_number_from_position(2, 0))
        assert_equal(3, bb_1.get_square_number_from_position(2, 1))
        assert_equal(0, bb_1.get_square_number_from_position(2, 2))

        bb_2 = Blackbox.new(2,0)
        assert_equal(0, bb_2.get_square_number_from_position(0, 0))
        assert_equal(1, bb_2.get_square_number_from_position(0, 1))
        # byebug
        assert_equal(2, bb_2.get_square_number_from_position(0, 2))
        assert_equal(0, bb_2.get_square_number_from_position(0, 3))
        assert_equal(8, bb_2.get_square_number_from_position(1, 0))
        assert_equal(9, bb_2.get_square_number_from_position(1, 1))
        assert_equal(10, bb_2.get_square_number_from_position(1, 2))
        assert_equal(3, bb_2.get_square_number_from_position(1, 3))
        assert_equal(7, bb_2.get_square_number_from_position(2, 0))
        assert_equal(11, bb_2.get_square_number_from_position(2, 1))
        assert_equal(12, bb_2.get_square_number_from_position(2, 2))
        assert_equal(4, bb_2.get_square_number_from_position(2, 3))                
        assert_equal(0, bb_2.get_square_number_from_position(3, 0))
        assert_equal(6, bb_2.get_square_number_from_position(3, 1))
        assert_equal(5, bb_2.get_square_number_from_position(3, 2))
        assert_equal(0, bb_2.get_square_number_from_position(3, 3))
    end

    def test_square_numbers_from_positions_hash
        bb_1 = Blackbox.new(1, 0)
        
        assert_equal(bb_1.get_square_number_from_position(0,0), bb_1.square_numbers_from_positions[[0,0]])
        assert_equal(bb_1.get_square_number_from_position(0,1), bb_1.square_numbers_from_positions[[0,1]])
        assert_equal(bb_1.get_square_number_from_position(0,2), bb_1.square_numbers_from_positions[[0,2]])
        assert_equal(bb_1.get_square_number_from_position(1,0), bb_1.square_numbers_from_positions[[1,0]])
        assert_equal(bb_1.get_square_number_from_position(1,1), bb_1.square_numbers_from_positions[[1,1]])
        assert_equal(bb_1.get_square_number_from_position(1,2), bb_1.square_numbers_from_positions[[1,2]])
        assert_equal(bb_1.get_square_number_from_position(2,0), bb_1.square_numbers_from_positions[[2,0]])
        assert_equal(bb_1.get_square_number_from_position(2,1), bb_1.square_numbers_from_positions[[2,1]])
        assert_equal(bb_1.get_square_number_from_position(2,2), bb_1.square_numbers_from_positions[[2,2]])

        bb_2 = Blackbox.new(2,0)
        assert_equal(bb_2.get_square_number_from_position(0,0), bb_2.square_numbers_from_positions[[0,0]])
        assert_equal(bb_2.get_square_number_from_position(0,1), bb_2.square_numbers_from_positions[[0,1]])
        assert_equal(bb_2.get_square_number_from_position(0,2), bb_2.square_numbers_from_positions[[0,2]])
        assert_equal(bb_2.get_square_number_from_position(0,3), bb_2.square_numbers_from_positions[[0,3]])
        assert_equal(bb_2.get_square_number_from_position(1,0), bb_2.square_numbers_from_positions[[1,0]])
        assert_equal(bb_2.get_square_number_from_position(1,1), bb_2.square_numbers_from_positions[[1,1]])
        assert_equal(bb_2.get_square_number_from_position(1,2), bb_2.square_numbers_from_positions[[1,2]])
        assert_equal(bb_2.get_square_number_from_position(1,3), bb_2.square_numbers_from_positions[[1,3]])
        assert_equal(bb_2.get_square_number_from_position(2,0), bb_2.square_numbers_from_positions[[2,0]])
        assert_equal(bb_2.get_square_number_from_position(2,1), bb_2.square_numbers_from_positions[[2,1]])
        assert_equal(bb_2.get_square_number_from_position(2,2), bb_2.square_numbers_from_positions[[2,2]])
        assert_equal(bb_2.get_square_number_from_position(2,3), bb_2.square_numbers_from_positions[[2,3]])                
        assert_equal(bb_2.get_square_number_from_position(3,0), bb_2.square_numbers_from_positions[[3,0]])
        assert_equal(bb_2.get_square_number_from_position(3,1), bb_2.square_numbers_from_positions[[3,1]])
        assert_equal(bb_2.get_square_number_from_position(3,2), bb_2.square_numbers_from_positions[[3,2]])
        assert_equal(bb_2.get_square_number_from_position(3,3), bb_2.square_numbers_from_positions[[3,3]])
    end

    def test_draw_grid
        [1,2,3,4,5,8,10,12].each do |dimension|
            bb = Blackbox.new(dimension, 0)
            bb.draw_grid
        end
    end

    def test_min_max_inner_grid_squares
       [1,2,3,4,5,8,10,12, 20, 40, 49, 50].each do |dimension|
            bb = Blackbox.new(dimension, 0)
            assert_equal(bb.dimension*4 +1, bb.min_inner_square)
            assert_equal(bb.dimension*(4 + bb.dimension) ,bb.max_inner_square)
        end 
    end

    def test_first_move_squares_validity
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension,num_atoms)
            (1..bb.max_inner_square).each do |square|
                assert(bb.valid_move?(square))
            end

            ([0, -1, -10] + [1,2,3, 10].map{|x| bb.max_inner_square + x}).each do |square|
               refute(bb.valid_move?(square))
            end 
        end
    end

    def test_pick_guesses
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension,num_atoms)
            assert_equal(num_atoms, bb.atoms.count)
            assert_equal(bb.atoms.uniq, bb.atoms)
            bb.atoms.each do |atom|
                assert(atom >= bb.min_inner_square)
                assert(atom <= bb.max_inner_square)
            end
        end
    end

    def test_check_inner_square?
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension,num_atoms)
            10.times do 
                random_square = -1*(rand(3) + 1) * rand(bb.max_inner_square * 2)
                if((bb.min_inner_square..bb.max_inner_square).include?random_square)
                    assert(bb.inner_square?(random_square))
                else
                    refute(bb.inner_square?(random_square))
                end
            end
        end        
    end

    def test_check_edge_square?
        PARAMETERS.each do |dimension, num_atoms|
            bb = Blackbox.new(dimension,num_atoms)
            10.times do 
                random_square = -1*(rand(3) + 1) * rand(bb.max_inner_square * 2)
                if((1..(bb.min_inner_square - 1)).include?(random_square))
                    assert(bb.edge_square?(random_square))
                else
                    refute(bb.edge_square?(random_square))
                end
            end
        end        
    end

    def test_guess_validity
        bb = Blackbox.new(8,3)
        assert_raises(ArgumentError){bb.toggle_guess(-10)}
        assert_raises(ArgumentError){bb.toggle_guess(-1)}
        assert_raises(ArgumentError){bb.toggle_guess(0)}
        assert_raises(ArgumentError){bb.toggle_guess(1)}
        assert_raises(ArgumentError){bb.toggle_guess(2)}
        assert_raises(ArgumentError){bb.toggle_guess(5)}
        assert_raises(ArgumentError){bb.toggle_guess(8)}
        assert_raises(ArgumentError){bb.toggle_guess(9)}
        assert_raises(ArgumentError){bb.toggle_guess(10)}
        assert_raises(ArgumentError){bb.toggle_guess(13)}
        assert_raises(ArgumentError){bb.toggle_guess(16)}
        assert_raises(ArgumentError){bb.toggle_guess(20)}
        assert_raises(ArgumentError){bb.toggle_guess(24)}
        assert_raises(ArgumentError){bb.toggle_guess(28)}
        assert_raises(ArgumentError){bb.toggle_guess(32)}

        bb.toggle_guess(33)
        bb.toggle_guess(40)
        bb.toggle_guess(50)
        bb.toggle_guess(96)

        assert_raises(ArgumentError){bb.toggle_guess(97)}        
        assert_raises(ArgumentError){bb.toggle_guess(100)}
    end

    def test_guess_toggle
        bb = Blackbox.new(8,3)
        assert_empty(bb.guesses)
        bb.toggle_guess(33)
        assert_equal(1, bb.guesses.length)
        assert_includes(bb.guesses, 33)

        bb.toggle_guess(33)
        assert_empty(bb.guesses)

        bb.toggle_guess(33)
        assert_equal(1, bb.guesses.length)
        assert_includes(bb.guesses, 33)

        bb.toggle_guess(45)
        assert_equal(2, bb.guesses.length)
        assert_includes(bb.guesses, 33)
        assert_includes(bb.guesses, 45)                
    end

    def test_probe_validity
        bb = Blackbox.new(8,3)
        assert_raises(ArgumentError){bb.probe(-10)}
        assert_raises(ArgumentError){bb.probe(-1)}
        assert_raises(ArgumentError){bb.probe(0)}
        bb.probe(1)
        bb.probe(2)
        bb.probe(5)
        bb.probe(8)
        bb.probe(9)
        bb.probe(10)
        bb.probe(13)
        bb.probe(16)
        bb.probe(20)
        bb.probe(24)
        bb.probe(28)
        bb.probe(32)

        assert_raises(ArgumentError){bb.probe(33)}
        assert_raises(ArgumentError){bb.probe(40)}
        assert_raises(ArgumentError){bb.probe(50)}
        assert_raises(ArgumentError){bb.probe(96)}

        assert_raises(ArgumentError){bb.probe(97)}        
        assert_raises(ArgumentError){bb.probe(100)}
    end

    def test_positions_from_square_numbers
        bb_1 = Blackbox.new(1, 0)
        
        # assert_equal(0, bb_1.get_square_number_from_position(0, 0))
        # assert_equal(0, bb_1.get_square_number_from_position(0, 2))
        # assert_equal(0, bb_1.get_square_number_from_position(2, 0))
        # assert_equal(0, bb_1.get_square_number_from_position(2, 2))

        assert_equal([[0,0], [0,2], [2,0], [2,2]], bb_1.get_positions_from_square_numbers(0))

        # assert_equal(1, bb_1.get_square_number_from_position(0, 1))
        assert_equal([[0,1]], bb_1.get_positions_from_square_numbers(1))
        
        # assert_equal(4, bb_1.get_square_number_from_position(1, 0))
        assert_equal([[1,0]], bb_1.get_positions_from_square_numbers(4))

        # assert_equal(5, bb_1.get_square_number_from_position(1, 1))
        assert_equal([[1,1]], bb_1.get_positions_from_square_numbers(5))

        # assert_equal(2, bb_1.get_square_number_from_position(1, 2))
        assert_equal([[1,2]], bb_1.get_positions_from_square_numbers(2))
        
        # assert_equal(3, bb_1.get_square_number_from_position(2, 1))
        assert_equal([[2,1]], bb_1.get_positions_from_square_numbers(3))
        
        bb_2 = Blackbox.new(2,0)

        # assert_equal(0, bb_2.get_square_number_from_position(0, 0))
        # assert_equal(0, bb_2.get_square_number_from_position(0, 3))
        # assert_equal(0, bb_2.get_square_number_from_position(3, 0))
        # assert_equal(0, bb_2.get_square_number_from_position(3, 3))
        assert_equal([[0,0], [0,3], [3,0], [3,3]], bb_2.get_positions_from_square_numbers(0))

        # assert_equal(1, bb_2.get_square_number_from_position(0, 1))
        assert_equal([[0,1]], bb_2.get_positions_from_square_numbers(1))

        # assert_equal(2, bb_2.get_square_number_from_position(0, 2))
        assert_equal([[0,2]], bb_2.get_positions_from_square_numbers(2))
        
        # assert_equal(8, bb_2.get_square_number_from_position(1, 0))
        assert_equal([[1,0]], bb_2.get_positions_from_square_numbers(8))

        # assert_equal(9, bb_2.get_square_number_from_position(1, 1))
        assert_equal([[1,1]], bb_2.get_positions_from_square_numbers(9))

        # assert_equal(10, bb_2.get_square_number_from_position(1, 2))
        assert_equal([[1,2]], bb_2.get_positions_from_square_numbers(10))

        # assert_equal(3, bb_2.get_square_number_from_position(1, 3))
        assert_equal([[1,3]], bb_2.get_positions_from_square_numbers(3))

        # assert_equal(7, bb_2.get_square_number_from_position(2, 0))
        assert_equal([[2,0]], bb_2.get_positions_from_square_numbers(7))

        # assert_equal(11, bb_2.get_square_number_from_position(2, 1))
        assert_equal([[2,1]], bb_2.get_positions_from_square_numbers(11))

        # assert_equal(12, bb_2.get_square_number_from_position(2, 2))
        assert_equal([[2,2]], bb_2.get_positions_from_square_numbers(12))

        # assert_equal(4, bb_2.get_square_number_from_position(2, 3))                
        assert_equal([[2,3]], bb_2.get_positions_from_square_numbers(4))
        
        # assert_equal(6, bb_2.get_square_number_from_position(3, 1))
        assert_equal([[3,1]], bb_2.get_positions_from_square_numbers(6))

        # assert_equal(5, bb_2.get_square_number_from_position(3, 2))
        assert_equal([[3,2]], bb_2.get_positions_from_square_numbers(5))
    end

    def test_square_numbers_from_positions_hash
        bb_1 = Blackbox.new(1, 0)
        
        (0..bb_1.max_inner_square).each do |square|
            assert_equal(bb_1.get_positions_from_square_numbers(square), bb_1.positions_from_square_numbers[square])
        end
        
        bb_2 = Blackbox.new(2,0)
        (0..bb_2.max_inner_square).each do |square|
            assert_equal(bb_2.get_positions_from_square_numbers(square), bb_2.positions_from_square_numbers[square])
        end
    end

    def test_probe_no_atoms
        dims = [1,2,3,4,5,8,10,20,50]
        dims.each do |dimension|
            bb = Blackbox.new(dimension, 0)
            (1..(bb.min_inner_square - 1)).each do |square|
                positions = bb.get_positions_from_square_numbers(square)
                assert_equal(1, positions.length)
                row, column = positions.first
                if(row == 0 ) 
                    assert_equal(bb.square_numbers_from_positions[[bb.outer_dimension - 1, column]], 
                        bb.probe(square))
                elsif(row == bb.outer_dimension - 1) 
                    assert_equal(bb.square_numbers_from_positions[[0, column]], 
                        bb.probe(square))
                elsif(column == 0)
                    assert_equal(bb.square_numbers_from_positions[[row, bb.outer_dimension - 1]], 
                        bb.probe(square))
                elsif(column == bb.outer_dimension - 1)
                    assert_equal(bb.square_numbers_from_positions[[row, 0]], 
                        bb.probe(square))    
                end
            end
        end
    end
end
