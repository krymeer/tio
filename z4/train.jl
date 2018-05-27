include("network.jl")

function readdata(filename::String, input::Array{Array{Float64,1},1}, output::Array{Array{Float64,1},1})
    try
        open(filename) do f
            for line in eachline(f)
                io = split(line, r"\s*\|\s*")

                try
                    push!(input, [parse(Int64, s) for s in split(io[1])])
                    push!(output, [parse(Int64, s) for s in split(io[2])])
                catch
                    println(STDERR, "\nError: invalid data format\n")
                    quit()
                end
            end
        end
    catch (e)
        println(STDERR, "\nError: $e")
        println(STDERR, "Error: file $filename not found\n")
        quit()
    end
end

function getnetwork(netlayers::Array{Array{Neuron,1}})
    try
        open("network.txt") do f
            println(STDERR, "\nInfo: loading network data")

            for line in eachline(f)
                if length(search(line, r"^\s*#")) > 0 || length(search(line, r"[^\s]+")) == 0
                    continue    
                end

                data = split(line, r"\s*\|\s*")

                if length(data) != 5
                    println(STDERR, "\nError: invalid data format\n")
                    quit()
                end

                layind  = parse(Int64, data[1])
                weights = [parse(Float64, w) for w in split(strip(data[2], ['[', ']']), r"\s*,\s*")]
                csum    = parse(Float64, data[3])
                nsum    = parse(Float64, data[4])
                delta   = parse(Float64, data[5])
                neuron  = Neuron(weights, csum, nsum, delta)

                if length(netlayers) < layind
                    push!(netlayers, [neuron])
                else
                    push!(netlayers[layind], neuron)
                end
            end

            println(STDERR, "Info: data loaded successfully")
        end
    catch (e)
        println(STDERR, "\nError: $e\nError: your file contains corrupted data")
    end
end


function writetofile(netlayers::Array{Array{Neuron,1}})
    try
        open("network.txt", "w") do f
            write(f, "# Neuron syntax:\n# layer index | [array of weights] | calculated sum | normalized sum | delta")
        
            for i = 1 : length(netlayers)
                write(f, "\n\n# Layer $i")
                layer = netlayers[i]

                for neuron in layer
                    write(f, "\n$i | $(neuron.weights) | $(neuron.csum) | $(neuron.nsum) | $(neuron.delta)")
                end
            end

            println(STDERR, "\nNetwork saved to file \"network.txt\"\n")
        end
    catch (e)
        println(STDERR, "\nError: $e\n")
        quit()
    end
end

function main(args::Array{String,1})
    if length(args) < 2
        println(STDERR, "\nUsage: train.jl n input \"layer1, layer2, layernjui\"\n")
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