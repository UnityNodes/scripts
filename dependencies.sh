#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/utils.sh)

printColor blue "1. Updating packages"
sudo apt update && sudo apt upgrade

