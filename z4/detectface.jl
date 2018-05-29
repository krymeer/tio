using HTTP, JSON
include("appendix.jl")

function reqbody(url)
    return JSON.json(Dict(
        "api_key"           => "d45fd466-51e2-4701-8da8-04351c872236",
        "file_uri"          => url,
        "detection_flags"   => "classifiers"
    ))
end

function detectface(url)
    headers = Dict(
        "Content-Type"  => "application/json",
        "accept"  => "application/json"
    )

    try
        r = HTTP.post("https://www.betafaceapi.com/api/v2/media", headers=headers, body=reqbody(url))
        if (r.status == 200)
            println(STDERR, "\nInfo: image processed successfully")
            processtags(String(r.body))
        end
    catch (e)
        println(STDERR, "\n$e")
        println(STDERR, "\nError: HTTP request failed\n")
        quit()
    end
end

function processtags(data)
    json      = JSON.parse(data)
    tags      = json["media"]["faces"][1]["tags"]
    featlist  = ["5oclock shadow", "bald", "beard", "goatee", "heavy makeup", "mustache", "sideburns", "wearing earrings", "wearing lipstick", "wearing necklace", "wearing necktie"]
    features  = filter(x -> x["name"] in featlist, tags)
    input     = Int64[]

    try
        date        = getstrdate()
        filename    = string("input_", date, ".txt")

        open(filename, "w") do f
            for feature in features
                write(f, string(((feature["value"] == "yes")? 1 : 0), " "))
            end
            
            println(STDERR, "Info: data written to $filename\n")
        end
    catch (e)
        println(STDERR, "\nError: $e\n")
        quit()
    end
end

if length(ARGS) >= 1
    detectface(ARGS[1])
end