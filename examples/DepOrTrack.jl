
include("../src/UncLogic.jl")

a1 = 0.8; a2 = 0.6; r = 0.3;
N = 10^6;

BoolDeviates = corrBool(a1,a2,r, N)


#x1 & x2 = x2 & x1
function nestedOr(x :: UncBool, y :: UncBool,r=0)
    checkUncBool.([x,y])

    z = or(x,y,r)
    w = or(z,x)
    return w
end

function nestedOrDepTrack(x :: UncBool, y :: UncBool,r)

    z11 = and(x,y,r) + and(x,~y,-1*r);
    z00 = and(~x,~y,r);
    z10 = and(~x,y,-1*r);
    #z00 = 1 - z11 - z10;
    #z10 = 1 - z11 - z00;
    z01 = 0;

    z = or(x, y, r);

    corZX = UncCorr([z00 z10 z01 z11])
    println("Joint:$([z00 z10 z01 z11])")
    println("SUM:  $(z11+z00+z10)") #this must sum up to 1

    println("corr: $corZX")

    return or(z, x, corZX);
end


MCresult  = nestedOr.(BoolDeviates[:,1], BoolDeviates[:,2])

UncLogicNoTrak   = nestedOr(a1,a2,r)
UncLogicWithTrak = nestedOrDepTrack(a1,a2,r)

MCresult = sum(MCresult)/N

println()
println("x = $a1  | y = $a2 | r = $r")
println("MC                       result = $MCresult")
println("UncLogic (no depTrack)   result = $UncLogicNoTrak")
println("UncLogic (with depTrack) result = $UncLogicWithTrak")







#McOr = or.(BoolDeviates[:,1],BoolDeviates[:,2]);
#jointmc = [McOr BoolDeviates[:,1]];

#aa = MCJoint(jointmc)