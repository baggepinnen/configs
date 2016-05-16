# configs

In TeX Live, you can modify /some/path/to/texlive/some/subpath/web2c/texmf.cnf, which can be found by typing on the terminal:

kpsewhich -a texmf.cnf 
Then modify the memory size by including, e.g. :

main_memory = 8000000 
(See comments in texmf.cnf file for more details.)

Then run the following command (maybe as root, not always needed) to recreate the format files:

fmtutil-sys --all
