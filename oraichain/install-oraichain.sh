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
rm -rf orai
git clone https://github.com/oraichain/orai
cd orai
cd orai
git checkout v0.42.3
make install

oraid init "$MONIKER" --chain-id Oraichain

### Download addrbook
curl -Ls https://snapshots-mainnet.unitynodes.com/oraichain-mainnet/genesis.json > $HOME/.oraid/config/genesis.json
curl -Ls https://snapshots-mainnet.unitynodes.com/oraichain-mainnet/addrbook.json > $HOME/.oraid/config/addrbook.json

### Set seeds
sed -i -e 's|^seeds *=.*|seeds = "ddb4d92ab6eba8363bab2f3a0d7fa7a970ae437f@sentry-1.buenavista.wardenprotocol.org:26656,c717995fd56dcf0056ed835e489788af4ffd8fe8@sentry-2.buenavista.wardenprotocol.org:26656,e1c61de5d437f35a715ac94b88ec62c482edc166@sentry-3.buenavista.wardenprotocol.org:26656"|' $HOME/.warden/config/config.toml

### Set seeds
sed -E -i 's/seeds = \".*\"/seeds = \"4d0f2d042405abbcac5193206642e1456fe89963@3.134.19.98:26656,24631e98a167492fd4c92c582cee5fd6fcd8ad59@162.55.253.58:26656,bf083c57ed53a53ccd31dc160d69063c73b340e9@3.17.175.62:26656,35c1f999d67de56736b412a1325370a8e2fdb34a@5.189.169.99:26656,5ad3b29bf56b9ba95c67f282aa281b6f0903e921@64.225.53.108:26656,d091cabe3584cb32043cc0c9199b0c7a5b68ddcb@seed.orai.synergynodes.com:26656\"/' $HOME/.oraid/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025orai\"|" $HOME/.oraid/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
  $HOME/.oraid/config/app.toml


### Create service
sudo tee /etc/systemd/system/oraid.service > /dev/null <<EOF
[Unit]
Description=Orai Network Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which oraid) start --home /root/.oraid
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl "https://snapshots-mainnet.unitynodes.com/oraichain-mainnet/oraichain-mainnet-latest.tar.lz4" | lz4 -dc - | tar -xf - -C $HOME/.warden

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable oraid
sudo systemctl start oraid.service

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u oraid -f --no-hostname -o cat "
echo ""
printColor blue "Check synchronization  >>> oraid status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com/ "
printLine
