printLogo() {
    logo="

     __  __            _    __                     _   __              __              
    / / / /   ____    (_)  / /_   __  __          / | / /  ____   ____/ /  ___    _____
   / / / /   / __ \  / /  / __/  / / / /         /  |/ /  / __ \ / __  /  / _ \  / ___/
  / /_/ /   / / / / / /  / /_   / /_/ /         / /|  /  / /_/ // /_/ /  /  __/ (__  ) 
  \____/   /_/ /_/ /_/   \__/   \__, /         /_/ |_/   \____/ \__,_/   \___/ /____/  
                               /____/                                                  

"
    IFS=$'\n'
    for line in $logo; do
        echo "$line"
        sleep 0.065
    done
}

printLogo
echo "_______________________________________________________________________________________"
