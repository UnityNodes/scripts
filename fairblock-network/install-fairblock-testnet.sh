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


echo ""
printColor blue "[4/6] Building binaries"

# Clone project repository
cd $HOME
rm -rf fairyring
git clone https://github.com/Fairblock/fairyring fairyring
cd fairyring
git checkout v0.8.3
make install

# Set node CLI configuration
fairyringd config chain-id fairyring-testnet-2
fairyringd init $MONIKER --chain-id fairyring-testnet-2
source $HOME/.bash_profile

# Download genesis and addrbook files
curl -Ls https://snapshots-testnet.unitynodes.com/fairblock-testnet/genesis.json > $HOME/.fairyring/config/genesis.json
curl -Ls https://snapshots-testnet.unitynodes.com/fairblock-testnet/addrbook.json > $HOME/.fairyring/config/addrbook.json

# Set minimum gas price
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025ufairy\"/;" ~/.fairyring/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
  $HOME/.fairyring/config/app.toml

### Create service
sudo tee /etc/systemd/system/fairyringd.service > /dev/null <<EOF
[Unit]
Description=Fairblock Testnet Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which fairyringd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl https://snapshots-testnet.unitynodes.com/fairblock-testnet/fairblock-testnet-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.fairyring
### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

# Start the service and check the logs
sudo systemctl enable fairyringd
sudo systemctl start fairyringd.service
sudo journalctl -u fairyringd.service -f -o cat

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u fayriringd -f  -o cat "
echo ""
printColor blue "Check synchronization  >>> fayriringd status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com/ "
printLine
