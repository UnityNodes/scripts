sudo systemctl stop lavad

cd && rm -rf lava
git clone https://github.com/lavanet/lava
cd lava || return
git checkout v3.1.0
make install-all

sudo systemctl start lavad
