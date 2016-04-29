module DeepMiner
  # ajcost
  #
  # Perceptron is class that implements a single layer neural net
  # Implemenation is made with vertex_matrix class
  class Perceptron
    attr_reader :input, :hidden, :output
    attr_reader :weight_matrix_ih, :weight_matrix_ho
    attr_reader :output_delta_v, :hidden_delta_v
    attr_reader :change_matrix_i, :change_matrix_o
    attr_reader :out_delta, :hidden_delta

    def initialize(input, hidden, output)
      fail ArgumentError, 'Input must be Array' unless input.is_a? Array
      fail ArgumentError, 'Output must be Array' unless output.is_a? Array
      @input = input
      @hidden = hidden
      @output = output
      # Create activation vectors and weight matrices and change matrices
      init_activations
      init_weight_matrices
      init_change_matrices
    end

    def predict(input_vector)
      fail ArgumentError, 'Input vector must be Array' unless input_vector.is_a? Array
      fail ArgumentError, 'Predict input must be same size as input' unless input_vector.size == @input.size
      # Set activation vector for the input layer
      @act_input.apply_new_matrix([] << input_vector)

      # Calculate activation vector for the hidden layer
      calculate_activation_hidden

      # Calculate activation vector for the output layer
      calculate_activation_output
    end

    def back_propogate(target, eta, momentum)
      fail ArgumentError, 'Target must be Array' unless target.is_a? Array
      fail ArgumentError, 'Target and Output must have same size' unless target.size == @output.size
      # Calculate errors for output layer
      errors_output(target)

      # Calculate errors for hidden layer
      errors_hidden

      # Update weight vector from hidden to outputs
      update_output_weight_vector(eta, momentum)

      # Update weight vector from inputs to hidden
      update_hidden_weight_vector(eta, momentum)

      calculate_error(target)
    end

    # Train the network with training input, expectations, input, and epoch num
    def train(train_data, expect, epoch_iter = 50, eta, m)
      fail ArgumentError, 'Training must be Array' unless train_data.is_a? Array
      fail ArgumentError, 'Expectation must be Array' unless expect.is_a? Array
      fail ArgumentError, 'Data and Expectation must be same size' unless train_data.size == expect.size

      1.upto(epoch_iter) do
        error = 0.0
        train_data.zip(expect) do |sample, target|
          predict(sample)
          error += back_propogate(target, eta, m)
        end
      end
    end

    private

    def calculate_activation_hidden
      for j in 0..@hidden - 1
        sum = 0.0
        for i in 0..input.size - 1
          sum += @act_input.get_value(0, j) * @weight_matrix_ih.get_value(j, i)
        end
        @act_hidden.set_value(0, j, tanh_sigmoid(sum))
      end
    end

    def calculate_activation_output
      for k in 0..@output.size - 1
        sum = 0.0
        for j in 0..@hidden - 1
          sum += @act_hidden.get_value(0, j) * @weight_matrix_ho.get_value(j, k)
        end
        @act_output.set_value(0, k, tanh_sigmoid(sum))
      end
      @act_output.to_array
    end

    def calculate_error(target)
      error = 0.0
      0.upto(target.size - 1) do |k|
        error += 0.5 * (target[k] - @act_output.get_value(0, k))**2
      end
      error
    end

    def errors_output(target)
      @out_delta = Array.new(@output.size, 0.0)
      0.upto(@output.size - 1) do |k|
        act_val = @act_output.get_value(0, k)
        error = target[k] - act_val
        @out_delta[k] = dx_tanh_sigmoid(act_val) * error
      end
    end

    def errors_hidden
      @hidden_delta = Array.new(@hidden, 0.0)
      0.upto(@hidden - 1) do |i|
        error = 0.0
        0.upto(@output.size - 1) do |j|
          error += @out_delta[j] * @weight_matrix_ho.get_value(i, j)
        end
        @hidden_delta[i] = dx_tanh_sigmoid(@act_hidden.get_value(0, i)) * error
      end
    end

    def update_output_weight_vector(eta, momentum)
      0.upto(@hidden - 1) do |j|
        0.upto(@output.size - 1) do |k|
          delta = @out_delta[k] * @act_hidden.get_value(0, j)
          value = delta * eta + momentum * @change_matrix_o.get_value(j, k)
          @weight_matrix_ho.add_value(j, k, value)
          @change_matrix_o.set_value(j, k, delta)
        end
      end
    end

    def update_hidden_weight_vector(eta, momentum)
      0.upto(@input.size - 1) do |i|
        0.upto(@hidden - 1) do |j|
          delta = hidden_delta[j] * @act_input.get_value(0, i)
          value = delta * eta + momentum * @change_matrix_i.get_value(i, j)
          @weight_matrix_ih.add_value(i, j, value)
          @change_matrix_i.set_value(i, j, delta)
        end
      end
    end

    def init_activations
      ins = [1.0] * @input.size
      hids = [1.0] * @hidden.size
      outs = [1.0] * @output.size
      @act_input = VectorMatrix.new(nil, nil, nil, [] << ins)
      @act_hidden = VectorMatrix.new(nil, nil, nil, [] << hids)
      @act_output = VectorMatrix.new(nil, nil, nil, [] << outs)
    end

    def init_weight_matrices
      @weight_matrix_ih = VectorMatrix.new(input.size, hidden, 0.1)
      @weight_matrix_ho = VectorMatrix.new(hidden, output.size, 1.0)
    end

    def init_change_matrices
      changei = Array.new(@input.size) { Array.new(@hidden, rand(-0.2..0.2)) }
      changeo = Array.new(@hidden) { Array.new(@output.size, rand(-0.2..0.2)) }
      @change_matrix_i = VectorMatrix.objectify(changei)
      @change_matrix_o = VectorMatrix.objectify(changeo)
    end

    # Computes the sigmoid function
    def tanh_sigmoid(x)
      Math.tanh(x)
    end

    # Computes the derivative of the sigmoid
    def dx_tanh_sigmoid(x)
      1.0 - x**2
    end
  end
end
