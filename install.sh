#install build-essential and zsh
apt-get install build-essential zsh git

#install Rust language
curl https://sh.rustup.rs -sSf | sh
export PATH=${HOME}/.cargo/bin:${PATH}
rustup toolchain add nightly
cargo +nightly install racer
rustup component add rust-src

#install tmux
apt-get install tmux
git clone --recursive https://github.com/tony/tmux-config.git ~/.tmux
ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
cat -e "set -g mouse on\nset -g terminal-overrides 'xterm*:smcup@:rmcup@'">>~/.tmux/.tmux.conf

#install neovim
apt-get install software-properties-common
add-apt-repository ppa:neovim-ppa/unstable
apt-get update
apt-get install neovim

#move .zshrc to $HOME
mv zsh/.zshrc $HOME/.zshrc

#python install
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc

#python install
/bin/zsh "pyenv install anaconda3-4.1.0 && pyenv global anaconda3-4.1.0 && pyenv  rehash && pip install neovim && pip install python-language-server"

#move neovim config
mkdir $HOME/.config
cp -r ./neovim/* $HOME/.config
chmod 777 $HOME/.cache/dein/repos/github.com/autozimu/LanguageClient-neovim/bin/languageclient

#change login shell
chsh -s /bin/zsh
