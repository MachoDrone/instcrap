#!/bin/sh
# start with:  wget --no-check-certificate --no-cache --no-cookies -qO - https://raw.githubusercontent.com/MachoDrone/nosnodeinstaller/main/nosnodeinstaller1| sudo bash
wget -qO nosnodeinstaller1.sh 'https://raw.githubusercontent.com/MachoDrone/nosnodeinstaller/main/nosnodeinstaller1.sh' && sudo bash nosnodeinstaller1.sh

clear
lsb_release -a

# Function to echo in green
green_echo() {
    echo -e "\033[0;32m$1\033[0m"
}

green_echo '                  /\\'
green_echo '                 /  \\'
green_echo '                /    \\'
green_echo '               --    --'
green_echo '                 |  |'
green_echo '                 |__|'
green_echo 'Please observe if you are using Ubuntu 22.04 or higher'
lsb_release -a
green_echo .
green_echo .
green_echo .
sleep 1

read -p "Enter the username: " username

sudo apt install lshw -y
sudo lshw -c display
# sudo lshw -c video
sudo ubuntu-drivers devices
sudo ubuntu-drivers autoinstall

green_echo 'sudo apt update -y'
sudo apt update -y

green_echo 'sudo apt install apt-transport-https ca-certificates curl software-properties-common -y'
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

green_echo 'sudo rm /usr/share/keyrings/docker-archive-keyring.gpg'
sudo rm /usr/share/keyrings/docker-archive-keyring.gpg
green_echo 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

green_echo 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

green_echo 'sudo apt update -y'
sudo apt update -y

green_echo 'apt-cache policy docker-ce'
apt-cache policy docker-ce

green_echo 'sudo apt install docker-ce -y'
sudo apt install docker-ce -y

green_echo 'sudo systemctl status docker'
sudo systemctl status docker > statusdocker.tmp
cat statusdocker.tmp
rm statusdocker.tmp

green_echo 'sudo usermod -aG docker $USER'
sudo usermod -aG docker $username

# wget -qO - https://raw.githubusercontent.com/MachoDrone/nosnodeinstaller/main/nosnodeinstaller2| sudo bash > go.sh
# chmod +x go.sh
# echo .
# echo .
# echo .
# echo .
# echo "TO CONTINUE THE INSTALLATION TYPE: su - yourusername"
# echo "e.g.: su - james"
# echo "THEN TYPE:  ./go.sh"
# echo .
# echo .
# echo .
# echo .


# ******** work in script?? *********
# note su - $USER (this works fine) vs sudo su - $USER (doesn't work right? "input device is not a tty")

# Switch to the user and execute commands
green_echo 'su - $USER'
groups
su - $username -c "
echo '****** groups ******'
groups
# Put commands here
echo '****** continue to 2nd session ******'
# wget --no-check-certificate --no-cache --no-cookies -qO - https://raw.githubusercontent.com/MachoDrone/nosnodeinstaller/main/nosnodeinstaller2| sudo bash
echo '****** groups ******'
groups

## sudo usermod -aG docker $USER
# ****************************************** END OF $SUDO_USER??

echo ***************************************
echo ****** sudo apt install lshw -y ******
sudo apt install lshw -y
echo ****** sudo lshw -c display ******
sudo lshw -c display
# sudo lshw -c video

echo ****** sudo ubuntu-drivers devices ******
sudo ubuntu-drivers devices

echo ****** sudo ubuntu-drivers autoinstall ******
sudo ubuntu-drivers autoinstall

# complete su - usErnAmE
"

# Commands after switching from user
green_echo 'Back to original user'
# ***********************************

green_echo 'back to 1st session'


# wget -qO - https://raw.githubusercontent.com/MachoDrone/nosnodeinstaller/main/nosnodeinstaller3| sudo bash
# EOF

sudo rm /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    sudo apt-get update

sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker

sudo systemctl restart docker

sudo mkdir /home/$USER/.nosana
printf '\nDelete this line and paste key here, or do it later: nano ~/.nosana/nosana_key.json\n' > /home/$USER/nosana_key.json
sudo nano /home/$USER/.nosana/nosana_key.json

echo ********************************
echo "complete, now do a sudo reboot"
echo ********************************
