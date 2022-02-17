###
#
#       Part of the UncLogic.jl package, for pushing uncertainty through
#       logical statements
#
#       This file defines the package
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
#
#
#       To Do:
#                    -> Fix correlated sampler (close)
#                    -> Fix and: use Scotts model with checking of correlation coefficient
#                    -> Compute joint distributions with correlations and 2 marginals
#                    ->
#
#
#
#
###

module UncLogic

    using ProbabilityBoundsAnalysis, IntervalArithmetic, Distributions, StatsBase, LinearAlgebra, PossibilisticArithmetic

    import Base: ~, !, <, >,==

    import ProbabilityBoundsAnalysis.isscalar

    #UncBool = Union{Bool, Int64, Float64, <:AbstractInterval, <: AbstractPbox, <: AbstractFuzzy}

    UncBool = Union{Bool, Int64, Float64, <:AbstractInterval, <: AbstractPbox}

    #global DefaultCorr = interval(-1,1);
    global DefaultCorr = 0;

    dual(x :: Interval) = Interval(x.hi,x.lo)
    dual(x :: Real) = x

    right(x :: pbox) = x.d[end]
    left(x :: pbox) = x.u[1]

    isDual(x :: Interval) = x.hi < x.lo
    isDual(x :: Real) = false

    isequal(x :: pbox, y ::Union{Int64, Float64}) = false
    isequal(y ::Union{Int64, Float64}, x :: pbox) = isequal(x, y)

    isequal(x :: FuzzyNumber, y ::Union{Int64, Float64}) = false
    isequal(y ::Union{Int64, Float64}, x :: FuzzyNumber) = isequal(x, y)

    isscalar(x:: FuzzyNumber) = false

    ==(x :: pbox,y ::Union{Int64, Float64}) = isequal(x,y)
    ==(y ::Union{Int64, Float64}, x :: pbox) = isequal(y,x)

    ==(x :: FuzzyNumber,y ::Union{Int64, Float64}) = isequal(x,y)
    ==(y ::Union{Int64, Float64}, x :: FuzzyNumber) = isequal(y,x)

    isless(x :: pbox, y :: Union{Int64, Float64}) = cdf(x,y);
    isless(y :: Union{Int64, Float64},x :: pbox) = cdf(complement(x),y);

    <(x :: pbox, y :: Union{Int64, Float64}) = isless(x,y)
    <(x :: Union{Int64, Float64}, y :: pbox) = isless(x,y)

    >(x :: pbox, y :: Union{Int64, Float64}) = isless(y,x)
    >(x :: Union{Int64, Float64}, y :: pbox) = isless(y,x)


    export
        and, not, or, ~, !, <, >, ==, isequal, nor, conditional, Joint, UncCorr, getValidCorr,
        randomBool, corrBool, UncBool, checkUncBool, checkCor

    include("Checks.jl")
    include("Operations.jl")
    include("Dependence.jl")
    include("LogicSampler.jl")


end # module
