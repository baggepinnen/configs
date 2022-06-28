# julia --startup-file=no --trace-compile=precompile.jl
import GR
using Plots
gr()
plot(randn(3)) |> display
plot(randn(3), randn(3)) |> display
heatmap(randn(5, 5)) |> display

import Plotly
plotly(show = false)
f1 = plot(randn(3))
f2 = plot(randn(3), randn(3))
f3 = heatmap(randn(5, 5))
display(plot(f1, f2, f3))



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


using Optim, DSP, ForwardDiff, TotalLeastSquares
# using DynamicAxisWarping
# dtw(randn(100), randn(101))
# dtw(randn(Float32, 100), randn(Float32, 101))
using StatsBase
# using Turing
using OrdinaryDiffEq

using JuliaFormatter
JuliaFormatter.format(@__FILE__)

import MatrixEquations
A = [0.9 0; 0.01 0.9];
B = randn(2, 2);
MatrixEquations.plyapd(A, B)

import DescriptorSystems
let G = DescriptorSystems.rss(2, 2, 2)
    DescriptorSystems.ghinfnorm(G)
    DescriptorSystems.gnlcf(G)
    DescriptorSystems.gnugap(G, G)
end


# using Pluto, PlutoUI
# plutotask = @async Pluto.run(launch_browser = false)
# sleep(5)



using PackageCompiler
@time PackageCompiler.create_sysimage(
    [
        :BenchmarkTools,
        # :ComponentArrays,
        :DescriptorSystems,
        :MatrixEquations,
        :DSP,
        # :DynamicAxisWarping,
        :ForwardDiff,
        :GR,
        :JuliaFormatter,
        :Optim,
        :OrdinaryDiffEq,
        :Plots,
        :StaticArrays,
        :StatsBase,
        :TotalLeastSquares,
        :Plotly,
        # :Turing,
    ];
    precompile_statements_file = "precompile.jl",
    # precompile_execution_file = "/home/fredrikb/configs/scripts/custom_sysimage.jl",
    # replace_default = false,
    sysimage_path = "sys_$(VERSION).so",
)
exit()
