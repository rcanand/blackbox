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
            bb.draw
        end
    end
end
