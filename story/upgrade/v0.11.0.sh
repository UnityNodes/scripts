cd $HOME
rm -rf story
git clone https://github.com/piplabs/story
cd $HOME/story
git checkout v0.11.0
go build -o story ./client
sudo mv $HOME/story/story $(which story)
sudo systemctl restart story
sudo journalctl -u story -f -o cat
