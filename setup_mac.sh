#!/bin/bash

echo "=== Install necessary packages ==="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew install tmux neovim vim htop rsync clang-format cloc tree cmake wget trash-cli

echo "=== Setup oh-my-zsh ==="
sh -c "RUNZSH=no $(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "=== Copy config files ==="
cp $(dirname "$0")/vimrc ~/.vimrc
cp $(dirname "$0")/init.vim ~/.config/nvim
cp $(dirname "$0")/zshrc ~/.zshrc
cp $(dirname "$0")/p10k.zsh ~/.p10k.zsh
cp $(dirname "$0")/tmux.conf ~/.tmux.conf
cp $(dirname "$0")/gitconfig ~/.gitconfig
mkdir ~/.vim

echo "=== Setup vim-plug and vim plugins ==="
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
sed -i 's/colorscheme default/colorscheme gruvbox/' ~/.vimrc

echo "=== Setup rust and tools from cargo ==="
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > sh.rustup.rs
sh ./sh.rustup.rs -y --no-modify-path && rm ./sh.rustup.rs
source ~/.cargo/env
cargo install ripgrep bat exa

echo "remember to relogin."
echo "Bye Bye."
