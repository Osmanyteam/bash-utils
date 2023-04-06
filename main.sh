#!/usr/bin/env bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/nodejs.sh"
. "$DIR/mongodb.sh"
. "$DIR/caddyfile.sh"

mainmenu() {
    echo -ne "
Select Tools to install:
1) Nodejs
2) Mongodb
3) Mysql
4) Configure domain with reverse proxy - Caddyfile
"
read -r answer
case $answer in
    1) installnodejs ;;
    2) installmongodb ;;
    3) installmysql ;;
    4) configurednswithreverseproxy ;;
    *) echo "Invalid option";;
esac
mainmenu
}

mainmenu