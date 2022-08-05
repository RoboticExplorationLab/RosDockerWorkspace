export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="docker"

plugins=(git autojump)

source $ZSH/oh-my-zsh.sh

source /opt/ros/noetic/setup.zsh

export PROMPT_COMMAND='history -a'
export HISTFILE=/commandhistory/.zsh_history
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/raisim_build/lib
export PYTHONPATH=$PYTHONPATH:/opt/raisim_build/lib

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias wssetup=". ./devel/setup.zsh"
alias buildlimit="catkin build -j5 --mem-limit 70%"
