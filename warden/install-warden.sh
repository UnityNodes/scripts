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
git checkout v0.3.2
make install

wardend config set client chain-id buenavista-1
wardend config set client keyring-backend test
wardend config set client node tcp://localhost:26657
source $HOME/.bash_profile

wardend init "$NODE_MONIKER" --chain-id buenavista-1

### Download addrbook
curl -L https://buenavista-genesis.s3.eu-west-1.amazonaws.com/genesis.json.tar.xz | tar xJf -
mv genesis.json $HOME/.warden/config/genesis.json
curl -L https://snapshots-testnet.unitynodes.com/warden-testnet/addrbook.json > $HOME/.warden/config/addrbook.json

### Set seeds
sed -i -e 's|^seeds *=.*|seeds = "ddb4d92ab6eba8363bab2f3a0d7fa7a970ae437f@sentry-1.buenavista.wardenprotocol.org:26656,c717995fd56dcf0056ed835e489788af4ffd8fe8@sentry-2.buenavista.wardenprotocol.org:26656,e1c61de5d437f35a715ac94b88ec62c482edc166@sentry-3.buenavista.wardenprotocol.org:26656"|' $HOME/.warden/config/config.toml

### Set peers
PEERS="92ba004ac4bcd5afbd46bc494ec906579d1f5c1d@52.30.124.80:26656,ed5781ea586d802b580fdc3515d75026262f4b9d@54.171.21.98:26656"
sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.warden/config/config.toml

### Minimum gas price
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.01uward"|' $HOME/.warden/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
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
printColor blue "Check your logs        >>> journalctl -u wardend -f --no-hostname -o cat "
echo ""
printColor blue "Check synchronization  >>> wardend status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com/ "
printLine
