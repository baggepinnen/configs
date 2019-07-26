git clone https://github.com/sisl/pygments-julia
cd pygments-julia/
sudo python setup.py install
pygmentize -L lexers | grep julia1
