#!/usr/bin/env ruby -wU
class Blackbox
    def initialize grid_size, num_atoms
        raise ArgumentError.new("grid_size and num_atoms must be integers") unless grid_size.instance_of?(Fixnum) && num_atoms.instance_of?(Fixnum)
        raise ArgumentError.new("grid_size must be between 2 and 50 inclusive") unless grid_size > 0 && grid_size < 51
        raise ArgumentError.new("num_atoms must be between 0 and grid_size inclusive") unless num_atoms >= 0 && num_atoms <= grid_size
    end
end