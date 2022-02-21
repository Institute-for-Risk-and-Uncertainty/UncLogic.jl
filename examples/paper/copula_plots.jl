using UncLogic, BivariateCopulas, PyPlot, LaTeXStrings

N = 200
figsize = (10,10)
fontsize = 28
ft_ticks = 25

is = range(0, 1,length=N)
js = range(0, 1,length=N)

rs = [-0.9999, -0.8, -0.4, 0.4, 0.8 , 0.9999]

for r in rs

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

    if r == rs[1]; r == -1; end
    if r == rs[end]; r == 1; end
    PyPlot.title("r = $r", fontsize = fontsize)
    PyPlot.tight_layout()
    savefig("copulas/cop_$r.png")
    savefig("copulas/cop_$r.pdf")
    PyPlot.clf()

end
