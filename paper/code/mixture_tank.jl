using UncLogic, ProbabilityBoundsAnalysis, PyPlot

using ProbabilityBoundsAnalysis: prepFillBounds

frech = interval(-1, 1)

function plot_l(s::pbox, fill = true; label = "_nolegend_", name = missing, col = missing, heading = missing, plotting = true, save = false, alpha = 0.2, fontsize = 25)

    if (isvacuous(s))
        throw(ArgumentError("Pbox is vacuous"))
    end
    #if (ismissing(name)) name = s.id; end

    col1 = "red"
    col2 = "black"
    fillcol = "grey"
    if !(ismissing(col))
        col1 = col2 = fillcol = col
    end

    if !plotting
        ioff()
    end
    if (ismissing(name))
        fig = figure(figsize = (10, 10))
    else
        fig = figure(name, figsize = (10, 10))
    end

    ax = fig.add_subplot()
    j = (0:(s.n-1)) / s.n

    PyPlot.step([s.u[:]; s.u[s.n]; s.d[s.n]], [j; 1; 1], color = col1, where = "pre")

    i = (1:(s.n)) / s.n
    PyPlot.step([s.u[1]; s.d[1]; s.d[:]], [0; 0; i], color = col2, where = "post")

    if fill
        Xs, Ylb, Yub = prepFillBounds(s)
        ax.fill_between(Xs, Ylb, Yub, alpha = alpha, color = fillcol, label = label)
    end
    if !(ismissing(heading))
        title(heading, fontsize = fontsize)
    end
    xticks(fontsize = fontsize)
    yticks(fontsize = fontsize)
    xlabel("Distribution range", fontsize = fontsize)
    ylabel("CDF", fontsize = fontsize)

    if save
        savefig("$name.png")
        close(fig)
    end
    ion()
end

# Point estimates

T = makepbox(interval(4.5e-6, 5.5e-6))
K2 = KN(3, 100000) # midpoint of its original interval
S = makepbox(interval(0.5e-4, 1.5e-4))
K1 = KN(3, 100000)# midpoint of its original interval
R = KN(1, 10000) # midpoint of its original interval
S1 = makepbox(interval(2.5e-5, 3.5e-5))

# Independence

indep = or(T, or(K2, and(S, or(S1, or(K1, R, 0), 0), 0), 0), 0)

# Mixed

mixed = or(T, or(K2, and(S, or(S1, or(K1, R, 1), interval(-0.2, 0.2)), 0.15), frech), 0)

# Frechet

frechet = or(T, or(K2, and(S, or(S1, or(K1, R, frech), frech), frech), frech), frech)

println(indep)
println(mixed)
println(frechet)

plot_l(frechet, label = "Unknown dependence", name = "Mixture", col = "green")
plot_l(mixed, name = "Mixture", col = "blue", label = "Mixed dependence")
display(plot_l(indep, name = "Mixture", col = "red", label = "Known dependence"))
legend(fontsize = 25)
PyPlot.xlim([0, 0.0003])
PyPlot.ylim([0, 1])
PyPlot.xticks(range(0, 0.0003, length = 5), ["0", L"$0.75$", L"$1.5$", L"$2.25$", L"$3\times 10^{-4}$"])
PyPlot.xlabel(L"$\mathbb{P}(E_1)$")
PyPlot.tight_layout()
PyPlot.savefig("mixed.pdf", dpi = 300, bbox_inches = "tight")
