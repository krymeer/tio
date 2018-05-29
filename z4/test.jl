include("network.jl")
include("io.jl")

function main(args::Array{String,1})
    if length(args) != 2
        println(STDERR, "\nUsage: test.jl input network\n")
        quit()
    end

    input       = Array{Float64,1}[]
    output      = Array{Float64,1}[]
    readdata(args[1], input, output)
    netlayers   = Array{Neuron,1}[]
    getnetwork(netlayers, args[2])

    if length(netlayers) == 0
        println(STDERR, "Error: network does not exist. Build it with the \"train.jl\" program")
        quit()
    end

    for l = 1 : length(input)
        forwardprop(netlayers, input[l])
        println(STDERR, "\nInput: $(input[l])")

        if length(output) > 0
            println(STDERR, "Output: $(output[l])")
        end

        print("Calculated: ")

        for neuron in netlayers[length(netlayers)]
            print("$(neuron.nsum) ")
        end

        println()
    end

    println()
end

main(ARGS)