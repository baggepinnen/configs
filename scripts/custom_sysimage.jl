#error("Use julia formatter a bit so Juno will be quicker at formatting")
# using Pkg
# Pkg.update()
# using Random
# Random.__init__()
import GR
# GR.__init__()
using Plots
gr()
plot(randn(3)) |> display
plot(randn(3), randn(3)) |> display
heatmap(randn(5, 5)) |> display

# import Plotly
plotly()
plot(randn(3)) |> display
plot(randn(3), randn(3)) |> display
f = heatmap(randn(5, 5))
display(f)



# gr()

using StaticArrays, BenchmarkTools

a = @SVector randn(100)
a + a
a .* a
sum(a)
a = @SVector randn(Float32, 100)
a + a
a .* a
sum(a)


using Optim, DSP, ForwardDiff, ComponentArrays
using StatsBase
# using Turing
using OrdinaryDiffEq

using JuliaFormatter
JuliaFormatter.format(@__FILE__)


using PackageCompiler
@time PackageCompiler.create_sysimage(
    [
        :StaticArrays,
        :BenchmarkTools,
        :StatsBase,
        # :Turing,
        :Optim,
        :DSP,
        :ForwardDiff,
        :ComponentArrays,
        :OrdinaryDiffEq,
        # :Plotly,
        :Plots,
        :GR,
        :JuliaFormatter,
    ];
    precompile_statements_file = "precompile.jl",
    # precompile_execution_file = "/home/fredrikb/configs/scripts/custom_sysimage.jl",
    replace_default = false,
    sysimage_path = "sys_$(VERSION).so",
)
exit()


# empty!(LOAD_PATH)
# empty!(DEPOT_PATH)

#julia --output-o sys.o -J"/home/fredrikb/julia/usr/lib/julia/sys.so" custom_sysimage.jl
# gcc -shared -o sys.so -Wl,--whole-archive sys.o -Wl,--no-whole-archive -L"/home/fredrikb/julia/usr/lib" -ljulia
