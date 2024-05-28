printColor() {
    local color=$1
    local text=$2

    case $color in
        "green")
            echo -e "\e[1m\e[32m${text}\e[0m" ;;
        "red")
            echo -e "\e[1m\e[31m${text}\e[0m" ;;
        "blue")
            echo -e "\e[1m\e[34m${text}\e[0m" ;;
        "yellow")
            echo -e "\e[1m\e[33m${text}\e[0m" ;;
	"black") 
	    echo -e "\e[1m\e[30m${text}\e[0m" ;;
        *)
            echo "Unsupported color" ;;
    esac
}

function logo {
  bash <(curl -s https://raw.githubusercontent.com/UnityNodes/scripts/main/logo.sh)
}


function printLine {
  echo "---------------------------------------------------------------------------------------"
}       

function addToPath {
    if ! echo "$PATH" | grep -q "${1}" ; then
        echo "export PATH=\$PATH:${1}" >> $HOME/.bash_profile
        source $HOME/.bash_profile
    fi
}

function printAddition {
    echo -e "\e[4m${1}\e[0m"
}

function printGreen {
    echo -e "\e[1m\e[32m${1}\e[0m"
}

function printRed {
    echo -e "\e[1m\e[31m${1}\e[0m"	
}

function printBlue {
	echo -e "\e[1m\e[34m${1}\e[0m"
}

function printYellow {
	echo -e "\e[1m\e[33m${1}\e[0m"
}

function anima() {
    local -i width=50
    local -i progress=0
    local -i step=7

    while ((progress <= width)); do
        local bar="["
        for ((i = 0; i < progress; i++)); do
            bar+="="
        done
        for ((i = progress; i < width; i++)); do
            bar+=" "
        done
        bar+="]"

        printf "\r%s %d%%" "$bar" "$((progress * 100 / width))"
        ((progress += step))
        sleep 0.05
    done
}



#Chain-id
wardenchain=buenavista-1
sidechain=S2-testnet-2
ogchain=zgtendermint_16600-1
initchain=initiation-1

#Script-ChangePort
#!/bin/bash

standard_ports="9090 9091 26658 26657 26656 6060 26660 1317"
port27="27658 27657 26060 27656 27660 29090 29091 21317 28545 28546 26065"
port28="28658 28657 28060 28656 28660 29190 29191 21317 28545 28546 28065"
port29="29658 29657 29060 29656 29660 29290 29291 29317 28545 28546 29065"
port30="30658 30657 30060 30656 30660 29390 29391 30317 28545 28546 30065"
port31="31658 31657 31060 31656 31660 29190 29191 31317 28545 28546 31065"
port32="32658 32657 32060 32656 32660 29290 29291 32317 28545 28546 32065"
port33="33658 33657 33060 33656 33660 29390 29391 33317 28545 28546 33065"
port34="34658 34657 34060 34656 34660 29490 29491 34317 28545 28546 34065"
port35="35658 35657 35060 35656 35660 29590 29591 35317 28545 28546 35065"
port36="36658 36657 36060 36656 36660 29690 29691 36317 28545 28546 36065"
port37="37658 37657 37060 37656 37660 29790 29791 37317 28545 28546 37065"
port38="38658 38657 38060 38656 38660 29890 29891 38317 28545 28546 38065"
port39="39658 39657 39060 39656 39660 29990 29991 39317 28545 28546 39065"

CheckAvailablePorts() {
  
    for port in $standard_ports; do
        if ! lsof -i :$port &>/dev/null; then
            return
        fi
    done

  
    for i in {27..39}; do
        eval "ports=\$port$i"
        for port in $ports; do
            if ! lsof -i :$port &>/dev/null; then
                return
            fi
        done
    done

    
    echo -e "\e[30;47mВсі доступні порти зайняті.\e[0m"
    echo -e "\e[30;47mВведіть значення нових не зайнятих портів, з переліку доступних:\e[0m"
    echo -en ">>> "
    read -r customport

   
    sed -i.bak -e "s%:26658%:${customport}658%; s%:26657%:${customport}657%; s%:6060%:${customport}060%; s%:26656%:${customport}656%; s%:26660%:${customport}660%" "$HOME/.$nodefolder/config/config.toml" && \
    sed -i.bak -e "s%:9090%:${customport}090%; s%:9091%:${customport}091%; s%:1317%:${customport}317%; s%:8545%:${customport}545%; s%:8546%:${customport}546%; s%:6065%:${customport}065%" "$HOME/.$nodefolder/config/app.toml" && \
    sed -i.bak -e "s%:26657%:${customport}657%" "$HOME/.$nodefolder/config/client.toml"
}
