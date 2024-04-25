#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/utils.sh)

echo ""
printColor blue "[1/6] Updating packages"
sudo apt update && sudo apt upgrade
anim

echo ""
printColor blue "[2/6] Install dependencies"
sudo apt install -y lz4 jq make git gcc build-essential curl chrony unzip gzip snapd tmux bc
anim

echo ""
printColor blue "[3/6] Install go" && sleep 1
if ! [ -x "$(command -v go)" ]; then
  source <(curl -s "https://raw.githubusercontent.com/UnityNodes/scripts/main/install-go.sh")
  source .bash_profile
  anim
fi

echo "$(go version)"
