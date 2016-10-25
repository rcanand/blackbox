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

    def test_grid_size_must_be_between_1_and_50_inclusive
        assert_raises(ArgumentError) {Blackbox.new -1, -1}
        assert_raises(ArgumentError) {Blackbox.new 0, -1}
        assert_raises(ArgumentError) {Blackbox.new 0, 0}
        assert_raises(ArgumentError) {Blackbox.new 51, 1}
        assert_raises(ArgumentError) {Blackbox.new 100, 1}
    end
    
    def test_bb_num_atoms_must_be_between_0_and_grid_size_inclusive
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


end
