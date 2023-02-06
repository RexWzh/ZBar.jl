# ZBar

Wrapper of the C library [ZBar](http://zbar.sourceforge.net/) for Julia.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://RexWzh.github.io/ZBar.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://RexWzh.github.io/ZBar.jl/dev)
[![Build Status](https://github.com/RexWzh/ZBar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/RexWzh/ZBar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/RexWzh/ZBar.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/RexWzh/ZBar.jl)

## Products
The build tarball of zbar_jll contains two products:
  - `libzbar.so`
  - `zbarimg`

This repository wraps the content of `libzbar.so` via [Clang.jl](https://github.com/JuliaInterop/Clang.jl), and provides a Julia interface for the binary product `zbarimg`.

# Usage

## Installation

```julia
using Pkg
Pkg.add("ZBar")
```

## Examples

Pass the arguments to `zbarimg`:
```julia
using ZBar
res = execute(`$(zbarimg()) --help`)
println(res.stdout, '\n', res.code, '\n', res.stderr)
```

Or use the wrappers `decodeimg` and `decodesingle`
```julia
using ZBar, QRCoders, Test
# decode a single QR-Code
exportqrcode("hello world!", "hello.png")
@test decodesingle("hello.png") == "hello world!" # "hello world!"

# decode all QR-Codes
exportqrcode(["hello", "world"], "hello_world.gif")
@test decodeimg("hello_world.gif") == ["hello", "world"] # ["hello", "world"]
```