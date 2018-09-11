#install build-essential and zsh
apt-get install build-essential zsh git

#install Rust language
curl https://sh.rustup.rs -sSf | sh
export PATH=${HOME}/.cargo/bin:${PATH}
rustup toolchain add nightly
cargo +nightly install racer
rustup component add rust-src

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
/bin/zsh -c "pyenv install anaconda3-4.1.0 && pyenv global anaconda3-4.1.0 && pyenv  rehash && pip install neovim"

#move neovim config
mkdir $HOME/.config
cp -r ./neovim/* $HOME/.config

#change login shell
chsh -s /bin/zsh