file_name = first(ARGS)
file_contents = readlines(file_name)

all_day_indices = findall(startswith("##"), file_contents)

all_day_contents = Vector{Vector{String}}(undef, length(all_day_indices))
for ii ∈ eachindex(all_day_indices)
    try
        all_day_contents[ii] = file_contents[all_day_indices[ii]:all_day_indices[ii+1]-1]
    catch
        all_day_contents[ii] = file_contents[all_day_indices[ii]:end]
    end
end

day_counters = zeros(Int, length(all_day_contents))
day_links = Vector{String}(undef, length(all_day_contents))
for (ii, day_contents) ∈ enumerate(all_day_contents)
    day_counters[ii] = count(contains("- [x]"), day_contents)
    day_counters[ii] -= count(contains("- [x] Check-"), day_contents)

    day_title = first(day_contents)
    day_link = replace(day_title, "## " => "")
    while true
        new_day_link = replace(day_link, " \n" => "\n")
        new_day_link == day_link && break
        day_link = new_day_link
    end
    short_day_title = day_link
    day_link = replace(day_link, '(' => "", ')' => "", ' ' => "-")
    day_link = lowercase(day_link)

    short_day_title = replace(short_day_title,
        "Monday" => "Mon.",
        "Tuesday" => "Tue.",
        "Wednesday" => "Wed.",
        "Thursday" => "Thu.",
        "Friday" => "Fri.",
        "Saturday" => "Sat.",
        "Sunday" => "Sun."
    )

    day_links[ii] = "- [$(iszero(day_counters[ii]) ? " " : "x")] [$short_day_title](#$day_link): $(day_counters[ii]) hour$(day_counters[ii] ≠ 1 ? "s" : "")\n"
end

total_hour_contents = "Total $(sum(day_counters)) hours:\n\n$(join(day_links))"
println(total_hour_contents)
