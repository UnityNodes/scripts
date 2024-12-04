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
wget -O geth https://github.com/piplabs/story-geth/releases/download/v0.10.1/geth-linux-amd64
chmod +x $HOME/geth
sudo mv $HOME/geth $(which geth)

cd $HOME
rm -rf story
git clone https://github.com/piplabs/story
cd story
git checkout v0.13.0
go build -o story ./client
sudo mv ~/story/story ~/go/bin/

# Set node CLI configuration
story init --moniker "$MONIKER" --network iliad

# Download genesis and addrbook files
curl -Ls https://snapshots-testnet.unitynodes.com/story-testnet/genesis.json > $HOME/.story/config/genesis.json
curl -Ls https://snapshots-testnet.unitynodes.com/story-testnet/addrbook.json > $HOME/.story/config/addrbook.json

# Set peers
PEERS="fa294c4091379f84d0fc4a27e6163c956fc08e73@65.108.103.184:26656,f0e8398215663070d0d65ea6478f61688228d9d9@3.146.164.199:26656,2086affe2a3ea6ba3a9e6ca16a3ba406906f6eea@141.98.217.151:26656,bf975933a1169221e3bd04164a7ba9abc5d164c8@3.16.175.31:26656,bd58bf29180f476bd250af22d6026559d7eff289@146.59.118.198:26656,c2a6cc9b3fa468624b2683b54790eb339db45cbf@story-testnet-rpc.itrocket.net:26656,7b597e80021987209b197930b899fb7e0402717c@148.251.8.22:27136,493e0dd839c3ffa0ce6899eea575dac9806223f5@51.161.13.62:26656,efaccc76baf2008484acdc004dd1c337a2698a80@109.199.100.6:27656,bd15435cdd52e2a4b3ea15efb057cea2293251ff@202.61.250.9:26656,88dad3e6443440d6a34483a4ab7555d2cc2489e1@202.61.192.167:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@story-testnet.rpc.kjnodes.com:26656,2fb7d62902b9aeb9615eebc980d750f9e11ac872@64.130.55.48:26656,92a0ce5ad06567ae64a587c52141f05212f04605@113.166.213.143:12656,7cc415203fc4c1a6e534e5fed8292467cf14d291@65.21.29.250:3610,6ff5cc06487e25be0d9d768ba6a25bdd29db953e@95.216.13.161:52656"
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
