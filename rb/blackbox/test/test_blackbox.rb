require 'simplecov'
SimpleCov.start
require 'byebug'
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

    def test_check_pass_through_square_no_atoms
        dims = [1,2,3,4,5,8,10,20,50]
        dims.each do |dimension|
            bb = Blackbox.new(dimension, 0)
            assert_raises(ArgumentError){bb.pass_through?(-10)}
            assert_raises(ArgumentError){bb.pass_through?(-1)}
            assert_raises(ArgumentError){bb.pass_through?(0)}
            assert_raises(ArgumentError){bb.pass_through?(bb.min_inner_square)}
            assert_raises(ArgumentError){bb.pass_through?(bb.min_inner_square + 1)}
            assert_raises(ArgumentError){bb.pass_through?(bb.min_inner_square + 10)}
            
            (1..(bb.min_inner_square - 1)).each do |square|
                assert(bb.pass_through?(square))
            end
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

    def test_probe_1_0
        # dim = 1, atoms = 0
        bb = Blackbox.new(1,0)
        assert_equal(3, bb.probe(1));
        assert_equal(4, bb.probe(2));
        assert_equal(1, bb.probe(3));
        assert_equal(2, bb.probe(4));
    end

    def test_set_atoms
        bb = Blackbox.new(1,0)
        assert_equal(bb.num_atoms, 0)
        assert_empty(bb.atoms)

        assert_raises(ArgumentError){bb.set_atoms(-10)}
        assert_raises(ArgumentError){bb.set_atoms(-1)}
        assert_raises(ArgumentError){bb.set_atoms(0)}
        assert_raises(ArgumentError){bb.set_atoms(1)}
        assert_raises(ArgumentError){bb.set_atoms(2)}
        assert_raises(ArgumentError){bb.set_atoms(3)}
        assert_raises(ArgumentError){bb.set_atoms(4)}
        bb.set_atoms(5)
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 5)
        bb.set_atoms(5)
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 5)
        bb.set_atoms(5,5,5)
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 5)
        assert_raises(ArgumentError){bb.set_atoms(5,6)}
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 5)
        refute_includes(bb.atoms, 6)
        assert_raises(ArgumentError){bb.set_atoms(6)}
        assert_raises(ArgumentError){bb.set_atoms(7)}
        assert_raises(ArgumentError){bb.set_atoms(10)}
        bb.set_atoms
        assert_equal(0, bb.num_atoms)
        assert_empty(bb.atoms)

        bb = Blackbox.new(8,3)
        assert_equal(bb.num_atoms, 3)
        assert_raises(ArgumentError){bb.set_atoms(-10)}
        assert_raises(ArgumentError){bb.set_atoms(-1)}
        assert_raises(ArgumentError){bb.set_atoms(0)}
        assert_raises(ArgumentError){bb.set_atoms(1)}
        assert_raises(ArgumentError){bb.set_atoms(2)}
        assert_raises(ArgumentError){bb.set_atoms(7)}
        assert_raises(ArgumentError){bb.set_atoms(8)}
        assert_raises(ArgumentError){bb.set_atoms(9)}
        assert_raises(ArgumentError){bb.set_atoms(10)}
        assert_raises(ArgumentError){bb.set_atoms(15)}
        assert_raises(ArgumentError){bb.set_atoms(16)}
        assert_raises(ArgumentError){bb.set_atoms(17)}
        assert_raises(ArgumentError){bb.set_atoms(18)}
        assert_raises(ArgumentError){bb.set_atoms(23)}
        assert_raises(ArgumentError){bb.set_atoms(24)}
        assert_raises(ArgumentError){bb.set_atoms(25)}
        assert_raises(ArgumentError){bb.set_atoms(26)}
        assert_raises(ArgumentError){bb.set_atoms(31)}
        assert_raises(ArgumentError){bb.set_atoms(32)}

        bb.set_atoms(33)
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 33)
        bb.set_atoms(33)
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 33)
        bb.set_atoms(33,33,33)
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 33)
        assert_raises(ArgumentError){bb.set_atoms(32,33)}
        assert_equal(1, bb.num_atoms)
        assert_includes(bb.atoms, 33)
        refute_includes(bb.atoms, 32)
        assert_raises(ArgumentError){bb.set_atoms(97)}
        assert_raises(ArgumentError){bb.set_atoms(100)}
        bb.set_atoms(35,45,85)
        assert_equal(3, bb.num_atoms)
        refute_includes(bb.atoms, 33)
        assert_includes(bb.atoms, 35)
        assert_includes(bb.atoms, 45)
        assert_includes(bb.atoms, 85)
    end

    def test_any_atom_between
        bb = Blackbox.new(8,3)
        assert_raises(ArgumentError) {bb.any_atom_between?(1,9)} 
        assert_raises(ArgumentError) {bb.any_atom_between?(1,2)} 
    end

    def test_hit_check
        bb = Blackbox.new(1,0)
        assert_raises(ArgumentError){bb.hit?(-1)}
        assert_raises(ArgumentError){bb.hit?(0)}

        refute(bb.hit?(1))
        refute(bb.hit?(2))
        refute(bb.hit?(3))
        refute(bb.hit?(4))

        assert_raises(ArgumentError){bb.hit?(5)}
        assert_raises(ArgumentError){bb.hit?(10)}
    end

    def test_check_pass_through_1_1
        bb = Blackbox.new(1,1)
        refute(bb.pass_through?(1))
        refute(bb.pass_through?(2))
        refute(bb.pass_through?(3))
        refute(bb.pass_through?(4))
    end

    def test_probe_1_1
        # dim = 1, atoms = 1
        bb = Blackbox.new(1,1)

        assert_equal(:hit, bb.probe(1));
        assert_equal(:hit, bb.probe(2));
        assert_equal(:hit, bb.probe(3));
        assert_equal(:hit, bb.probe(4));        
    end

    def test_probe_2_1
        bb = Blackbox.new(2,0)
        bb.set_atoms(9)
        assert_equal(:hit, bb.probe(1));
        assert_equal(:reflection, bb.probe(2));
        assert_equal(:hit, bb.probe(3));
        assert_equal(5, bb.probe(4));
        assert_equal(4, bb.probe(5));
        assert_equal(:hit, bb.probe(6));
        assert_equal(:reflection, bb.probe(7));
        assert_equal(:hit, bb.probe(8));
    end

    def test_wiki_scenario_1_hit
        # https://en.wikipedia.org/wiki/File:BlackBoxSample2.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)
        assert_equal(:hit, bb.probe(14))
    end

    def test_wiki_scenario_2_deflection
        # https://en.wikipedia.org/wiki/File:BlackBoxSample3.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)
        assert_equal(5, bb.probe(13))
    end

    def test_wiki_scenario_3_edge_reflection_hit
        # https://en.wikipedia.org/wiki/File:BlackBoxSample4.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)
        assert_equal(:reflection, bb.probe(17))
        assert_equal(:hit, bb.probe(18))
        assert_equal(:reflection, bb.probe(19))
    end

    def test_wiki_scenario_4_double_deflection_reflection
        # https://en.wikipedia.org/wiki/File:BlackBoxSample5.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(76, 78)
        assert_equal(:reflection, bb.probe(5))
    end

    def test_wiki_scenario_5_miss
        # https://en.wikipedia.org/wiki/File:BlackBoxSample6.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)
        assert_equal(32, bb.probe(9))
    end

    def test_wiki_scenario_6_detour
        # https://en.wikipedia.org/wiki/File:BlackBoxSample7.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)
        assert_equal(3, bb.probe(6))
        assert_equal(6, bb.probe(3))
        assert_equal(12, bb.probe(15))
        assert_equal(15, bb.probe(12))
    end

    def test_wiki_scenario_7_twisted_detour
        # https://en.wikipedia.org/wiki/File:BlackBoxSample8.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)
        assert_equal(28, bb.probe(20))
    end

    def test_wiki_scenario_8_simple_equivalent_of_last_scenario
        # https://en.wikipedia.org/wiki/File:BlackBoxSample9.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(62)
        assert_equal(28, bb.probe(20))
    end

    def test_wiki_scenario_9_complex_reflection
        # https://en.wikipedia.org/wiki/File:BlackBoxSample10.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(46, 86, 88)
        assert_equal(:reflection, bb.probe(11))
    end    

    def test_wiki_scenario_10_complex_hit
        # https://en.wikipedia.org/wiki/File:BlackBoxSample11.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(46, 51, 86)
        assert_equal(:hit, bb.probe(27))
    end    

    def test_wiki_scenario_11_full_probe
        # https://en.wikipedia.org/wiki/File:BlackBoxSample12.svg
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)

        assert_equal(31, bb.probe(1))
        assert_equal(:hit, bb.probe(2))
        assert_equal(6, bb.probe(3))
        assert_equal(:hit, bb.probe(4))
        assert_equal(13, bb.probe(5))
        assert_equal(3, bb.probe(6))
        assert_equal(:hit, bb.probe(7))
        assert_equal(10, bb.probe(8))
        assert_equal(32, bb.probe(9))
        assert_equal(8, bb.probe(10))
        assert_equal(:hit, bb.probe(11))
        assert_equal(15, bb.probe(12))
        assert_equal(5, bb.probe(13))
        assert_equal(:hit, bb.probe(14))
        assert_equal(12, bb.probe(15))
        assert_equal(:hit, bb.probe(16))
        assert_equal(:reflection, bb.probe(17))
        assert_equal(:hit, bb.probe(18))
        assert_equal(:reflection, bb.probe(19))
        assert_equal(28, bb.probe(20))
        assert_equal(:hit, bb.probe(21))
        assert_equal(26, bb.probe(22))
        assert_equal(:hit, bb.probe(23))
        assert_equal(29, bb.probe(24))
        assert_equal(:hit, bb.probe(25))
        assert_equal(22, bb.probe(26))
        assert_equal(:hit, bb.probe(27))
        assert_equal(20, bb.probe(28))
        assert_equal(24, bb.probe(29))
        assert_equal(:hit, bb.probe(30))
        assert_equal(1, bb.probe(31))
        assert_equal(9, bb.probe(32))
    end

    def test_get_square_string_plain_squares
        bb = Blackbox.new(1,0)
        assert_equal("1", bb.get_square_string(1))
        assert_equal("2", bb.get_square_string(2))
        assert_equal("3", bb.get_square_string(3))
        assert_equal("4", bb.get_square_string(4))
        assert_equal("5", bb.get_square_string(5))
    end

    def test_get_square_string_with_guesses
        bb = Blackbox.new(8,3)
        assert_equal("4", bb.get_square_string(4))
        assert_equal("34", bb.get_square_string(34))
        assert_equal("33", bb.get_square_string(33))
        bb.toggle_guess(33)
        assert_equal("33G", bb.get_square_string(33))
        bb.toggle_guess(33)
        assert_equal("33", bb.get_square_string(33))
    end

    def test_probes_save
        bb = Blackbox.new(8,3)
        assert_empty(bb.probes)
        bb.probe(1)
        assert_equal(1, bb.probes.length)
        bb.probe(2)
        assert_equal(2, bb.probes.length)
        bb.probe(1)
        assert_equal(2, bb.probes.length)
    end

    def test_probe_map
        bb = Blackbox.new(8,0)
        bb.set_atoms(50, 55, 76, 95)

        (1..bb.min_inner_square - 1).each do |square|
            assert_equal(bb.probe(square), bb.probe_map[square], "Mismatch for square #{square}")
        end    
    end
end
