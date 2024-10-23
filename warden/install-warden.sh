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

cd $HOME
rm -rf wardenprotocol
git clone https://github.com/warden-protocol/wardenprotocol
cd wardenprotocol
git checkout v0.5.2
make install

wardend config set client chain-id chiado_10010-1
wardend config set client keyring-backend test
wardend config set client node tcp://localhost:26657
source $HOME/.bash_profile

wardend init "$NODE_MONIKER" --chain-id chiado_10010-1

### Download addrbook, genesis.json
curl -L https://snapshots-testnet.unitynodes.com/warden-testnet/genesis.json > $HOME/.warden/config/genesis.json
curl -L https://snapshots-testnet.unitynodes.com/warden-testnet/addrbook.json > $HOME/.warden/config/addrbook.json

### Set seeds
sed -i -e 's|^seeds *=.*|seeds = "2d2c7af1c2d28408f437aef3d034087f40b85401@52.51.132.79:26656,8288657cb2ba075f600911685670517d18f54f3b@warden-testnet-seed.itrocket.net:18656"|' $HOME/.warden/config/config.toml

# Set peers
PEERS="8288657cb2ba075f600911685670517d18f54f3b@65.108.231.124:18656,5461e7642520a1f8427ffaa57f9d39cf345fcd47@54.72.190.0:26656,22e706be097baf72b999a6b00b5e1bba5540675c@135.181.81.254:18656"
sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.warden/config/config.toml

# Set minimum gas price
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "25000000award"|' $HOME/.warden/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
  $HOME/.warden/config/app.toml

### Create service
sudo tee /etc/systemd/system/wardend.service > /dev/null << EOF
[Unit]
Description=Warden Protocol node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which wardend) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl "https://snapshots-testnet.unitynodes.com/warden-testnet/warden-testnet-latest.tar.lz4" | lz4 -dc - | tar -xf - -C $HOME/.warden

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable wardend.service
sudo systemctl start wardend.service

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u wardend -f -o cat "
echo ""
printColor blue "Check synchronization  >>> wardend status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com/ "
printLine
