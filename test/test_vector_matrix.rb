require_relative "../lib/deep_miner/vector_matrix"
require "test/unit"

class TestVectorMatrix < Test::Unit::TestCase
  def test_initialization_random
    v = DeepMiner::VectorMatrix.new(2, 3, 4.0)
    assert_equal(v.n, 2)
    assert_equal(v.m, 3)
    0.upto(v.n - 1) do |i|
      0.upto(v.m - 1) do |j|
        assert_true(v.get_value(i, j) <= 4.0)
        assert_true(v.get_value(i, j) >= -4.0)
      end
    end
  end

  def test_initialization_non_random
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_equal(v.n, 2)
    assert_equal(v.m, 2)
    assert_equal(v.get_value(0, 0), 1)
    assert_equal(v.get_value(1, 1), 3)
    assert_equal(v.get_value(0, 1), 2)
  end

  def test_objectify_raise_nil
    assert_raise(ArgumentError.new('Input must be Array')) {DeepMiner::VectorMatrix.objectify(nil)}
  end

  def test_objectify_raise_not_array
    assert_raise(ArgumentError.new('Input must be Array')) {DeepMiner::VectorMatrix.objectify(4)}
  end

  def test_objectify
    v = DeepMiner::VectorMatrix.objectify([[1,2],[2,3]])
    assert_equal(v.n, 2)
    assert_equal(v.m, 2)
    assert_equal(v.get_value(0, 0), 1)
    assert_equal(v.get_value(1, 1), 3)
    assert_equal(v.get_value(0, 1), 2)
  end

  def test_apply_new_matrix_nil
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Input must be Array')) {v.apply_new_matrix(nil)}
  end

  def test_apply_new_matrix_not_array
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Input must be Array')) {v.apply_new_matrix(5)}
  end

  def test_apply_new_matrix
    v = DeepMiner::VectorMatrix.new(5, 7, 5.0)
    v.apply_new_matrix([[1,2],[2,3]])
    assert_equal(v.n, 2)
    assert_equal(v.m, 2)
    assert_equal(v.get_value(0, 0), 1)
    assert_equal(v.get_value(1, 1), 3)
    assert_equal(v.get_value(0, 1), 2)
    assert_equal(v.random, nil)
  end

  def test_to_array
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    v.apply_new_matrix([[1,2],[2,3]])
    assert_equal(v.n, 2)
    assert_equal(v.m, 2)
    assert_equal(v.get_value(0, 0), v.to_array[0][0])
    assert_equal(v.get_value(0, 1), v.to_array[0][1])
    assert_equal(v.get_value(1, 0), v.to_array[1][0])
    assert_equal(v.get_value(1, 1), v.to_array[1][1])
  end

  def test_set_value_nil
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new("Values cannot be nil")) {v.set_value(nil, nil, nil)}
  end

  def test_set_value_not_within_bounds
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.set_value(17, 2, 5)}
  end

  def test_set_value_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.set_value(0, 5, 5)}
  end

  def test_set_value_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.set_value(-1, 5, 5)}
  end

  def test_add_value_nil
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new("Values cannot be nil")) {v.add_value(nil, nil, nil)}
  end

  def test_add_value_not_within_bounds
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.add_value(17, 2, 5)}
  end

  def test_add_value_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.add_value(0, 5, 5)}
  end

  def test_add_value_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.add_value(-1, 5, 5)}
  end

  def test_add_value
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    v.add_value(0, 0, 5)
    v.add_value(0, 1, 5)
    v.add_value(1, 0, 10)
    v.add_value(1, 1, 2)

    assert_equal(v.get_value(0, 0), 6)
    assert_equal(v.get_value(0, 1), 7)
    assert_equal(v.get_value(1, 0), 12)
    assert_equal(v.get_value(1, 1), 5)
  end

  def test_get_value_not_within_bounds
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.get_value(17, 2)}
  end

  def test_get_value_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.get_value(0, 5)}
  end

  def test_get_value_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Indices must be in matrix bounds')) {v.get_value(-1, 5)}
  end

  def test_get_value
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_equal(v.get_value(0, 0), 1)
    assert_equal(v.get_value(0, 1), 2)
    assert_equal(v.get_value(1, 1), 3)
    assert_equal(v.get_value(1, 0), 2)
  end

  def test_get_row_not_within_bounds
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Index must be in matrix bounds')) {v.get_row(-1)}
  end

  def test_get_row_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Index must be in matrix bounds')) {v.get_row(15)}
  end

  def test_get_row
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_equal(v.get_row(0)[0], 1)
    assert_equal(v.get_row(0)[1], 2)
  end

  def test_get_column_not_within_bounds
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Index must be in matrix bounds')) {v.get_column(-1)}
  end

  def test_get_column_not_within_bounds_two
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_raise(ArgumentError.new('Index must be in matrix bounds')) {v.get_column(15)}
  end

  def test_get_column
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_equal(v.get_column(1)[0], 2)
    assert_equal(v.get_column(1)[1], 3)
  end

  def test_get_row_objectify
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    v2 = v.get_row(0, true)
    assert_equal(v2.get_value(0, 0), 1)
    assert_equal(v2.get_value(0, 1), 2)
  end

  def test_get_column_objectify
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    v2 = v.get_column(1, true)
    assert_equal(v2.get_value(0, 0), 2)
    assert_equal(v2.get_value(0, 1), 3)
  end

  def test_get_diagonal_objectify
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    v2 = v.get_diagonal(true)
    assert_equal(v2.get_value(0, 0), 1)
    assert_equal(v2.get_value(0, 1), 3)  
  end

  def test_get_diagonal
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_equal(v.get_diagonal[0], 1)
    assert_equal(v.get_diagonal[1], 3)
  end

  def test_vector_sizes_empty_two
    v = DeepMiner::VectorMatrix.new(0, 0, 6.0)
    assert_equal(v.see_i_vector_size, 0)
    assert_equal(v.see_j_vector_size, 0)
  end

  def test_vector_sizes_random
    v = DeepMiner::VectorMatrix.new(15, 30, 6.0)
    assert_equal(v.see_i_vector_size, 15)
    assert_equal(v.see_j_vector_size, 30)
  end

  def test_vector_sizes_not_random
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1,2],[2,3]])
    assert_equal(v.see_i_vector_size, 2)
    assert_equal(v.see_j_vector_size, 2)
  end

  def test_identity_zero_size
    assert_raise(ArgumentError.new("N must have a size greater than 0")) {v = DeepMiner::VectorMatrix.identity(0)}
  end

  def test_identity_negative_size
    assert_raise(ArgumentError.new("N must have a size greater than 0")) {v = DeepMiner::VectorMatrix.identity(-1)}
  end

  def test_identity_size_one
    v = DeepMiner::VectorMatrix.identity(1)
    assert_equal(v[0][0], 1)
  end

  def test_identity_large_size
    v = DeepMiner::VectorMatrix.identity(15)

    0.upto(14) do |i|
      0.upto(14) do |j|
        assert_equal(v[i][j], 1) if i == j
        assert_equal(v[i][j], 0) if i != j
      end
    end
  end

  def test_trace_size_one
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1]])
    assert_equal(v.trace, 1)
  end
  
  def test_trace_large
    v = DeepMiner::VectorMatrix.identity(15, true)
    assert_equal(v.trace, 15)
  end

  def test_transpose_size_one
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1]])
    assert_equal(v.transpose[0][0], 1)
  end
  
  def test_transpose_large
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1, 2], [3,4], [5,6]])
    puts v.transpose
    assert_equal(v.transpose[0][0], 1)
    assert_equal(v.transpose[0][1], 3)
    assert_equal(v.transpose[0][2], 5)

    assert_equal(v.transpose[1][0], 2)
    assert_equal(v.transpose[1][1], 4)
    assert_equal(v.transpose[1][2], 6)
  end

  def test_square_one_element
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1]])
    assert_true(v.square?)
  end

  def test_square_false
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3,4], [5,6]])
    assert_false(v.square?)
  end

  def test_square_true
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_true(v.square?)
  end

  def test_empty_one_element
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1]])
    assert_false(v.empty?)
  end

  def test_empty_all_nil
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[nil, nil], [nil, nil], [nil, nil]])
    assert_true(v.empty?)
  end

  def test_empty_full
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_false(v.empty?)
  end

  def test_diagonal_one_element
    v = DeepMiner::VectorMatrix.new(2, 3, nil, [[1]])
    assert_true(v.diagonal?)
  end

  def test_diagonal_regular
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_false(v.diagonal?)
  end

  def test_diagonal_zeros
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 0, 0], [0, 4, 0], [0, 0, 8]])
    assert_true(v.diagonal?)
  end

  #def test_diagonal_nils
  #  v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, nil, nil], [nil, 4, nil], [nil, nil, 8]])
  #  assert_true(v.diagonal?)
  #end

  #def test_diagonal_zeros_nils_combo
  #  v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, nil, 0], [0, 4, nil], [0, 0, 8]])
  #  assert_true(v.diagonal?)
  #end

  #def test_diagonal_random_nil_case
  #  v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[nil, 4, 2], [nil, 4, nil], [nil, nil, 8]])
  #  assert_false(v.diagonal?)
  #end

  def test_add_nil
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_raise(ArgumentError.new('Input matrix must be of type Array')) {v.add(nil, false)}
  end

  def test_add_non_array
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_raise(ArgumentError.new('Input matrix must be of type Array')) {v.add(5, false)}
  end

  def test_add_with_array
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    added = v.add([[1, 2], [3, 4]], false)

    assert_equal(added[0][0], 2)
    assert_equal(added[0][1], 4)
    assert_equal(added[1][0], 6)
    assert_equal(added[1][1], 8)
  end

  def test_add_with_array_objectified
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    added = v.add([[1, 2], [3, 4]], true)

    assert_equal(added.get_value(0, 0), 2)
    assert_equal(added.get_value(0, 1), 4)
    assert_equal(added.get_value(1, 0), 6)
    assert_equal(added.get_value(1, 1), 8)
  end

  def test_add_with_vertex_matrix
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    v2 = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    added = v.add(v2, false, false)

    assert_equal(added[0][0], 2)
    assert_equal(added[0][1], 4)
    assert_equal(added[1][0], 6)
    assert_equal(added[1][1], 8)
  end

  def test_add_with_vertex_matrix_objectified
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    v2 = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    added = v.add(v2, true, false)

    assert_equal(added.get_value(0, 0), 2)
    assert_equal(added.get_value(0, 1), 4)
    assert_equal(added.get_value(1, 0), 6)
    assert_equal(added.get_value(1, 1), 8)
  end

    def test_add_nil
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_raise(ArgumentError.new('Input matrix must be of type Array')) {v.subtract(nil, false)}
  end

  def test_add_non_array
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_raise(ArgumentError.new('Input matrix must be of type Array')) {v.subtract(5, false)}
  end

  def test_add_with_array
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    sub = v.subtract([[1, 2], [3, 4]], false)

    assert_equal(sub[0][0], 1)
    assert_equal(sub[0][1], 2)
    assert_equal(sub[1][0], 3)
    assert_equal(sub[1][1], 4)
  end

  def test_add_with_array_objectified
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    sub = v.subtract([[1, 2], [3, 4]], true)

    assert_equal(sub.get_value(0, 0), 1)
    assert_equal(sub.get_value(0, 1), 2)
    assert_equal(sub.get_value(1, 0), 3)
    assert_equal(sub.get_value(1, 1), 4)
  end

  def test_subtract_with_vertex_matrix
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    v2 = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    sub = v.subtract(v2, false, false)

    assert_equal(sub[0][0], 1)
    assert_equal(sub[0][1], 2)
    assert_equal(sub[1][0], 3)
    assert_equal(sub[1][1], 4)
  end

  def test_subtract_with_vertex_matrix_objectified
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    v2 = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2], [3, 4]])
    sub = v.subtract(v2, true, false)

    assert_equal(sub.get_value(0, 0), 1)
    assert_equal(sub.get_value(0, 1), 2)
    assert_equal(sub.get_value(1, 0), 3)
    assert_equal(sub.get_value(1, 1), 4)
  end

  def test_scale_objectify
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    scale = v.scale(2, true)

    assert_equal(scale.get_value(0, 0), 4)
    assert_equal(scale.get_value(0, 1), 8)
    assert_equal(scale.get_value(1, 0), 12)
    assert_equal(scale.get_value(1, 1), 16)
  end

  def test_scale_array
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    scale = v.scale(2)

    assert_equal(scale[0][0], 4)
    assert_equal(scale[0][1], 8)
    assert_equal(scale[1][0], 12)
    assert_equal(scale[1][1], 16)
  end

  def test_multiply_nil
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_raise(ArgumentError.new('Input matrix must be of type Array')) {v.multiply(nil, false)}
  end

  def test_multiply_non_array
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[1, 2, 4], [3, 4, 7], [5, 6, 8]])
    assert_raise(ArgumentError.new('Input matrix must be of type Array')) {v.multiply(5, false)}
  end

  def test_multiply_incorrect_structure
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[3, 4, 7], [5, 6, 8]])
    assert_raise(ArgumentError.new('Illegal matrix multiplication dimensions')) {v.multiply([[1, 2, 3, 4, 5]], false)}
  end

  def test_multiply_with_array
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    mul = v.multiply([[1, 2], [3, 4]], false)

    assert_equal(mul[0][0], 14)
    assert_equal(mul[0][1], 20)
    assert_equal(mul[1][0], 30)
    assert_equal(mul[1][1], 44)
  end

  def test_multiply_with_array_objectified
    v = DeepMiner::VectorMatrix.new(nil, nil, nil, [[2, 4], [6, 8]])
    mul = v.multiply([[1, 2], [3, 4]], true)

    assert_equal(mul.get_value(0, 0), 14)
    assert_equal(mul.get_value(0, 1), 20)
    assert_equal(mul.get_value(1, 0), 30)
    assert_equal(mul.get_value(1, 1), 44)
  end
end












