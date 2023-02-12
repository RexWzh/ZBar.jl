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

    # QRCode with `\s\n`
    
    # QRCode with misleading information


    ### `decodesingle` ###
    @test decodesingle("$testpath/hello.png") == "hello world"
    @test decodesingle("$testpath/empty.jpeg") == ""
    @test decodesingle("$testpath/hellonewline.jpg") == "hello\nworld"
    @test_throws ErrorException decodesingle("$testpath/empty.gif")
    @test_throws ErrorException decodesingle("$testpath/hello12.gif")

end

@testset "Rules compare to QRCoders -- TODO" begin
    # Encoding mode vs QRCoders

    # mask from 0 to 7

    # error correction levels

    # version from 1 to 40
end
