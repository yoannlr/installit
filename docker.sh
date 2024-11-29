#!/bin/sh

# from https://docs.docker.com/engine/install/debian/#install-using-the-repository

sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

me="$(whoami)"
sudo usermod -aG docker "$me"

# conf daemon docker

echo 'Configure docker daemon to use 10.10.0.0/16 subnet? [Y=Return/N=Ctrl-C]'
read

if [ ! -d /etc/docker ]; then
	sudo mkdir /etc/docker
fi

sudo cat << 'EOF' > /etc/docker/daemon.json
{
        "bip":"10.10.0.1/24",
        "default-address-pools": [
		{"base":"10.10.0.0/16", "size":24}
	]
}
EOF

sudo systemctl restart docker

echo 'Docker installed. Log-out and log back in to refresh your groups.'
