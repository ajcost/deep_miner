require_relative "../lib/deep_miner/perceptron"
require_relative "../lib/deep_miner/vector_matrix"
require "test/unit"

class TestPerceptron < Test::Unit::TestCase
  
  def intialization_test_invalid_input
    assert_raise(ArgumentError.new('Input must be Array')) { DeepMiner::Perceptron.new(2, 3, [3, 4]) }
  end

  def intialization_test_invalid_output
    assert_raise(ArgumentError.new('Output must be Array')) { DeepMiner::Perceptron.new([2, 3], 3, 3) }
  end

  def intialization_test
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
  end

  def intialization_test_invalid_input
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Input must be Array')) { DeepMiner::Perceptron.new(2, 3, [3, 4]) }
  end

  def back_propogate_test_invalid_output
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Target vector must be of type Array')) { p.back_propogate(4, 3, 2) }
  end

  def back_propogate_test_invalid_target_array_input
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Target and Output must same size')) { p.back_propogate([4, 3, 2] , 3, 2) }
  end

  def predict_test_invalid_output
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Input vector must be Array')) { p.predict(4) }
  end

  def predict_test_invalid_target_array_input
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Input vector must be same size as input')) { p.predict([1, 2, 3, 4]) }
  end

  def train_test_invalid_training
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Training must be Array')) { p.train(3, [3, 2], 2000, 0.5, 0.1) }
  end

  def train_test_invalid_expectation
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Expectation must be Array')) { p.train([3, 2], 3, 2000, 0.5, 0.1) }
  end

  def train_test_invalid_expectation_training_lengths
    p = DeepMiner::Perceptron.new([2, 3], 3, [3, 4])
    assert_raise(ArgumentError.new('Data and Expectation must be same size')) { p.train([3, 2], [3, 4, 5], 2000, 0.5, 0.1) }
  end

  def perceptron_learning_or
    p = DeepMiner::Perceptron.new(['bit1', 'bit2'], 2, ['out'])
    data = [[0,0], [0, 1], [1,0], [1,1]]
    target = [[0], [1], [1], [0]]
    p.train(data, target, 2000, 0.5, 0.1)

    assert_true(p.predict([0, 0]) < 0.1)
    assert_true(p.predict([0, 1]) > 0.85)
    assert_true(p.predict([1, 0]) > 0.85)
    assert_true(p.predict([1, 0]) > 0.85)
  end
end
