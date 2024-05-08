
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
rm -rf sidechain
git clone https://github.com/sideprotocol/side.git
cd side
git checkout v0.8.1
make install

sided config node tcp://localhost:26657
sided config keyring-backend os
sided config chain-id S2-testnet-2
source $HOME/.bash_profile

sided init "$NODE_MONIKER" --chain-id S2-testnet-2

### Download genesis and addrbook
wget -O $HOME/.side/config/genesis.json https://testnet-files.itrocket.net/side/genesis.json
wget -O $HOME/.side/config/addrbook.json https://testnet-files.itrocket.net/side/addrbook.json

### Seed,Peers config
SEEDS="9c14080752bdfa33f4624f83cd155e2d3976e303@side-testnet-seed.itrocket.net:45656"
PEERS="bbbf623474e377664673bde3256fc35a36ba0df1@side-testnet-peer.itrocket.net:45656,3003f4290ea8e3f5674e5d5f687ef8cd4b558036@152.228.208.164:26656,85a16af0aa674b9d1c17c3f2f3a83f28f468174d@167.235.242.236:26656,541c500114bc5516c677f6a79a5bdfec13062e91@37.27.59.176:17456,bf6869c7192e8353765398e826e7934071710d68@81.17.100.237:26656,cb17dadfca6b899af4c807ad56a9c1b1d53c5cf9@134.209.179.45:26656,010e9ba253ce06ab589198ff5717c0fd54f3070e@142.132.152.46:32656,251bffe0182432be50f0569ba3aadf84267df145@167.235.178.134:26356,3247baecb8d37c8429530b7fd2efccf12e1bda86@148.251.235.130:21656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.side/config/config.toml

### Minimum gas price
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.005uside"|' $HOME/.side/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "50"|' \
  $HOME/.side/config/app.toml

### Create service
sudo tee /etc/systemd/system/sided.service > /dev/null << EOF
[Unit]
Description=Side node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which sided) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl https://testnet-files.itrocket.net/side/snap_side.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.side

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable sided.service
sudo systemctl start sided.service

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u sided -f -o cat "
echo ""
printColor blue "Check synchronization  >>> sided status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://t.me/unitynodes "
printLine
