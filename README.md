# UncLogic.jl

A julia package for pushing uncertainty through Boolean functions. This package may be used to construct uncertain boolean functions, such as fault or decision trees. Various types of uncertain Booleans are supported, with an uncertain dependency between the states.

Uncertain Boolean inputs may be given as:

  * Booleans: certain states 0 or 1 
  * Probabilities: uncertain states<img src="https://render.githubusercontent.com/render/math?math=\in[0,1]">
  * Interval probabilities:  uncertain states<img src="https://render.githubusercontent.com/render/math?math=\subseteq[0,1]">
  * Distributional and p-box probabilities
  
Supported Boolean operations:
  * and, &
  * or, |
  * not, ~

When working with uncertain states, we must consider the dependency between the states. For example, to compute Z = X & Y, we must know the dependency between X and Y to compute Z exactly. `UncLogic.jl` uses Copulas for the dependency between uncertain events. The pearson correlation coefficient between two events may be presented to an operator as a point value or an interval <img src="https://render.githubusercontent.com/render/math?math=\rho\subseteq[-1,1]">. If <img src="https://render.githubusercontent.com/render/math?math=\rho=[-1,1]">, then the dependency is not known and the output will be computed with all possible dependencies.


Installation
---

**1. Downloading the source code**
```julia
julia> include("directory/of/source/src/UncLogic.jl")
```

Once installed, uncertain numbers can be created
