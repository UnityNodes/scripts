![nulink](https://github.com/CryptoManUA/nulink/assets/143862878/344b1023-afa7-49ff-a559-b932673d3b9f)


# NuLink Testnet Horus 2.0

<h1>Minimum System Requirements<h6>

 - Debian/Ubuntu 20.04 (Recommended)
 - 4 GB Ram
 - 30GB Available Storage
 - Minimum 2 CPU processors
 - x86 Architecture
 - Static IP address
 - Exposed TCP port 9151, make sure it's not occupied
 - Nodes can be run on cloud infrastructure


<h1>Automatic node installation<h6>

Video instruction - https://youtu.be/Nnuj5t5HdLU


```
bash <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/nulink/autoinstall-en.sh)
```

<h1>Delete node<h6>

```
rm -rf $HOME/nulink
rm -rf $HOME/geth-linux-amd64-1.10.23-d901d853/
rm -rf $HOME/geth-linux-amd64-1.10.23-d901d853tar.gz
rm -rf /etc/apt/keyrings
docker kill ursula
docker rm ursula
```
