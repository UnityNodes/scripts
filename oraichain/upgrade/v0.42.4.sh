sudo systemctl stop oraid

cd $HOME/orai/
git pull
git checkout v0.42.3
make install

sudo systemctl start oraid
sudo journalctl -u oraid -f -o cat
