#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/utils.sh)

clear
printLogo

printColor blue "Please enter the node moniker:"
read -r NODE_MONIKER

CHAIN_ID="lava-testnet-2"
BINARY_VERSION="v1.2.0"

source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/dependencies.sh)

printLine
printColor blue "4. Building binaries"

export LAVA_BINARY=lavad

cd || return
rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v1.2.0
make install

make build

lavad config keyring-backend test
lavad config chain-id $CHAIN_ID
lavad init "$NODE_MONIKER" --chain-id $CHAIN_ID

printLine
printColor blue "5.Download genesis and addrbook"
curl -s https://raw.githubusercontent.com/lavanet/lava-config/main/testnet-2/genesis_json/genesis.json > $HOME/.lava/config/genesis.json
curl -Ls https://snapshots.aknodes.net/snapshots/lava/addrbook.json > $HOME/.lava/config/addrbook.json

printLine
printColor blue "Downloading snapshot for fast synchronization" 
lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book 
curl https://snapshots.aknodes.net/snapshots/lava/snapshot-lava.AKNodes.lz4 | lz4 -dc - | tar -xf - -C $HOME/.lava
