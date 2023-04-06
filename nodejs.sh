#!/usr/bin/env bash
removeoldnodejs() {
    echo "Removing old Nodejs"
    # sudo apt-get remove -y nodejs
    echo "Old Nodejs removed"
}
checkifnodejsisinstalled() {
    if [ -x "$(command -v node)" ]; then
        echo "Nodejs is already installed"
        # ask if user wants to remove old version
        echo "Do you want to remove old version?"
        echo "1) Yes"
        echo "2) No"
        read -r answer
        case $answer in
            1) removeoldnodejs ;;
            2) echo "Skipping" ;;
            *) echo "Invalid option" && checkifnodejsisinstalled ;;
        esac
    fi
}
getversionfrominput() {
    echo "Enter version number:"
    read -r versiontoinstall
    echo "$versiontoinstall"
}
getversiontoinstall() {
    versiontoinstall=""
    # from lastest to 10.x
    echo "Which version of Nodejs do you want to install?"
    echo "1) 16.x"
    echo "2) 15.x"
    echo "3) 14.x"
    echo "4) 13.x"
    echo "5) 12.x"
    echo "6) 11.x"
    echo "7) 10.x"
    echo "8) input version:"
    read -r answer
    case $answer in
        1) versiontoinstall="16.x" ;;
        2) versiontoinstall="15.x" ;;
        3) versiontoinstall="14.x" ;;
        4) versiontoinstall="13.x" ;;
        5) versiontoinstall="12.x" ;;
        6) versiontoinstall="11.x" ;;
        7) versiontoinstall="10.x" ;;
        8) getversionfrominput ;;
        *) echo "Invalid option" && getversiontoinstall ;;
    esac
    echo "$versiontoinstall"
}
installnodejs() {
    # checkifnodejsisinstalled
    getversiontoinstall
    version="$versiontoinstall"
    echo "Installing Nodejs $version"
    # curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    # sudo apt-get install -y nodejs
    echo "Nodejs installed"
}