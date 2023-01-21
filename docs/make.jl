using zbar
using Documenter

DocMeta.setdocmeta!(zbar, :DocTestSetup, :(using zbar); recursive=true)

makedocs(;
    modules=[zbar],
    authors="rex <1073853456@qq.com> and contributors",
    repo="https://github.com/RexWzh/zbar.jl/blob/{commit}{path}#{line}",
    sitename="zbar.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://RexWzh.github.io/zbar.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/RexWzh/zbar.jl",
    devbranch="main",
)
