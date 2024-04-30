sudo systemctl stop sided

cd && rm -rf sidechain
git clone https://github.com/sideprotocol/sidechain.git
cd sidechain
git checkout v0.7.0-rc2

sudo systemctl start lavad
