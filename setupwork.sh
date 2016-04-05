#!/bin/sh

wget -o "atom.x86_64.rpm" "https://atom.io/download/rpm"
sudo dnf install atom.x86_64.rpm

sudp pip install jupyter
