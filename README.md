# zsh
zsh config

mkdir -p ~/git
git clone --recursive https://github.com/zrts/zsh.git ~/git/zsh
mv ~/.zshrc ~/.zshrc_old
ln -s ~/git/zsh/zshrc ~/.zshrc
source ~/.zshrc
envset
