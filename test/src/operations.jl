@testset "Operations" begin

    @test 0 == and(0, 0)
    @test 0 == and(0, 1)
    @test 0 == and(1, 0)
    @test 1 == and(1, 1)
    @test 1 == and(1, 1, interval(-1, 1))

end
