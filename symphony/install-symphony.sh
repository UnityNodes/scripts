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

# Clone project repository
cd $HOME
git clone https://github.com/Orchestra-Labs/symphony.git
cd symphony
git checkout v0.3.0
make install

symphonyd init $NODE_MONIKER --chain-id symphony-testnet-3
source $HOME/.bash_profile

### Download genesis and addrbook
curl -L https://snapshots-testnet.unitynodes.com/symphony-testnet/genesis.json > $HOME/.symphonyd/config/genesis.json
curl -L https://snapshots-testnet.unitynodes.com/symphony-testnet/addrbook.json > $HOME/.symphonyd/config/addrbook.json

### Set pruning
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.005uslf"|g' $HOME/.symphonyd/config/app.toml
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.symphonyd/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.symphonyd/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "19"|g' $HOME/.symphonyd/config/app.toml

# Download snapshot
curl https://snapshots-testnet.unitynodes.com/symphony-testnet/symphony-testnet-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.symphonyd

### Create service
sudo tee /etc/systemd/system/symphonyd.service > /dev/null <<EOF
[Unit]
Description=symphonyd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which symphonyd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable symphonyd.service
sudo systemctl start symphonyd.service

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u symphonyd -f -o cat "
printColor blue "Check synchronization  >>> symphonyd status | jq | grep \"catching_up\" "
printLine
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com"
printColor blue "Our service            >>> https://services.unitynodes.com"
printColor blue "Our blog               >>> https://medium.com/@unitynodes"
printLine
