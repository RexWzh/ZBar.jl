# zbar

Wrapper of the C library [zbar](http://zbar.sourceforge.net/) for Julia.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://RexWzh.github.io/zbar.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://RexWzh.github.io/zbar.jl/dev)
[![Build Status](https://github.com/RexWzh/zbar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/RexWzh/zbar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/RexWzh/zbar.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/RexWzh/zbar.jl)

## Products
The build tarball of zbar_jll contains two products:
  - `libzbar.so`
  - `zbarimg`

This repository wraps the content of `libzbar.so` via [Clang.jl](https://github.com/JuliaInterop/Clang.jl), and provides a Julia interface for the binary product `zbarimg`.

# Usage

## Installation

```julia
using Pkg
Pkg.add("zbar")
```

## Examples

Pass the arguments to `zbarimg`:
```julia
using zbar
res = execute(`$(zbarimg()) --help`)
println(res.stdout, '\n', res.code, '\n', res.stderr)
```

Or use the wrappers `decodeimg` and `decodesingle`
```julia
using zbar, QRCoders, Test
# decode a single QR-Code
exportqrcode("hello world!", "hello.png")
@test decodesingle("hello.png") == "hello world!" # "hello world!"

# decode all QR-Codes
exportqrcode(["hello", "world"], "hello_world.gif")
@test decodeimg("hello_world.gif") == ["hello", "world"] # ["hello", "world"]
```