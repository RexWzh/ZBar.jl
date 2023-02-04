using zbar
using Test
using QRCoders

testpath = "testpath"


@testset "zbar.jl -- general test" begin
    ### `zbarimg` ###
    println(execute(`$(zbarimg()) --help`).stdout)
    @test true

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

    # flip

    # blank image

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
