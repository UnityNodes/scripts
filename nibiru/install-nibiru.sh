
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
rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v1.2.0
make install

nibid config node tcp://localhost:26657
nibid config keyring-backend os
nibid config chain-id cataclysm-1
source $HOME/.bash_profile

nibid init "$NODE_MONIKER" --chain-id=cataclysm-1

### Download genesis and addrbook
curl -Ls https://snapshots.aknodes.net/snapshots/nibiru-mainnet/genesis.json > $HOME/.nibid/config/genesis.json
curl -Ls https://snapshots.aknodes.net/snapshots/nibiru-mainnet/addrbook.json > $HOME/.nibid/config/addrbook.json

### Seed,Peers config
PEERS=2def9fa7dfe945cdcde36e8086683c575e57fdb2@5.161.69.253:26656,9915b1353daa966c8e2cc9be4978710c9fb45eef@138.201.188.126:31256,ab2ae706ea5b5df1b306608b258c2232516bdc02@51.195.104.64:5656,063df1b08744f8150f2b00913a0cec9fcbd47ac8@51.89.173.96:55356,75ef1a4193d19788049a2a04115ed42c46f785f0@35.233.106.156:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml

### Minimum gas price
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.005unibi"|' $HOME/.nibid/config/app.toml

### Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "50"|' \
  $HOME/.nibid/config/app.toml

### Create service
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibid Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nibid

### Download snapshot
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl https://snapshots.aknodes.net/snapshots/nibiru-mainnet/snapshot-nibiru-mainnet.AKNodes.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid

### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

sudo systemctl daemon-reload
sudo systemctl enable nibid.service
sudo systemctl start nibid.service

### Useful commands
echo ""
printLine
printColor blue "Check your logs        >>> journalctl -u nibid -f -o cat "
printColor blue "Check synchronization  >>> nibid status | jq | grep \"catching_up\" "
printLine
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com"
printColor blue "Our service            >>> https://service.unitynodes.com"
printColor blue "Our blog               >>> https://medium.com/@unitynodes"
printLine
