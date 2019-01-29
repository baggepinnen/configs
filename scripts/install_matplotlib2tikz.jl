]add Conda
]add PyCall

using Conda, Pkg
Conda.add_channel("conda-forge")
Conda.add("matplotlib2tikz")
Pkg.build("PyCall")
using PyCall


PyCall.@pyimport matplotlib2tikz
"""
`savetikz(path; fig = PyPlot.gcf(), extra::Vector{String})`
"""
function savetikz(path; fig = PyPlot.gcf(), extra=[])
    if extra == []
        matplotlib2tikz.save(path,fig, figureheight = "\\figureheight", figurewidth = "\\figurewidth")
    else
        matplotlib2tikz.save(path,fig, figureheight = "\\figureheight", figurewidth = "\\figurewidth", extra_tikzpicture_parameters = PyCall.pybuiltin("set")(extra))
    end
end
