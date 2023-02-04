module zbar

include("Libzbar.jl")

using .Libzbar
using zbar_jll:zbarimg as czbarimg

# export symbols from Libzbar
for sym in filter(s -> startswith("$s", "zbar_"), names(Libzbar, all = true))
    @eval export $sym
end

export zbarimg, decodeimg

"""
    execute(cmd::Cmd)

Run a Cmd object, returning the stdout & stderr contents plus the exit code.

Ref: https://discourse.julialang.org/t/collecting-all-output-from-shell-commands/15592
"""
function execute(cmd::Cmd)
  out = Pipe()
  err = Pipe()

  process = run(pipeline(ignorestatus(cmd), stdout=out, stderr=err))
  close(out.in)
  close(err.in)

  (
    stdout = String(read(out)), 
    stderr = String(read(err)),  
    code = process.exitcode
  )
end

# wrapper for `zbarimg`
"""
usage: zbarimg [options] <image>...

scan and decode bar codes from one or more image files

options:
    -h, --help      display this help text
    --version       display version information and exit
    -q, --quiet     minimal output, only print decoded symbol data
    -v, --verbose   increase debug output level
    --verbose=N     set specific debug output level
    --nodbus        disable dbus message
    -d, --display   enable display of following images to the screen
    -D, --nodisplay disable display of following images (default)
    --xml, --noxml  enable/disable XML output format
    --raw           output decoded symbol data without symbology prefix
    -S<CONFIG>[=<VALUE>], --set <CONFIG>[=<VALUE>]
                    set decoder/scanner <CONFIG> to <VALUE> (or 1)
"""
function zbarimg(cmd::AbstractString)
    zbarcmd = `$(czbarimg()) $cmd`
    res = execute(zbarcmd)
    res.code != 0 && error("zbarimg failed with code $(res.code): $(res.stderr)")
    return res.stdout
end

"""
    decodeimg(file::AbstractString)

Decode a barcode image file using `zbarimg`.
"""
function decodeimg(file::AbstractString)
    isfile(file) || error("file $file does not exist")
    res = execute(`$(czbarimg()) $file`)
    res.code != 0 && error("zbarimg failed with code $(res.code): $(res.stderr)")
    # number of codes and images
    # nums = match(r"scanned (?P<ncode>\d) barcode symbols from (?P<nimg>\d) images", res.stderr)
    # ncode = parse(Int, nums["ncode"])
    # nimg = parse(Int, nums["nimg"])
    reg = r"QR-Code:(?P<content>.*)"
    return String[match(reg, line)["content"] for line in split(res.stdout, '\n') if occursin(reg, line)]
end

end
