bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export PS1='\[\e[34;1m\]\H \[\e[0m\]\w> '
export VISUAL="/usr/bin/atom"
export EDITOR="$VISUAL"

export JULIA_NUM_THREADS=4

export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:/usr/lib64/nvidia/:$LD_LIBRARY_PATH
export CUDA_HOME=/usr/local/cuda

