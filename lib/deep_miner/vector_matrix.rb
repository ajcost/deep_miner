module DeepMiner
  class VectorMatrix
    attr_reader :matrix, :n, :m, :random

    def initialize(n, m, random, matrix = nil)
      if matrix.nil?
        @n = n
        @m = m
        @random = random
        initialize_h
      else
        simple_init(matrix)
      end
    end

    # General Operations

    def self.objectify(new_matrix)
      fail ArgumentError, 'Input must be Array' unless new_matrix.is_a? Array
      VectorMatrix.new(nil, nil, nil, new_matrix)
    end

    def apply_value(x)
      @matrix = Array.new(@n) { Array.new(@m, x) }
    end

    def apply_new_matrix(x)
      fail ArgumentError, 'Input must be Array' unless x.is_a? Array
      @matrix = x
      @n = @matrix.size
      @m = @matrix[0].size
      @random = nil
    end

    def to_array
      @matrix
    end

    def set_value(i, j, x)
      fail ArgumentError, 'Values cannot be nil' if i.nil? || j.nil? || x.nil?
      fail ArgumentError, 'Indices must be in matrix bounds' if i < 0 || j < 0 || i > @n || j > @m
      @matrix[i][j] = x
    end

    def add_value(i, j, x)
      fail ArgumentError, 'Values cannot be nil' if i.nil? || j.nil? || x.nil?
      fail ArgumentError, 'Indices must be in matrix bounds' if i < 0 || j < 0 || i > @n || j > @m
      @matrix[i][j] += x
    end

    def get_value(i, j)
      fail ArgumentError, 'Indices must be in matrix bounds' if i < 0 || j < 0 || i > @n || j > @m
      @matrix[i][j]
    end

    def get_row(index, objectify = false)
      fail ArgumentError, 'Index must be in matrix bounds' if index < 0 || index > @n - 1
      return VectorMatrix.new(nil, nil, nil, [] << @matrix[index]) if objectify
      @matrix[index]
    end

    def get_column(index, objectify = false)
      fail ArgumentError, 'Index must be in matrix bounds' if index < 0 || index > @m - 1
      column = []
      0.upto(@n - 1) do |i|
        column << @matrix[i][index]
      end
      return VectorMatrix.new(nil, nil, nil, [] << column) if objectify
      column
    end

    def get_diagonal(objectify = false)
      diagonal = []
      0.upto(@n - 1) do |i|
        0.upto(@m - 1) do |j|
          diagonal << @matrix[i][j] if i == j
        end
      end
      return VectorMatrix.new(nil, nil, nil, [] << diagonal) if objectify
      diagonal
    end

    def see_i_vector_size
      @matrix.size
    end

    def see_j_vector_size
      return 0 if self.see_i_vector_size == 0
      @matrix[0].size
    end

    # Matrix Specific Operations

    def self.identity(n, objectify = false)
      fail ArgumentError, 'N must have a size greater than 0' if n <= 0
      new_matrix = Array.new(n) { Array.new(n) }
      0.upto(n - 1) do |i|
        0.upto(n - 1) do |j|
          if i == j
            new_matrix[i][j] = 1
          else
            new_matrix[i][j] = 0
          end
        end
      end
      return VectorMatrix.new(n, n, nil, new_matrix) if objectify
      new_matrix
    end

    def trace
      diagonal = get_diagonal(false)
      sum = 0.0
      0.upto(diagonal.size - 1) do |i|
        sum += diagonal[i]
      end
      sum
    end

    def transpose(objectify = false)
      transposed = []
      0.upto(@m - 1) do |i|
        transposed << get_column(i)
      end
      return VectorMatrix.new(nil, nil, nil, transposed) if objectify
      transposed
    end

    # Matrix Mathematical Operations

    # Scalar Product
    def scale(scale_val, objectify = false)
      scaled = Array.new(@n) { Array.new(@m) }
      0.upto(@n - 1) do |i|
        0.upto(@m - 1) do |j|
          scaled[i][j] = scale_val * @matrix[i][j]
        end
      end
      return VectorMatrix.new(nil, nil, nil, scaled) if objectify
      scaled
    end


    # Add
    def add(o_matrix, objectify, not_objectified = true)
      fail ArgumentError, 'Input matrix must be of type Array' if not_objectified and !o_matrix.is_a? Array
      o_matrix = VectorMatrix.objectify(o_matrix) if not_objectified
      added = Array.new(@n) { Array.new(@m) }
      0.upto(@n - 1) do |i|
        0.upto(@m - 1) do |j|
          added[i][j] = @matrix[i][j] + o_matrix.get_value(i, j)
        end
      end
      return VectorMatrix.new(nil, nil, nil, added) if objectify
      added
    end

    # Subtract
    def subtract(o_matrix, objectify, not_objectified = true)
      fail ArgumentError, 'Input matrix must be of type Array' if not_objectified and !o_matrix.is_a? Array
      o_matrix = VectorMatrix.objectify(o_matrix) if not_objectified
      subtracted = Array.new(@n) { Array.new(@m) }
      0.upto(@n - 1) do |i|
        0.upto(@m - 1) do |j|
          subtracted[i][j] = @matrix[i][j] - o_matrix.get_value(i, j)
        end
      end
      return VectorMatrix.new(nil, nil, nil, subtracted) if objectify
      subtracted
    end

    # Multiply
    def multiply(o_matrix, objectify, not_objectified = true)
      fail ArgumentError, 'Input matrix must be of type Array' if not_objectified and !o_matrix.is_a? Array
      o_matrix = VectorMatrix.objectify(o_matrix) if not_objectified
      fail ArgumentError, 'Illegal matrix multiplication dimensions' if @m != o_matrix.see_j_vector_size
      multiplied = multiply_h(o_matrix)
      return VectorMatrix.new(nil, nil, nil, multiplied) if objectify
      multiplied
    end

    # Matrix Qualities

    def diagonal?
      0.upto(@n - 1) do |i|
        0.upto(@m - 1) do |j|
          return false if (@matrix[i][j].nil? || @matrix[i][j] != 0.0) && i != j
        end
      end
      true
    end

    def empty?
      return true if @matrix.size == 0
      0.upto(@n - 1) do |i|
        0.upto(@m - 1) do |j|
          return false unless @matrix[i][j].nil?
        end
      end
      true
    end

    def square?
      @n == @m
    end

    private

    def initialize_h
      @matrix = Array.new(@n) { Array.new(@m) }
      for i in 0..@n - 1
        for j in 0..@m - 1
          if !@random.nil?
            @matrix[i][j] = 1.0 * rand(-@random...@random)
          else
            @matrix[i][j] = 1.0
          end
        end
      end
    end

    def simple_init(matrix)
      @n = matrix.size
      @m = matrix[0].size
      @matrix = matrix
      @random = nil
    end

    def multiply_h(o_matrix)
      multiplied = Array.new(@n) { Array.new(@m, 0.0) }
      0.upto(@n - 1) do |i|
        0.upto(o_matrix.see_j_vector_size - 1) do |j|
          0.upto(@m - 1) do |k|
            multiplied[i][j] += @matrix[i][k] * o_matrix.get_value(k, j)
          end
        end
      end
      multiplied
    end
  end
end
