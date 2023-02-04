module zbar

include("Libzbar.jl")

using .Libzbar

# export symbols from Libzbar
for sym in filter(s -> startswith("$s", "zbar_"), names(Libzbar, all = true))
    @eval export $sym
end

end
