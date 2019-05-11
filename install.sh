
if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
fi

install_pyenv()
{
  echo "Install Python"
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && export PYENV_ROOT="$HOME/.pyenv" \
    && export PATH="$PYENV_ROOT/bin:$PATH" \
    && if command -v pyenv 1>/dev/null 2>&1; then fieval "$(pyenv init -)" fi \
    && pyenv install 3.5.6 \
    && pip install neovim
}

if [ $OS = "Darwin" ];then
  echo "Install development environment for OSX"
  echo "Install homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install zsh
  chsh /usr/local/bin/zsh
  cp ./zsh/.zshrc $HOME

  #Install git
  brew install git

  #Install pyenv and neovim plugin
  install_pyenv

  echo "Install Neovim"
  brew install --HEAD neovim

  echo "Install Alacritty"
  brew cask install alacritty
elif [ $OS = "Linux" ];then
  echo "Install development environment for linux"
  apt-get update -y
  apt-get install -y zsh git
  chsh /usr/local/bin/zsh
  cp ./zsh/.zshrc $HOME

  #Install pyenv and neovim plugin
  install_pyenv

  apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:neovim-ppa/stable \
    && apt-get update -y \
    && apt-get install -y neovim

  echo "Install Alacritty"
  apt install -y alacritty
fi

echo "Install fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
  && ~/.fzf/install
