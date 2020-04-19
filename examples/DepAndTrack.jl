
include("../src/UncLogic.jl")

a1 = 0.5; a2 = 0.5; r = 0;
N = 10^7;

BoolDeviates = corrBool(a1,a2,r, N)


#x1 & x2 = x2 & x1
function nestedand(x :: UncBool, y :: UncBool,r=0)
    checkUncBool.([x,y])

    z = and(x,y,r)
    w = and(z,x)
    return w
end

function nestedandDepTrack(x :: UncBool, y :: UncBool, r)

    z11 = and(x,y,r);
    z00 = and(~x,~y,r) + and(~x,y, -1*r);
    z10 = 0;
    z01 = and(x,~y,-1*r);

    corZX = UncCorr([z00 z10 z01 z11])

    return and(z11, x, corZX);
end


MCresult  = nestedand.(BoolDeviates[:,1], BoolDeviates[:,2])

UncLogicNoTrak = nestedand(a1,a2,r)
UncLogicWithTrak = nestedandDepTrack(a1,a2,r)

MCresult = sum(MCresult)/N

println()
println("x = $a1  | y = $a2 | r = $r")
println("MC                       result = $MCresult")
println("UncLogic (no depTrack)   result = $UncLogicNoTrak")
println("UncLogic (with depTrack) result = $UncLogicWithTrak")





