function getstrdate()
    date = string(now())
    date = replace(date, r"(:|\-)", "")
    date = replace(date, "T", "_")
    date = replace(date, r"\.\d+", "")

    return date
end