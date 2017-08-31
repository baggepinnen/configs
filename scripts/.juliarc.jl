#!/usr/bin/julia

ENV["BRIDGE_PATH"] = ""

using Plots
pyplot(show=true)
# gr()
# pyplot()
# default(color_palette=[
# RGB{U8}(0.1,0.7,1.0),
# RGB{U8}(0.9,0.547,0.0),
# RGB{U8}(0.1,0.1,1.0),
# RGB{U8}(1.0,0.0,0.0),
# RGB{U8}(0.0,0.602,0.0),
# RGB{U8}(0.502,0.0,0.502)
#  ])
# default(background_color=RGB{U8}(0.35,0.35,0.35))
# default(background_color_outside=RGB{U8}(0.2,0.2,0.2))
# default(foreground_color_grid=RGB{U8}(0.9,0.9,0.9))
default(show=true, reuse = false, size=(600,600), lab="")
default(markerstrokealpha=0.5)
# getColorSys(i,Nsys)   = convert(Colors.RGB,Colors.HSV(360*((i-1)/Nsys)^1.5,0.9,0.8))

# default(color_palette=:hsv)


showfull(io, x) = show(IOContext(io; compact = false, limit = false), x)
showfull(x) = showfull(STDOUT, x)


rms(x) = sqrt(mean(x.^2))
sse(x) = x⋅x
#fit(y,yh) = 100 * (1-rms(y-yh)./rms(y-mean(y)));
aic(x,d) = log(sse(x)) + 2d/length(x)

function toOrthoNormal(Ti)
    T = deepcopy(Ti)
    U,S,V = svd(T[1:3,1:3])
    R = U*diagm([1,1,sign(det(U*V'))])*V'
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

@inline quadform(a,Q) =  vecdot(a,(Q*a))


# function saveandprocess(path)
#     savefig(path)
#     f = open(path,"r+")
#     s = readall(f)
#     close(f)
#     removestring = """
#     \\documentclass{minimal}
#     \\usepackage{pgfplots}
#     \\usepackage{fontspec}
#     \\usepackage{amsmath}
#     \\usepackage[active,tightpage]{preview}
#     \\PreviewEnvironment{tikzpicture}
#     \\begin{document}
#     """
#     s = replace(s,removestring,"")
#     s = replace(s,"\\begin{tikzpicture}[x=1mm,y=-1mm]","\\begin{tikzpicture}[x=\\figurewidth,y=-\\figureheight]")
#     s = replace(s,"\\fontspec{Nullable(\"Helvetica\")}","")
#     s = replace(s,"\\end{document}","")
#     s = replace(s,r"\\fontsize{.*}{.*}\\selectfont","")
#
#     f = open(path,"w")
#     write(f,s)
#     close(f)
# end

# JULIA_SVG_BROWSER = "Google Chrome.app"


function printpng(fig = current())
    savefig(fig, "tempplot.png")
    run(`lpr -PForsbergColor tempplot.png`)
    run(`rm tempplot.png`)
end

function rotate_gif(plt = current(); fps=20, step=4)
strings = String[]
dir = mktempdir()
for (i,a) = enumerate(1:step:360)
    fig = plt.subplots[1].o
    fig[:view_init](azim=a)
    s = i >= 100 ? "image$(i).png" : i >= 10 ? "image0$(i).png" : "image00$(i).png"
    push!(strings,s)
    PyPlot.savefig(joinpath(dir,strings[end]))
    println(round(a/360,3), "% done")
end
anim = Plots.Animation(dir, strings)
gif(anim, joinpath(dir,"anim_fps20.gif"), fps = fps)
    println("Saved the image in ", dir)
end

"""
`math(sl)` Takes a list of strings and wraps each string in `\$ s \$`
"""
math(sl) = map(s->string("\$",s,"\$") ,sl)

"""Takes an n vector of m vectors and creates an n×m matrix"""
# vv2m(x) = [x[i][j] for i in eachindex(x), j in eachindex(x[1])]
# vm2a3(x) = [x[k][i,j] for i in size(x[1],1), j in size(x[1],2), k in eachindex(x)]


function meshgrid(a,b)
    grid_a = [i for i in a, j in b]
    grid_b = [j for i in a, j in b]
    grid_a, grid_b
end


using PyCall
@pyimport matplotlib2tikz
"""
`savetikz(path; fig = PyPlot.gcf(), extra::Vector{String})`
"""
function savetikz(path; fig = PyPlot.gcf(), extra=[])
    if extra == []
        matplotlib2tikz.save(path,fig, figureheight = "\\figureheight", figurewidth = "\\figurewidth")
    else
        matplotlib2tikz.save(path,fig, figureheight = "\\figureheight", figurewidth = "\\figurewidth", extra_tikzpicture_parameters = pybuiltin("set")(extra))
    end
end


# function gpuoff()
#     ENV["TF_USE_GPU"] = "0"
#     Pkg.build("TensorFlow")
#     exit()
# end
#
# function gpuon()
#     ENV["TF_USE_GPU"] = "1"
#     Pkg.build("TensorFlow")
#     exit()
# end
