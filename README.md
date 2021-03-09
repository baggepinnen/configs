# configs

## Fix tex memory
In TeX Live, you can modify `/some/path/to/texlive/some/subpath/web2c/texmf.cnf`, which can be found by typing on the terminal:

`kpsewhich -a texmf.cnf`
Then modify the memory size by including, e.g. :

`main_memory = 8000000`
(See comments in texmf.cnf file for more details.)

Then run the following command (maybe as root, not always needed) to recreate the format files:

`fmtutil-sys --all`

## Okular
Editor command:
`/usr/bin/atom "%f:%l"`
`code -g %f:%l`

## Tikzexternalize
```latex
\usepgfplotslibrary{external}
\tikzexternalize[prefix=build/] % then manually create the folder build/build
```
## Make changes to PR branch
The simplest approach is to follow [this guide](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/committing-changes-to-a-pull-request-branch-created-from-a-fork) and use the SSH protocol to push.
