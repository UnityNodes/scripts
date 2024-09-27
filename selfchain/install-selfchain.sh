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
wget https://github.com/hotcrosscom/Self-Chain-Releases/releases/download/mainnet-v1.0.1/selfchaind-linux-amd64
chmod +x selfchaind-linux-amd64
mv selfchaind-linux-amd64 $HOME/go/bin/selfchaind
source .bash_profile

selfchaind init "$NODE_MONIKER" --chain-id self-1

### Download genesis and addrbook
curl -Ls https://snapshots-mainnet.unitynodes.com/selfchain-mainnet/genesis.json > $HOME/.selfchain/config/genesis.json
curl -Ls https://snapshots-mainnet.unitynodes.com/selfchain-mainnet/addrbook.json > $HOME/.selfchain/config/addrbook.json

### Set pruning
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"

sed -i -e "s/^pruning *=.*/pruning = "$PRUNING"/" $HOME/.selfchain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = "$PRUNING_KEEP_RECENT"/" $HOME/.selfchain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = "$PRUNING_INTERVAL"/" $HOME/.selfchain/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.selfchain/config/config.toml
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.selfchain/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = "0.005uself"/" $HOME/.selfchain/config/app.toml

### Create service
sudo tee /etc/systemd/system/selfchaind.service > /dev/null <<EOF
[Unit]
Description=selfchain node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which selfchaind) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

# Download Latest Snapshot
curl https://snapshots-mainnet.unitynodes.com/selfchain-mainnet/selfchain-mainnet-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.selfchain

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable selfchaind.service
sudo systemctl start selfchaind.service

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u selfchaind -f -o cat "
printColor blue "Check synchronization  >>> selfchaind status | jq | grep \"catching_up\" "
printLine
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com"
printColor blue "Our service            >>> https://services.unitynodes.com"
printColor blue "Our Twitter            >>> https://x.com/UnityNodes"
printLine
