cd $HOME
rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v1.3.0
make install
sudo systemctl restart nibid && sudo journalctl -u nibid -f --no-hostname -o cat
