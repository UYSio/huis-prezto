#!/usr/bin/env zsh
# Prezto wrapper which basically runs the commands over at
# https://github.com/sorin-ionescu/prezto#readme and
# points to extra ~/.z* things

ZPREZTO="${ZDOTDIR:-$HOME}/.zprezto"

# clone or update
if [ -e $ZPREZTO  ] ; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git $ZPREZTO
else
  pushd $ZPREZTO
  git reset --hard && git pull && git submodule update --init --recursive
  popd
fi

# link configuration
setopt EXTENDED_GLOB
for rcfile in $ZPREZTO/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# The trick is to now link to custom ~/.z* scripts from the
# zprezto ones, if present.
DOTFILES=~/.huis/modules/huis-dotfiles
for rcfile in $ZPREZTO/runcoms/^README.md(.N); do
  cat <<EOF > "${ZDOTDIR:-$HOME}/.${rcfile:t}"
# These 4 lines injected by huis-prezto
if [ -e $DOTFILES/$rcfile ]; then
  source $DOTFILES/$rcfile
fi
EOF
done
