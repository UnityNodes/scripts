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
rm -rf 0g-evmos
git clone https://github.com/0glabs/0g-evmos
cd 0g-evmos
git checkout v1.0.0-testnet
make install

evmosd config chain-id zgtendermint_9000-1
evmosd config keyring-backend test
evmosd config node tcp://localhost:26657
source $HOME/.bash_profile

evmosd init "$NODE_MONIKER" --chain-id zgtendermint_9000-1

### Download genesis and addrbook
curl -L https://snapshots-testnet.nodejumper.io/0g-testnet/genesis.json > $HOME/.evmosd/config/genesis.json
curl -L https://snapshots-testnet.nodejumper.io/0g-testnet/addrbook.json > $HOME/.evmosd/config/addrbook.json

### Seed config
sed -i -e 's|^seeds *=.*|seeds = "8c01665f88896bca44e8902a30e4278bed08033f@54.241.167.190:26656,b288e8b37f4b0dbd9a03e8ce926cd9c801aacf27@54.176.175.48:26656,8e20e8e88d504e67c7a3a58c2ea31d965aa2a890@54.193.250.204:26656"|' $HOME/.evmosd/config/config.toml


### Minimum gas price
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "250000000aevmos"|' $HOME/.evmosd/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.evmosd/config/app.toml

### Create service
sudo tee /etc/systemd/system/evmosd.service > /dev/null << EOF
[Unit]
Description=0G node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which evmosd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl "https://snapshots-testnet.nodejumper.io/0g-testnet/0g-testnet_latest.tar.lz4" | lz4 -dc - | tar -xf - -C "$HOME/.evmosd"

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable evmosd.service
sudo systemctl start evmosd.service

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u evmosd -f --no-hostname -o cat "
echo ""
printColor blue "Check synchronization  >>> evmosd status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://t.me/unitynodes "
printLine
