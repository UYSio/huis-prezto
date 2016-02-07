#!/usr/bin/env zsh

ZPREZTO="${ZDOTDIR:-$HOME}/.zprezto"

# clone or update
if [ -e $ZPREZTO  ] ; then
  pushd $ZPREZTO
  git reset --hard && git pull && git submodule update --init --recursive
  popd
else
  git clone --recursive https://github.com/sorin-ionescu/prezto.git $ZPREZTO
fi



# link configuration
setopt EXTENDED_GLOB
for rcfile in $ZPREZTO/runcoms/^README.md(.N); do
  if [ ! -L "${ZDOTDIR:-$HOME}/.${rcfile:t}" ] ; then
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  fi
done

# The problem here is that ZSH on Arch urges the user to run
# a new-user script, which might create ~/.zsh
# which won't link the zprezto .zshrc above.
if ! grep -q "init.zsh" ~/.zshrc ; then
  echo "======"
  echo "You had an existing ~/.zsh"
  echo "Prepend the contents of ~/.zprezto/runcoms/zshrc to it"
  echo "======"
fi

# The trick is to now link to custom ~/.z* scripts from the
# zprezto ones, if present.
DOTFILES=~/.huis/modules/huis-dotfiles
for rcfile in $ZPREZTO/runcoms/^README.md(.N); do
  cat <<EOF >> "${ZDOTDIR:-$HOME}/.${rcfile:t}"
# These 4 lines injected by huis-prezto
if [ -e $DOTFILES/.${rcfile:t} ]; then
  source $DOTFILES/.${rcfile:t}
fi
EOF
done

# custom prompt
cp prompt_opyate_setup $ZPREZTO/modules/prompt/functions
