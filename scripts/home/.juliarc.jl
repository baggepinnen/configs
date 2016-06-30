using Plots
plotlyjs()

function toOrthoNormal(Ti)
    T = deepcopy(Ti)
    U,S,V = svd(T[1:3,1:3])
    R = U*diagm([1,1,sign(det(U*V'))])*V'
    T[1:3,1:3] = R
    return T
end

function smartDiff(v)
    c = size(v,2)
    a1 = [zeros(1,c);diff(v)]
    a2 = [diff(v);zeros(1,c)]
    a = (a1+a2)/2
end

function saveandprocess(path)
    savefig(path)
    f = open(path,"r+")
    s = readall(f)
    close(f)
    removestring = """
    \\documentclass{minimal}
    \\usepackage{pgfplots}
    \\usepackage{fontspec}
    \\usepackage{amsmath}
    \\usepackage[active,tightpage]{preview}
    \\PreviewEnvironment{tikzpicture}
    \\begin{document}
    """
    s = replace(s,removestring,"")
    s = replace(s,"\\begin{tikzpicture}[x=1mm,y=-1mm]","\\begin{tikzpicture}[x=\\figurewidth,y=-\\figureheight]")
    s = replace(s,"\\fontspec{Nullable(\"Helvetica\")}","")
    s = replace(s,"\\end{document}","")
    s = replace(s,r"\\fontsize{.*}{.*}\\selectfont","")

    f = open(path,"w")
    write(f,s)
    close(f)
end

function normalize(x)
    x.-=mean(x,1)
    x./=std(x,1)
    x
end


# using PyCall
# @pyimport matplotlib2tikz
# function savetikz(path, fig = PyPlot.gcf(), extra=[""])
#     matplotlib2tikz.save(path,fig, figureheight = "\\figureheight", figurewidth = "\\figurewidth", extra = pybuiltin("set")(extra))
# end


# f = (x,y) -> x^2+y^3

#g(x) = eval(:(x -> $(e)))(x)


function printpng(fig = current())
    savefig(fig, "tempplot.png")
    run(`lpr -PForsbergColor tempplot.png`)
    run(`rm tempplot.png`)
end

"""
`math(sl)` Takes a list of strings and wraps each string in `\$ s \$`
"""
math(sl) = map(s->string("\$",s,"\$") ,sl)

"""Takes a n vector of m vectors and creates a n×m matrix"""
vv2m(x) = [x[i][j] for i in eachindex(x), j in eachindex(x[1])]
vm2a3(x) = [x[k][i,j] for i in size(x[1],1), j in size(x[1],2), k in eachindex(x)]


function meshgrid(a,b)
    grid_a = [i for i in a, j in b]
    grid_b = [j for i in a, j in b]
    grid_a, grid_b
end

macro edb(ex)
    local val = esc(ex)
    quote
        try
            $val
        catch er
            println("Failed at debug point ",$(string(ex)), "\nwith error ", er)
            error("Stopping")
        end
        $val
        println("Debug point ",$(string(ex)))
    end
end
