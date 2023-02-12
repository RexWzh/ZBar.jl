using ZBar
using Test
using QRCoders

testpath = "testpath"

# image transformation
## flip
fliplr(mat) = mat[end:-1:1, :]
flipud(mat) = mat[:, end:-1:1]
flipdiag(mat)::BitMatrix = mat';

## rotate
rot180(mat) = mat[end:-1:1, end:-1:1]
rot90(mat) = flipud(mat');
rot270(mat) = fliplr(mat');

@testset "ZBar.jl -- general test" begin
    ### `zbarimg` ###
    res = execute(`$(zbarimg()) --help`)
    @test res.code == 0

    ### `decodeimg` ###
    # normal test for `.png`
    exportqrcode("hello world", "$testpath/hello.png")
    @test decodeimg("$testpath/hello.png")[1] == "hello world"

    # QRCode(s) with empty text
    exportqrcode("", "$testpath/empty.jpeg")
    @test decodeimg("$testpath/empty.jpeg")[1] == ""
    exportqrcode(["", ""], "$testpath/empty.gif")
    @test decodeimg("$testpath/empty.gif") == ["", ""]

    # QRCode with `\n`
    exportqrcode("hello\nworld", "$testpath/hellonewline.jpg")
    @test decodeimg("$testpath/hellonewline.jpg")[1] == "hello\nworld"

    # lots of QRCodes
    exportqrcode(fill("hello", 12), "$testpath/hello12.gif")
    @test decodeimg("$testpath/hello12.gif") == fill("hello", 12)

    # rotate
    mat = qrcode("hello world")
    rmat180 = rot180(mat)
    rmat90 = rot90(mat)
    rmat270 = rot270(mat)
    exportbitmat(rmat180, "$testpath/hello180.png")
    exportbitmat(rmat90, "$testpath/hello90.png")
    exportbitmat(rmat270, "$testpath/hello270.png")
    @test decodeimg("$testpath/hello180.png")[1] == "hello world"
    @test decodeimg("$testpath/hello90.png")[1] == "hello world"
    @test decodeimg("$testpath/hello270.png")[1] == "hello world"
    # flip
    fmatlr = fliplr(mat)
    fmatud = flipud(mat)
    fmatdiag = flipdiag(mat)
    exportbitmat(fmatlr, "$testpath/hellofliplr.png")
    exportbitmat(fmatud, "$testpath/helloflipud.png")
    exportbitmat(fmatdiag, "$testpath/helloflipdiag.png")
    @test decodeimg("$testpath/hellofliplr.png")[1] == "hello world"
    @test decodeimg("$testpath/helloflipud.png")[1] == "hello world"
    @test decodeimg("$testpath/helloflipdiag.png")[1] == "hello world"

    # blank image
    mat = BitMatrix(zeros(Bool, 100, 100))
    exportbitmat(mat, "$testpath/blank.png")

    res = execute(`$(zbarimg()) "$testpath/blank.png"`)
    @test res.code == 4 # no QRCode found
    @test_throws ErrorException decodeimg("$testpath/blank.png")

    # QRCode with `\s\n`
    exportqrcode(raw"hello\s\n", "$testpath/hellosn.png")
    @test decodeimg("$testpath/hellosn.png")[1] == raw"hello\s\n"
end

@testset "QRCode with misleading information" begin
    exportqrcode("hello", "$testpath/hello.png")

    res = execute(`$(zbarimg()) "$testpath/hello.png"`)
    exportqrcode(res.stdout, "$testpath/hello2.png")
    @test decodeimg("$testpath/hello2.png", check=true)[1] == res.stdout
    
    res = execute(`$(zbarimg()) --xml "$testpath/hello.png"`)
    exportqrcode(res.stdout, "$testpath/hello3.png")
    # imginfo = execute(`$(zbarimg()) --xml "$testpath/hello3.png"`)
    # println(imginfo.stdout)
    @test_broken decodeimg("$testpath/hello3.png", check=true)[1] == res.stdout
    @test decodesingle("$testpath/hello3.png") == res.stdout # fixed by `--noxml` mode

    # with fewer misleading information
    nonclosed = res.stdout[1:end-25]
    exportqrcode(nonclosed, "$testpath/hello5.png")
    @test decodesingle("$testpath/hello5.png") == nonclosed
    @test_broken decodeimg("$testpath/hello5.png", check=true)[1] == nonclosed

    # with out misleading information    
    half = res.stdout[1:div(end, 2)]
    exportqrcode(half, "$testpath/hello4.png")
    @test decodesingle("$testpath/hello4.png") == half
    @test decodeimg("$testpath/hello4.png", check=true)[1] == half

    ### `decodesingle` ###
    exportqrcode("hello world", "$testpath/hello.png")
    @test decodesingle("$testpath/hello.png") == "hello world"
    exportqrcode("", "$testpath/empty.jpeg")
    @test decodesingle("$testpath/empty.jpeg") == ""
    exportqrcode("hello\nworld", "$testpath/hellonewline.jpg")
    @test decodesingle("$testpath/hellonewline.jpg") == "hello\nworld"
    exportqrcode(fill("", 2), "$testpath/empty.gif")
    @test_throws ErrorException decodesingle("$testpath/empty.gif")
end