using Calculus

type Neuron
    weights::Array{Float64,1}
    csum::Float64
    nsum::Float64
    delta::Float64
end

function init(netlayers::Array{Array{Neuron,1}}, laysizes::Array{Int64,1}, inputlen::Int64)
    for i = 1 : length(laysizes)
        layer   = Neuron[]
        wnum    = inputlen

        if i > 1
            wnum = laysizes[i-1]
        end

        for j = 1 : laysizes[i]
            neuron = Neuron([], 0.0, 0.0, 0.0)

            for k = 1 : wnum
                push!(neuron.weights, rand())
            end

            push!(layer, neuron)
        end

        push!(netlayers, layer)
    end

    return netlayers
end

function sigmoid(x::Float64)
    return 1/(1+e^(-x))
end

function forwardprop(netlayers::Array{Array{Neuron,1}}, input::Array{Float64,1})
    sigin = input

    for layer in netlayers
        signew = Float64[]

        for neuron in layer
            neuron.csum     = 0
            neuron.nsum     = 0
            neuron.delta    = 0

            for k = 1 : length(neuron.weights)
                neuron.csum += sigin[k] * neuron.weights[k]
            end

            neuron.nsum = sigmoid(neuron.csum)
            push!(signew, neuron.nsum)
        end

        sigin = signew
    end
end

function backwardprop(netlayers::Array{Array{Neuron,1}}, input::Array{Float64,1}, output::Array{Float64,1})
    eta = 0.55

    for i = length(netlayers) : -1 : 1
        layer = netlayers[i]

        for j = 1 : length(layer)
            neuron  = layer[j]
            epsilon = 0

            if i == length(netlayers)
                epsilon = output[j] - neuron.nsum
            else
                uplayer = netlayers[i+1]

                for k = 1 : length(uplayer)
                    epsilon += uplayer[k].delta * uplayer[k].weights[j]
                end
            end

            neuron.delta = epsilon * derivative(sigmoid, neuron.csum)

            for l = 1 : length(neuron.weights)
                add = 2 * eta * neuron.delta

                if i > 1
                    add *= netlayers[i-1][l].nsum
                else
                    add *= input[l] 
                end

                neuron.weights[l] += add;
            end
        end
    end
end