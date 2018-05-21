# configs

## Fix tex memory
In TeX Live, you can modify /some/path/to/texlive/some/subpath/web2c/texmf.cnf, which can be found by typing on the terminal:

kpsewhich -a texmf.cnf 
Then modify the memory size by including, e.g. :

main_memory = 8000000 
(See comments in texmf.cnf file for more details.)

Then run the following command (maybe as root, not always needed) to recreate the format files:

fmtutil-sys --all

## Okular
Editor command: `/usr/bin/atom "%f:%l"`


## Build sys image
`userimage.jl` Can contain statements such as `using Plots` for `Plots` to be included at startup.

### v0.6
```julia
Pkg.update()
include(joinpath(JULIA_HOME, Base.DATAROOTDIR, "julia", "build_sysimg.jl"))
build_sysimg(default_sysimg_path(), "native", "userimage.jl", force=true)
```


### v0.7
```julia
Pkg.update()
include(joinpath(Sys.BINDIR, Base.DATAROOTDIR, "julia", "build_sysimg.jl"))
build_sysimg(default_sysimg_path(), "native", "userimage.jl", force=true)
```
