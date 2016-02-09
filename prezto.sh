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
  FULL_RCFILE="${ZDOTDIR:-$HOME}/.${rcfile:t}"
  # if the file exists, back it up
  if [ -e $FULL_RCFILE ] ; then
    mv $FULL_RCFILE ${FULL_RCFILE}.huisbak
  fi
  if [ ! -L $FULL_RCFILE ] ; then
    ln -s "$rcfile" $FULL_RCFILE
  fi
done

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
