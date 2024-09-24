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
rm -rf titan-chain
git clone https://github.com/Titannet-dao/titan-chain.git
cd titan-chain
git fetch origin
make install

titand config node tcp://localhost:26657
titand config keyring-backend test
titand config chain-id titan-test-3
source $HOME/.bash_profile

titand init "$MONIKER" --chain-id titan-test-3

# Download genesis and addrbook files
curl -Ls https://snapshots-testnet.unitynodes.com/titan-testnet/genesis.json > $HOME/.titan/config/genesis.json
curl -Ls https://snapshots-testnet.unitynodes.com/titan-testnet/addrbook.json > $HOME/.titan/config/addrbook.json

# Set minimum gas price
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uttnt\"/;" ~/.titan/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.titan/config/app.toml

### Create service
sudo tee /etc/systemd/system/titand.service > /dev/null <<EOF
[Unit]
Description=titand
After=network-online.target

[Service]
User=$USER
ExecStart=$(which titand) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl "https://snapshots-testnet.unitynodes.com/titan-testnet/titan-testnet-latest.tar.lz4" | lz4 -dc - | tar -xf - -C $HOME/.warden

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

# Start the service and check the logs
sudo systemctl daemon-reload
sudo systemctl enable titand
sudo systemctl start titand.service
sudo journalctl -u titand.service -f -o cat

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u titand -f  -o cat "
echo ""
printColor blue "Check synchronization  >>> titand status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com/ "
printLine
