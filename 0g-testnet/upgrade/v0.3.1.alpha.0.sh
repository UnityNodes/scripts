sudo systemctl stop 0gchaind

cd $HOME
rm -rf 0g-chain
wget -O 0gchaind https://github.com/0glabs/0g-chain/releases/download/v0.3.1.alpha.0/0gchaind-linux-v0.3.1.alpha.0
chmod +x $HOME/0gchaind
sudo mv $HOME/0gchaind $(which 0gchaind)
sudo systemctl restart 0gchaind
