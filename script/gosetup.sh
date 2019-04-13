#!/bin/bash

if [ `uname -s` == 'Darwin' ]; then
  brew install go lv
elif [ `uname -s` == 'Linux' ]; then
  sudo apt-get install golang-go lv
fi

unset $GOROOT
export GOPATH=$HOME
go get github.com/motemen/ghq
go get github.com/peco/peco/cmd/peco
go get github.com/github/hub
ls ~/bin

