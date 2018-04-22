include("startup.jl")
include("knapsack.jl")
include("solutions.jl")
include("bpso.jl")
include("appendix.jl")
include("output.jl")

# Funkcja startowa programu
function main()
    dataerr = false

    if length(ARGS) != 4
        println(STDERR, errormsg)
    else
        c1 = 0.0
        c2 = 0.0
        c3 = 0.0

        try
            c1 = parse(Float64, ARGS[2])
            c2 = parse(Float64, ARGS[3])
            c3 = parse(Float64, ARGS[4])
        catch
            println(STDERR, errormsg)
            dataerr = true
        end

        if c1 <= 0 || c2 <= 0 || c3 <= 0 || c1 > 1 || c2 > 1 || c3 > 1
            println(STDERR, errormsg)
        else
            maxweight, itemarr, dataerr = readdata(ARGS[1])

            if !dataerr && length(itemarr) > 0 && maxweight > 0
                findsolution(maxweight, itemarr, c1, c2, c3)
            end
        end
    end
end

main()