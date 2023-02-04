using Clang.Generators
using zbar_jll

cd(@__DIR__)

include_dir = normpath(zbar_jll.artifact_dir, "include")

# wrapper generator options
options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()
push!(args, "-I$include_dir")

# wrap libzbar headers in include/zbar
headers = [joinpath(include_dir, "zbar.h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)