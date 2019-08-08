git clone https://github.com/sisl/pygments-julia
cd pygments-julia/
sudo python setup.py install
pygmentize -L lexers | grep julia1
wget https://github.com/baggepinnen/configs/blob/master/scripts/atomone.py
