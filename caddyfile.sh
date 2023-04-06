#!/usr/bin/env bash
removeoldcaddyfile() {
    echo "Removing old Caddy"
    # sudo apt-get remove -y caddy
    echo "Old Caddy removed"
}
checkifcandyfileisinstalled() {
    if [ -x "$(command -v caddy)" ]; then
        echo "Caddy is already installed"
        # ask if user wants to remove old version
        echo "Do you want to remove old version?"
        echo "1) Yes"
        echo "2) No"
        read -r answer
        case $answer in
            1) removeoldcaddyfile ;;
            2) echo "Skipping" ;;
            *) echo "Invalid option" && checkifcandyfileisinstalled ;;
        esac
    else
        echo "Installing Caddy"
        sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
        sudo apt update
        sudo apt install caddy -y
        caddy start
        echo "Caddy installed"
    fi
}
installcaddyfile() {
    checkifcandyfileisinstalled
}
configurednswithreverseproxy() {
    # check if caddy is installed if not istalled ask to user install before to configure
    if [ -x "$(command -v caddy)" ]; then
        echo ""
    else
        echo "Caddyfile is not installed"
        echo "Do you want to install Caddyfile?"
        echo "1) Yes"
        echo "2) No"
        read -r answer
        case $answer in
            1) installcaddyfile ;;
            2) echo "Skipping" ;;
            *) echo "Invalid option" && configurednswithreverseproxy ;;
        esac
    fi
    echo "Configuring DNS with reverse proxy"
    echo "Enter domain name:"
    read -r domainname
    echo "Enter port:"
    read -r port
    echo
    # check if that domain is already configured
    if [ -f "/etc/caddy/$domainname" ]; then
        echo "Caddyfile already exists"
        echo "Do you want to overwrite it?"
        echo "1) Yes"
        echo "2) No"
        read -r answer
        case $answer in
            1) echo "Overwriting Caddyfile" ;;
            2) echo "Skipping" && exit ;;
            *) echo "Invalid option" && configurednswithreverseproxy ;;
        esac
    fi
    echo "Creating Caddyfile"
    touch "/etc/caddy/$domainname"
    content="$domainname {
      reverse_proxy $domainname:$port
    }"
    echo "$content" > "/etc/caddy/$domainname"
    echo "Caddyfile created"
    cat "/etc/caddy/$domainname"
    # now add import to main caddyfile if not exists
    if grep -q "import $domainname" "/etc/caddy/Caddyfile"; then
        echo "Caddyfile already imported"
    else
        echo "Importing Caddyfile"
        # set on top of file
        echo "import $domainname" | sudo tee -a /etc/caddy/Caddyfile
        echo "Caddyfile imported"
    fi
    echo "Restarting Caddy"
    currentdir=$(pwd)
    cd /etc/caddy/ && sudo caddy reload Caddyfile
    cd "$currentdir" || exit
}
