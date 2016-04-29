module DeepMiner
  class Perceptron
    attr_reader :input, :hidden, :output
    attr_reader :weight_matrix_ih, :weight_matrix_ho
    attr_reader :output_delta_v, :hidden_delta_v
    attr_reader :change_matrix_i, :change_matrix_o

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
      fail ArgumentError, 'Input vector must be same size as input' unless input_vector.size == @input.size
      # Set activation vector for the input layer
      @act_input.apply_new_matrix([] << input_vector)

      # Calculate activation vector for the hidden layer
      for j in 0..@hidden - 1
        sum = 0.0
        for i in 0..input.size - 1
          sum += @act_input.get_value(0, j) * @weight_matrix_ih.get_value(j, i)
        end
        @act_hidden.set_value(0, j, tanh_sigmoid(sum))
      end

      # Calculate activation vector for the output layer
      for k in 0..@output.size - 1
        sum = 0.0
        for j in 0..@hidden - 1
          sum += @act_hidden.get_value(0, j) * @weight_matrix_ho.get_value(j, k)
        end
        @act_output.set_value(0, k, tanh_sigmoid(sum))
      end
      @act_output.to_array
    end


    def back_propogate(target, eta, momentum)
      fail ArgumentError, 'Target vector must be of type Array' unless target.is_a? Array
      fail ArgumentError, 'Target and Output must same size' unless target.size == @output.size

      # Calculate errors for output layer
      out_delta = Array.new(@output.size, 0.0)
      0.upto(@output.size - 1) do |k|
        act_val = @act_output.get_value(0, k)
        error = target[k] - act_val
        out_delta[k] = dx_tanh_sigmoid(act_val) * error
      end

      # Calculate errors for hidden layer
      hidden_delta = Array.new(@hidden, 0.0)
      0.upto(@hidden - 1) do |j|
        error = 0.0
        0.upto(@output.size - 1) do |k|
          error += out_delta[k] * @weight_matrix_ho.get_value(j, k)
        end
        hidden_delta[j] = dx_tanh_sigmoid(@act_hidden.get_value(0,j)) * error
      end

      # Update weight vector from hidden to outputs
      0.upto(@hidden - 1) do |j|
        0.upto(@output.size - 1) do |k|
          delta = out_delta[k] * @act_hidden.get_value(0, j)
          value = delta * eta + momentum * @change_matrix_o.get_value(j, k)
          @weight_matrix_ho.add_value(j, k, value)
          @change_matrix_o.set_value(j, k, delta)
        end
      end

      # Update weight vector from inputs to hidden
      0.upto(@input.size - 1) do |i|
        0.upto(@hidden - 1) do |j|
          delta = hidden_delta[j] * @act_input.get_value(0, i)
          value = delta * eta + momentum * @change_matrix_i.get_value(i, j)
          @weight_matrix_ih.add_value(i, j, value)
          @change_matrix_i.set_value(i, j, delta)
        end
      end

      # calculate error
      error = 0.0
      
      target.each do |tg|
        error += 0.5 * (tg - @act_output.get_value(0, k))**2
      end
      error
    end

    # Train the perceptron with training vector input and expectation vector input epoch number
    def train(train_data_vector, expectation_vector, epoch_iter = 50, eta, momentum)
      fail ArgumentError, 'Training must be Array' unless train_data_vector.is_a? Array
      fail ArgumentError, 'Expectation must be Array' unless expectation_vector.is_a? Array
      fail ArgumentError, 'Data and Expectation must be same size' unless train_data_vector.size == expectation_vector.size

      1.upto(epoch_iter) do
        error = 0.0
        train_data_vector.zip(expectation_vector) do |sample, target|
          predict(sample)
          error += back_propogate(target, eta, momentum)
        end
      end
    end

    private

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
      changei = Array.new(@input.size) { Array.new(@hidden, 0.0) }
      changeo = Array.new(@hidden) { Array.new(@output.size, 0.0) }
      @change_matrix_i = VectorMatrix.objectify(changei)
      @change_matrix_o = VectorMatrix.objectify(changeo)
    end

    # Computes the sigmoid function
    def tanh_sigmoid(x)
      Math.tanh(x)
    end

    # Computes the derivative of the sigmoid
    def dx_tanh_sigmoid(x)
      1 - x**2 + (2 * x**4) / 4
    end
  end
end
