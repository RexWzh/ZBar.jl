using ZBar
using Documenter

DocMeta.setdocmeta!(ZBar, :DocTestSetup, :(using ZBar); recursive=true)

makedocs(;
    modules=[ZBar],
    authors="rex <1073853456@qq.com> and contributors",
    repo="https://github.com/RexWzh/ZBar.jl/blob/{commit}{path}#{line}",
    sitename="ZBar.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://RexWzh.github.io/ZBar.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/RexWzh/ZBar.jl",
    devbranch="main",
)
