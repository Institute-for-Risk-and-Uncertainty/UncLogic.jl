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
###

using IntervalArithmetic, Distributions

import Base.&, Base.|, Base.~

UncBool = Union{Bool,Int64,Float64,<:AbstractInterval}

global DefaultCorr = interval(-1,1);

include("Checks.jl")
include("Operations.jl")
include("Dependence.jl")