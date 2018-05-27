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