#!/bin/bash

### Utils Unity Nodes
source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/utils.sh)

clear
logo

echo -e "\e[30;47m Please enter the node moniker:\e[0m"
echo -en ">>> "
read -r NODE_MONIKER

### Install Dependencies
source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/dependencies.sh)

### Building binaries
echo ""
printColor blue "[4/6] Building binaries"

CHAIN_ID="lava-testnet-2"
CHAIN_DENOM="ulava"
BINARY_NAME="lavad"
BINARY_VERSION_TAG="v2.1.3"

export LAVA_BINARY=lavad

cd || return
rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v2.1.3
make install

lavad config keyring-backend test
lavad config chain-id $CHAIN_ID
lavad init "$NODE_MONIKER" --chain-id $CHAIN_ID
source $HOME/.bash_profile

### Download addrbook
curl -L https://snapshots-testnet.unitynodes.com/lava-testnet-2/genesis.json > $HOME/.lava/config/genesis.json
curl -Ls https://snapshots-testnet.unitynodes.com/lava-testnet-2/addrbook.json -o $HOME/.lava/config/addrbook.json

### Seed config
sed -i -e 's|^seeds *=.*|seeds = "3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:19956,eb7832932626c1c636d16e0beb49e0e4498fbd5e@lava-testnet-seed.itrocket.net:20656"|' $HOME/.lava/config/config.toml

### Minimum gas price, prometheus
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.000001ulava"|' $HOME/.lava/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.lava/config/app.toml

### Create service
sudo tee /etc/systemd/system/lavad.service > /dev/null << EOF
[Unit]
Description=Lava Network Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lavad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl "https://snapshots-testnet.unitynodes.com/lava-testnet-2/lava-testnet-2-latest.tar.lz4" | lz4 -dc - | tar -xf - -C "$HOME/.lava"

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable lavad
sudo systemctl start lavad

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u lavad -f -o cat "
echo ""
printColor blue "Check synchronization  >>> lavad status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com/ "
printLine
