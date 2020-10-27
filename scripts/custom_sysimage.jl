#error("Use julia formatter a bit so Juno will be quicker at formatting")
using Pkg
Pkg.update()
using Random
# Random.__init__()
import GR
import Plotly
# GR.__init__()
using Plots
gr()
plot(randn(3)) |> display
plot(randn(3), randn(3)) |> display
heatmap(randn(5, 5)) |> display

plotly()
plot(randn(3)) |> display
plot(randn(3), randn(3)) |> display
f = heatmap(randn(5, 5))
display(f)



gr()

using StaticArrays, BenchmarkTools

a = @SVector randn(100)
a + a
a .* a
sum(a)
a = @SVector randn(Float32, 100)
a + a
a .* a
sum(a)


using Optim, StatsBase, DSP, ForwardDiff, JuliaFormatter
JuliaFormatter.format(@__FILE__)


using PackageCompiler
PackageCompiler.create_sysimage(
    [
        :Plotly,
        :Plots,
        :GR,
        :StaticArrays,
        :BenchmarkTools,
        :Optim,
        :StatsBase,
        :DSP,
        :ForwardDiff,
        :JuliaFormatter,
    ];
    precompile_statements_file = "precompile.jl",
    replace_default = false,
    sysimage_path = "sys_$VERSION",
)
exit()


# empty!(LOAD_PATH)
# empty!(DEPOT_PATH)

#julia --output-o sys.o -J"/home/fredrikb/julia/usr/lib/julia/sys.so" custom_sysimage.jl
# gcc -shared -o sys.so -Wl,--whole-archive sys.o -Wl,--no-whole-archive -L"/home/fredrikb/julia/usr/lib" -ljulia
