require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/blackbox.rb'


class TestBlackbox < Minitest::Test
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

    def test_bb_new_instance_grid_size_must_be_between_1_and_50_inclusive
        Blackbox.new 1, 1
        Blackbox.new 10, 1
        Blackbox.new 50, 1
        Blackbox.new 8,3

        assert_raises(ArgumentError) {Blackbox.new 51, 1}
        assert_raises(ArgumentError) {Blackbox.new 0, 0}
        assert_raises(ArgumentError) {Blackbox.new 51, 1}
    end
    
    def test_bb_num_atoms_must_be_between_0_and_grid_size_inclusive
        Blackbox.new 10,0
        Blackbox.new 10,10
        Blackbox.new 1, 0
        Blackbox.new 1, 1
        Blackbox.new 50, 0
        Blackbox.new 50, 10
        Blackbox.new 50, 50
        Blackbox.new 8,3

        assert_raises(ArgumentError) {Blackbox.new 10, -1}
        assert_raises(ArgumentError) {Blackbox.new 10, 11}
        assert_raises(ArgumentError) {Blackbox.new 1, -1}
        assert_raises(ArgumentError) {Blackbox.new 1, 2}
        assert_raises(ArgumentError) {Blackbox.new 50, 51}
        assert_raises(ArgumentError) {Blackbox.new 50, -1}
    end

end
