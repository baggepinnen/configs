#!/bin/sh

wget -o "atom.x86_64.rpm" "https://atom.io/download/rpm"
sudo dnf install atom.x86_64.rpm

sudo pip install jupyter

apm install indent-detective
apm install ink
apm install julia-client
apm install language-julia
apm install latex-completions


