using UncLogic, BivariateCopulas, PyPlot, LaTeXStrings

N = 200
figsize = (10,10)
fontsize = 45
ft_ticks = 35

is = range(0, 1,length=N)
js = range(0, 1,length=N)

rs = [-0.9999, -0.8, -0.4, 0.4, 0.8 , 0.9999]
rs_plot = [-1, -0.8, -0.4, 0.4, 0.8 , 1]

for (i,r) in enumerate(rs)

    outs = [and(i, j, r) for i in is, j in js]
    C = copula(outs)

    plot(C)
    PyPlot.zlabel("")
    PyPlot.xlabel("")
    PyPlot.ylabel("")

    PyPlot.xticks(fontsize = ft_ticks)
    PyPlot.yticks(fontsize = ft_ticks)

    ax = gca()
    for t in ax.zaxis.get_major_ticks()
        t.label.set_fontsize(ft_ticks)
    end

    PyPlot.title("ρ = $(rs_plot[i])", fontsize = fontsize)
    PyPlot.tight_layout()
    savefig("cop_$(rs_plot[i]).png")
    savefig("cop_$(rs_plot[i]).pdf")
    PyPlot.clf()

end
