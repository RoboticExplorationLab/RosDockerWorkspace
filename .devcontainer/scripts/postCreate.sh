cp /tmp/scripts/.zshrc $HOME/

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc && cp /tmp/scripts/docker.zsh-theme $HOME/.oh-my-zsh/themes/