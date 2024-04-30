sudo systemctl stop wardend

cd $HOME
rm -rf wardenprotocol
git clone https://github.com/warden-protocol/wardenprotocol
cd wardenprotocol
git checkout v0.3.0

sudo systemctl start wardend
sudo journalctl -u wardend -f -o cat
