sudo systemctl stop lavad

cd && rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v3.2.0
make install-all

sudo systemctl start lavad
sudo journalctl -u lavad -f -o cat
