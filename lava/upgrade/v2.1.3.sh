sudo systemctl stop lavad

cd && rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v2.1.3
make install-all

sudo systemctl start lavad
