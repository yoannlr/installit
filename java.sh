#!/bin/sh

# from https://adoptium.net/installation/linux/

sudo apt install -y wget apt-transport-https gpg
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update

version="$JAVA_VERSION"
if [ -z "$version" ]; then
	version="17"
fi

sudo apt install "termurin-${version}-jdk"
