#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/utils.sh)

printLogo

echo "Please enter the node moniker:"
read -r NODE_MONIKER

CHAIN_ID="lava-testnet-2"
BINARY_VERSION="v1.2.0"

source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/dependencies.sh)

printColor blue "### Building binaries ###"
export LAVA_BINARY=lavad
cd || return
rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v1.2.0
make install

make build
