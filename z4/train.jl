include("network.jl")
include("io.jl")

function main(args::Array{String,1})
    if length(args) < 2
        println(STDERR, "\nUsage: train.jl n input \"layer1, layer2, layern\"\n")
        quit()
    end

    try
        n = parse(Int64, args[1])
    catch (e)
        println(STDERR, "\nError: $e\n")
        quit()
    end

    if n < 1
        println(STDERR, "\nWarning: number $(args[1]) is not large enough. Number 1 will be used instead")
        n = 1
    end

    input   = Array{Float64,1}[]
    output  = Array{Float64,1}[]
    readdata(args[2], input, output)

    netlayers = Array{Neuron,1}[]
    getnetwork(netlayers)

    if length(netlayers) == 0
        println(STDERR, "Notice: network does not exist. It will be build from scratch")
        laysizes = []
        
        if length(args) >= 3
            try
                laysizes = [parse(Int64, l) for l in split(args[3], r"\s*,\s*")]
            catch (e)
                println(STDERR, "\nError: $e\n")
            end
        end

        if length(laysizes) == 0
            laysizes = [2, 3, 1]
        end

        init(netlayers, laysizes, length(input[1]))
    end

    d = div(n, 10) + 1
    println()

    for k = 1 : n
        if k % d == 0
            println(STDERR, "Info: training progress: $(round(k/n * 100))%")
        end

        for l = 1 : length(input)
            forwardprop(netlayers, input[l])
            backwardprop(netlayers, input[l], output[l])
        end
    end

    writetofile(netlayers)
end

main(ARGS)