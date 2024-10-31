cd $HOME
wget https://github.com/warden-protocol/wardenprotocol/releases/download/v0.5.3/wardend_Linux_x86_64.zip
unzip wardend_Linux_x86_64.zip
rm -rf wardend_Linux_x86_64.zip
chmod +x wardend
mv wardend $(which wardend)
wardend version --long | grep -e commit -e version
#commit: 197a6f653d6d318001a9c89d5466d0ca36e03a79
#version: 0.5.3
sudo systemctl restart wardend && sudo journalctl -fu wardend -o cat
