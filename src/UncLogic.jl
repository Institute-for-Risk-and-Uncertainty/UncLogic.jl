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

using IntervalArithmetic, Distributions, StatsBase, LinearAlgebra

import Base.&, Base.|, Base.~

UncBool = Union{Bool, Int64, Float64, <:AbstractInterval}

#global DefaultCorr = interval(-1,1);
global DefaultCorr = 0;

include("Checks.jl")
include("Operations.jl")
include("Dependence.jl")
include("LogicSampler.jl")