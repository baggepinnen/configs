# #!/usr/bin/julia
# find undefs: (Array|Vector|Matrix)\{.*?\}\([^u]
#
using StaticArrays, BenchmarkTools, LinearAlgebra, Statistics, Random, AutomaticDocstrings, Serialization, Plots
ENV["PYTHON"] = "python3"
# try
#     @eval using Plots
#     @async begin
#         plot(randn(10)); closeall();
#     end
# catch err
#     @warn(err)
# end
# using Plots
# pyplot()
# theme(:ggplot2)
# Plots.default(show=true, size=(1000,666))
# # @spawn begin
# try Plots.plot(randn(19),show=false); catch end
# Plots.plot(randn(19), show=false)
# Plots.closeall()
# #     end
# # end
# # gr()
# # pyplot()
# # default(show=true, reuse = false, size=(600,600), lab="")
# # default(color_palette=[
# # RGB{U8}(0.1,0.7,1.0),
# # RGB{U8}(0.9,0.547,0.0),
# # RGB{U8}(0.1,0.1,1.0),
# # RGB{U8}(1.0,0.0,0.0),
# # RGB{U8}(0.0,0.602,0.0),
# # RGB{U8}(0.502,0.0,0.502)
# #  ])
# # default(background_color=RGB{U8}(0.35,0.35,0.35))
# # default(background_color_outside=RGB{U8}(0.2,0.2,0.2))
# # default(foreground_color_grid=RGB{U8}(0.9,0.9,0.9))
# # default(markerstrokealpha=0.5)
# # getColorSys(i,Nsys)   = convert(Colors.RGB,Colors.HSV(360*((i-1)/Nsys)^1.5,0.9,0.8))
#
# # default(color_palette=:hsv)
#
Serialization.serialize(filename::AbstractString, data) = open(f->serialize(f, data), filename, "w")
Serialization.deserialize(filename) = open(f->deserialize(f), filename)
#
#
# showfull(io, x) = show(IOContext(io; compact = false, limit = false), x)
# showfull(x) = showfull(STDOUT, x)
#
#
# rms(x) = sqrt(mean(x.^2))
# sse(x) = x⋅x
# #fit(y,yh) = 100 * (1-rms(y-yh)./rms(y-mean(y)));
# aic(x,d) = log(sse(x)) + 2d/length(x)
#
function toOrthoNormal(Ti)
    T = deepcopy(Ti)
    U,S,V = svd(T[1:3,1:3])
    R = U*diagm(0=>[1,1,sign(det(U*V'))])*V'
    T[1:3,1:3] = R
    return T
end

function centraldiff(v::AbstractMatrix)
    dv = diff(v)/2
    a1 = [dv[[1],:];dv]
    a2 = [dv;dv[[end],:]]
    a = a1+a2
end

function centraldiff(v::AbstractVector)
    dv = diff(v)/2
    a1 = [dv[1];dv]
    a2 = [dv;dv[end]]
    a = a1+a2
end
#
# @inline quadform(a,Q) =  vecdot(a,(Q*a))
#
#
function update_plot!(p; max_history = 10, attribute = :markercolor)
    num_series = length(p.series_list)
    if num_series > 1
        if num_series > max_history
            deleteat!(p.series_list,1:num_series-max_history)
        end
        for i = 1:min(max_history, num_series)-1
            alpha = 1-2/max_history
            c = p[i][attribute]
            b = alpha*c.b + (1-alpha)*0.5
            g = alpha*c.g + (1-alpha)*0.5
            r = alpha*c.r + (1-alpha)*0.5
            a = alpha*c.alpha
            p[i][attribute] = RGBA(r,g,b,a)
        end
    end
end

function printpng(fig = current())
    savefig(fig, "tempplot.png")
    run(`lpr -PForsbergColor tempplot.png`)
    run(`rm tempplot.png`)
end
#
# function rotate_gif(plt = current(); fps=20, step=4)
#     strings = String[]
#     dir = mktempdir()
#     for (i,a) = enumerate(1:step:360)
#         fig = plt.subplots[1].o
#         fig[:view_init](azim=a)
#         s = i >= 100 ? "image$(i).png" : i >= 10 ? "image0$(i).png" : "image00$(i).png"
#         push!(strings,s)
#         PyPlot.savefig(joinpath(dir,strings[end]))
#         println(round(a/360,3), "% done")
#     end
#     anim = Plots.Animation(dir, strings)
#     gif(anim, joinpath(dir,"anim_fps20.gif"), fps = fps)
#     println("Saved the image in ", dir)
# end
#
# """
# `math(sl)` Takes a list of strings and wraps each string in `\$ s \$`
# """
# math(sl) = map(s->string("\$",s,"\$") ,sl)
#
# # """Takes an n vector of m vectors and creates an n×m matrix"""
# # vv2m(x) = [x[i][j] for i in eachindex(x), j in eachindex(x[1])]
# # vm2a3(x) = [x[k][i,j] for i in size(x[1],1), j in size(x[1],2), k in eachindex(x)]
#
#
function meshgrid(a,b)
    grid_a = [i for i in a, j in b]
    grid_b = [j for i in a, j in b]
    grid_a, grid_b
end
#
#
# #
# using PyCall
# PyCall.@pyimport matplotlib2tikz
# """
# `savetikz(path; fig = PyPlot.gcf(), extra::Vector{String})`
# """
# function savetikz(path; fig = PyPlot.gcf(), extra=[])
#     if extra == []
#         matplotlib2tikz.save(path,fig, figureheight = "\\figureheight", figurewidth = "\\figurewidth")
#     else
#         matplotlib2tikz.save(path,fig, figureheight = "\\figureheight", figurewidth = "\\figurewidth", extra_tikzpicture_parameters = PyCall.pybuiltin("set")(extra))
#     end
# end
# #
#
#
# function savefig2(filename, opts=[])
#     fig = current()
#     layout = size(fig.layout.grid)
#     pgffig = fig.o
#     pattern = "axis background/.style={fill={rgb,1:red,1.00000000;green,1.00000000;blue,1.00000000}}"
#     foreach(f->(f.width="\\figurewidth"), pgffig)
#     foreach(f->(f.height="\\figureheight"), pgffig)
#     subfig = product(0:layout[2]-1, 0:layout[1]-1)
#     for (f,sfig) in zip(pgffig, subfig)
#         stylevec = split(f.style, ",")
#         for (i,style) in enumerate(stylevec)
#             if !isempty(opts) && style ∈ keys(opts)
#                 stylevec[i] = opts[style]
#                 delete!(opts, style)
#             end
#             if contains("$style", pattern)
#                 stylevec[i] = "xshift=$(1.05*sfig[1])\\figurewidth, yshift=$(1.05*sfig[2])\\figureheight"#replace(stylevec[i], pattern, "")
#             else
#                 stylevec[i] *= "\n"
#             end
#         end
#         @show opts
#         for style in opts
#             push!(stylevec, style[2])
#         end
#         f.style= prod(stylevec)
#     end
#     PGFPlots.save(filename, pgffig, include_preamble=false)
#     temppath, temp = mktemp()
#     for line in readlines(filename, chomp=true)
#         # println(line)
#         line = replace(line, "{unbounded coords", "unbounded coords",1)
#         line = replace(line, "\\figureheight}, ymin", "\\figureheight, ymin",1)
#         println(temp, line)
#     end
#     close(temp)
#     mv(temppath, filename, remove_destination=true)
# end
#
#
function savefig3(filename)

    savefig(filename)
    temppath, temp = mktemp()
    pattern = r"axis background/.style={fill={rgb,1:red,[\d\.]+;green,[\d\.]+;blue,[\d\.]+}}\s*?,"
    open(filename) do f
        text = read(f, String)
        text = replace(text, pattern => "")
        text = replace(text, r"height = \{[\.\d]+\w*?\}" => "height = {\\figureheight}")
        text = replace(text, r"width = \{[\.\d]+\w*?\}" => "width = {\\figurewidth}")
        text = replace(text, r",[\w\s]+? style = \{font = \{\\fontsize\{[\w\s\d\.]*?\}\{[\w\s\d\.]*?\}\\selectfont\}, color = \{rgb,1:red,0.00000000;green,0.00000000;blue,0.00000000\}, draw opacity = 1.0, rotate = 0.0\}" => "")
        text = replace(text, r",[\w\s]+? style = {color = \{rgb,1:red,0.00000000;green,0.00000000;blue,0.00000000\},\n*?draw opacity = 1.0,\n*?line width = 1,\n*?solid(,fill = \{rgb,1:red,1.00000000;green,1.00000000;blue,1.00000000\},font = \{\\fontsize\{[\w\s\d\.]*?\}\{[\w\s\d\.]*?\}\\selectfont})?\}" => "")
        # text = replace(text, r""
        print(temp, text)
    end
    close(temp)
    mv(temppath, filename, force=true)
end


"""
    superweave(source, args...; kwargs...)

Args and kwargs goes to weave(s, args...; kwargs...)
Try
```julia
using Literate, Weave
superweave("myfile.jl", doctype="md2pdf")
```
"""
function superweave(source, args...; kwargs...)
    tmpname = tempname()
    Literate.markdown(source, tmpname, documenter=false)
    sourcename = replace(source, ".jl"=>".md")
    sourcename = match(r"(\w+.md)", sourcename)[1]
    sourcename = joinpath(tmpname,sourcename)
    jmdsource = replace(sourcename,".md"=>".jmd")
    run(`cp $(sourcename) $(jmdsource)`)
    weave(jmdsource, args...; kwargs...)
end

#
#
#
#
# function update_plot(p::Plots.Subplot; max_history = 10, attribute = :markercolor)
#     num_series = length(p.series_list)
#     if num_series > 1
#         if num_series > max_history
#             deleteat!(p.series_list,1:num_series-max_history)
#         end
#
#         for i = 1:min(max_history, length(p.series_list))-1
#             alpha = i/max_history
#             c = p[i][attribute]
#             c = RGBA(
#             alpha*c.r + (1-alpha)*0.5,
#             alpha*c.g + (1-alpha)*0.5,
#             alpha*c.b + (1-alpha)*0.5,
#             c.alpha)
#             p[i][attribute] = c
#         end
#     end
# end
#
#
macro showt(e)
    r = string(e)
    quote
        print($r, " type: ")
        printstyled(typeof($(esc(e))), "\n", bold=true)
        $(esc(e))
    end
end

macro shows(e)
    r = string(e)
    quote
        print($r, " size: ")
        printstyled(size($(esc(e))), "\n", bold=true)
        $(esc(e))
    end
end

macro showts(e)
    r = string(e)
    quote
        print($r, " size: ")
        printstyled(size($(esc(e))) ," ", typeof($(esc(e))), "\n", bold=true)
        $(esc(e))
    end
end

macro showst(e)
    r = string(e)
    quote
        print($r, " size: ")
        printstyled(size($(esc(e))) ," ", typeof($(esc(e))), "\n", bold=true)
        $(esc(e))
    end
end



struct onlyone <: AbstractMatrix{Bool}
    v::Bool
end
function Base.iterate(o::onlyone, state=1)
      state == 1 ? o.v : !o.v, state+1
end
Base.size(o::onlyone) = (1,typemax(Int))
Base.length(o::onlyone) = typemax(Int)
Base.getindex(o::onlyone,i) = i == 1 ? o.v : !o.v
Base.getindex(o::onlyone,i,j) = j == 1 ? o.v : !o.v
