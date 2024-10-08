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
rm -rf bin
mkdir bin
cd bin
wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.3-b224fdf.tar.gz
tar -xvzf geth-linux-amd64-0.9.3-b224fdf.tar.gz
mv ~/bin/geth-linux-amd64-0.9.3-b224fdf/geth ~/go/bin/
mkdir -p ~/.story/story
mkdir -p ~/.story/geth

cd $HOME
rm -rf story
git clone https://github.com/piplabs/story
cd story
git checkout v0.10.1
go build -o story ./client
sudo mv ~/story/story ~/go/bin/

# Set node CLI configuration
story init --moniker "$MONIKER" --network iliad

# Download genesis and addrbook files
curl -Ls https://snapshots-testnet.unitynodes.com/story-testnet/genesis.json > $HOME/.story/config/genesis.json
curl -Ls https://snapshots-testnet.unitynodes.com/story-testnet/addrbook.json > $HOME/.story/config/addrbook.json

# Set peers
PEERS="343507f6105c8ebced67765e6d5bf54bc2117371@38.242.234.33:26656,de6a4d04aab4e22abea41d3a4cf03f3261422da7@65.109.26.242:25556,7844c54e061b42b9ed629b82f800f2a0055b806d@37.27.131.251:26656,1d3a0e76b5cdf550e8a0351c9c8cd9b5285be8a2@77.237.241.33:26656,f1ec81f4963e78d06cf54f103cb6ca75e19ea831@217.76.159.104:26656,2027b0adffea21f09d28effa3c09403979b77572@198.178.224.25:26656,118f21ef834f02ab91e3fc3e537110efb4c1c0ac@74.118.140.190:26656,8876a2351818d73c73d97dcf53333e6b7a58c114@3.225.157.207:26656,caf88cbcd0628188999104f5ea6a5eed4a34422c@178.63.184.134:26656,7f72d44f3d448fd44485676795b5cb3b62bf5af0@142.132.135.125:20656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.story/story/config/config.toml

#Disable indexer
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.story/story/config/config.toml

# Create a service story-geth
sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which geth) --iliad --syncmode full --http --http.api eth,net,web3,engine --http.vhosts '*' --http.addr 0.0.0.0 --http.port ${STORY_PORT}545 --authrpc.port ${STORY_PORT}551 --ws --ws.api eth,web3,net,txpool --ws.addr 0.0.0.0 --ws.port ${STORY_PORT}546
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Create a service story service
sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story Service
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/.story/story
ExecStart=$(which story) run

Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

# Start the service and check the logs
sudo systemctl daemon-reload
sudo systemctl enable story story-geth
sudo systemctl restart story story-geth

# Download latest chain data snapshot(Story+Geth)
echo ""
printColor blue "[5/6] Downloading snapshot for fast synchronization" 
curl https://snapshots-testnet.unitynodes.com/story-testnet/story-testnet-latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.story
### Start service and run node
echo ""
printColor blue "[6/6] Start service and run node"

### Useful commands
echo ""
printLine
printColor blue "Check your logs story       >>> journalctl -u story -f  -o cat "
echo ""
printColor blue "Check your logs story geth  >>> journalctl -u story-geth -f  -o cat "
echo ""
printColor blue "Check synchronization  >>> story status | jq | grep \"catching_up\" "
echo ""
printColor blue "Enjoy Unity Nodes      >>> https://unitynodes.com/ "
printLine
