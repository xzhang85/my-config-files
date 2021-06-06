#!/bin/bash

echo "=== Install necessary packages ==="
sudo -E apt-get update
sudo -E apt-get install -y aptitude openssh-server git tmux neovim vim vim-nox zsh htop curl rsync clang-format cloc socat tree build-essential autoconf gdb cmake cmake-curses-gui pkg-config wget trash-cli python3-dev

echo "=== Setup GDB ==="
wget https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit -O ~/.gdbinit
mkdir ~/.gdbinit.d
cat<<EOF > ~/.gdbinit.d/dashboard
dashboard -style prompt_not_running '\[\e[1;31m\]>>>\[\e[0m\]'
dashboard -style style_low '1;31'
dashboard -style syntax_highlighting 'vim'
dashboard -layout source stack threads memory history expressions !assembly !registers
dashboard source -style height 0
dashboard stack -style compact True
dashboard stack -style limit 5
EOF

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
cp $(dirname "$0")/dir_colors ~/.dir_colors
mkdir ~/.vim
mkdir ~/bin
cp ./dgdb ~/bin
cp ./git-proxy ~/bin

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
