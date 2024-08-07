#!/bin/bash

### Utils Unity Nodes
source <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/utils.sh)

### Function autoupgrade
CHAIN=$1
CHAIN_ID=$2
BLOCK=$3
VERSION=$4
BINARY=$5
PORT_RPC=$6

logo

echo -e "Node $(printBlue "$CHAIN") upgraded to version $(printBlue "$VERSION") on block height $(printYellow "$BLOCK")" && sleep 1 && echo ""
echo -e "You are currently in a $(printYellow "tmux session")."
echo -e "When you want to detach from the Tmux session, use the key combination: $(printYellow "CTRL + b"), then release both keys and press $(printYellow 'd'). If that doesn't work, simply $(printYellow 'reconnect') to the server."
echo -e "To check for an active tmux session after reconnection, you can use the command: $(printYellow 'tmux ls')."
echo -e "To attach to an existing tmux session, use the command: $(printYellow 'tmux attach-session -t session_name')."
echo ""

function AutoUpgrade() {
  local height

  until ((height >= BLOCK)); do
    if [ -z "$PORT_RPC" ]; then
      height=$($BINARY status 2>&1 | jq -r '.SyncInfo.latest_block_height // .sync_info.latest_block_height')
    else
      height=$($BINARY status --node="tcp://127.0.0.1:$PORT_RPC" 2>&1 | jq -r '.SyncInfo.latest_block_height // .sync_info.latest_block_height')
    fi

    echo -e "Current block height: $(printBlue "$height")"
    sleep 5
  done

  bash <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/${CHAIN,,}/upgrade/${VERSION}.sh)
  printBlue "Your node upgraded to version: $VERSION" && sleep 1
  $BINARY version --long | head
}

AutoUpgrade
