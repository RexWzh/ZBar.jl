module ZBar

include("Libzbar.jl")

using .Libzbar
using zbar_jll

# export symbols from Libzbar
for sym in filter(s -> startswith("$s", "zbar_"), names(Libzbar, all = true))
    @eval export $sym
end

export zbarimg, decodeimg, execute, decodesingle


"""
    execute(cmd::Cmd)

Run a Cmd object, returning the stdout & stderr contents plus the exit code.

Ref: https://discourse.julialang.org/t/collecting-all-output-from-shell-commands/15592

## zbarimg

Type

```julia
execute(`$(zbarimg()) [options] <image>...`)
```

to get the output of `zbarimg`.

---

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

# wrapper of `zbarimg`
"""
    decodeimg(file::AbstractString; check::Bool=false)

Decode a barcode image file using `zbarimg`.
"""
function decodeimg(file::AbstractString; check::Bool=false)
    # check files
    isfile(file) || SystemError("file $file does not exist")
    res = execute(`$(zbarimg()) --xml $file`)
    res.code != 0 && error("zbarimg failed with code $(res.code): $(res.stderr)")

    # compatible to windows
    txt = Sys.iswindows() ? replace(res.stdout, "\r\n" => "\n") : res.stdout
    # get the i-th QR-Code(starts from 0)
    reg = Regex("<index num='(?P<num>\\d+)'>\n<symbol type='QR-Code'.*>" *
        "<data.*><!\\[CDATA\\[(?P<text>[\\s\\S]*?)\\]\\]></data></symbol>\n</index>")
    mats = collect(eachmatch(reg, txt))
    texts = String[mat["text"] for mat in mats]

    # test if the number of QR-Codes is correct
    # in case the message of QR-Code is contains misleading information
    nums = [parse(Int, mat["num"]) for mat in mats]
    nums == collect(0:length(texts)-1) || error("The indexes of QR-Codes are not correct.")
    
    if check # get the number of Barcodes by decode message
        length(nums) == numofqrcode(file) || error("The number of QR-Codes is not correct.")
    end
    return texts
end

function numofqrcode(file::AbstractString)
    isfile(file) || SystemError("file $file does not exist")
    res = execute(`$(zbarimg()) $file`)
    res.code == 0 || return 0
    # number of codes and images
    nums = match(r"scanned (?P<ncode>\d+) barcode symbols from (?P<nimg>\d+) images", res.stderr)
    return parse(Int, nums["ncode"])
end

"""
    decodesingle(file::AbstractString)

Decode a barcode image file using `zbarimg` with only one QR-Code.
"""
function decodesingle(file::AbstractString)
    numofqrcode(file) != 1 && error("The number of QR-Codes is not correct.")
    res = execute(`$(zbarimg()) $file`)
    txt = Sys.iswindows() ? replace(res.stdout, "\r\n" => "\n") : res.stdout
    return String(match(r"QR-Code:(?P<text>[\s\S]*)\n", txt)["text"])
end

end
