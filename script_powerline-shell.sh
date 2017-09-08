#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

bashFile="/etc/bash.bashrc"
cd /tmp


## FONT
  # clone
  git clone https://github.com/powerline/fonts.git --depth=1
  # install
  cd fonts
  ./install.sh
  # clean-up a bit
  cd ..
  rm -rf fonts
## END FONT

git clone https://github.com/milkbikis/powerline-shell
cd powerline-shell

cp config.py.dist config.py
./install.py

# Add instruction to $bashFile
if ! grep -q "powerline" "$bashFile"; then
  echo '# powerline-shell for every user
  if [ -f /etc/bashrc.d/powerline-shell.py ]; then
    # POWERLINE-SHELL SECTION
    function _update_ps1() {
      PS1="$(/etc/bashrc.d/powerline-shell.py $? 2>>/dev/null)"
    }

    if [ "$TERM" != "linux" ]; then
      PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi
  fi' >> "$bashFile"
  echo "Fini"
else
  echo "Déjà dans $bashFile"
fi

# Copy python script to /etc/basrc.d/
mkdir -p /etc/bashrc.d/
cp powerline-shell.py /etc/bashrc.d/
chmod 755 /etc/bashrc.d/powerline-shell.py
