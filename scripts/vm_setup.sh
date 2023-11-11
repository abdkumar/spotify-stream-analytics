echo "Running sudo apt-get update..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Installing vim editor"
sudo apt-get install vim -y

echo "install docker engine, docker compose"

# Docker installation : https://docs.docker.com/engine/install/ubuntu/
# Add Docker's official GPG key: 
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker engine, compose plugins
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt-get update

# Test Install docker engine, compose plugins
echo "docker-compose version..."
docker compose --version

echo "Docker without sudo setup..."
sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker restart
newgrp docker

echo "Test docker by running hello-world image"
sudo docker run hello-world
