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
git clone https://github.com/MANTRA-Finance/public.git
cd public
git checkout v3.0.0
make install

mantrachaind config chain-id mantra-hongbai-1
mantrachaind config keyring-backend os
mantrachaind config node tcp://localhost:26657
source $HOME/.bash_profile

mantrachaind init "$NODE_MONIKER" --chain-id mantra-hongbai-1

### Download genesis and addrbook
curl https://config-t.noders.services/mantra/genesis.json -o ~/.mantrachaind/config/genesis.json
curl https://config-t.noders.services/mantra/addrbook.json -o ~/.mantrachaind/config/addrbook.json

### Peers config
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"f32589afc557a5c4a372f38dae72fbaaa8a5b98d@mantra-t-rpc.noders.services:30656\"/" ~/.mantrachaind/config/config.toml

### Minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.001uom\"|" ~/.mantrachaind/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  ~/.mantrachaind/config/app.toml

### Create service
sudo tee /etc/systemd/system/mantrachaind.service > /dev/null << EOF
[Unit]
Description=mantra node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mantrachaind) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
SNAP_NAME=$(curl -s https://snapshots.l0vd.com/mantra-testnet/ | egrep -o ">mantrachain-testnet-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/mantra-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.mantrachain

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable mantrachaind
sudo systemctl start mantrachaind

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u mantrachaind -f -o cat "
echo ""
printColor blue "Check synchronization  >>> mantrachaind status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com "
printLine
