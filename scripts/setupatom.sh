#!/bin/sh


wget -o "atom.x86_64.rpm" "https://atom.io/download/rpm"
sudo dnf install atom.x86_64.rpm

sudo pip install jupyter


apm install indent-detective
apm install ink
apm install julia-client
apm install language-julia
apm install latex-completions
apm install project-manager
apm install language-weave

apm install auto-indent
apm install highlight-selected
apm install language-latex
apm install latex
apm install pdf-view
apm install atom-alignment
apm install file-icons
apm install markdown-pdf
apm install markdown-preview-plus
apm install open-in-browser

apm install duotone-dark-earth-syntax
apm install rusty-dark-syntax
