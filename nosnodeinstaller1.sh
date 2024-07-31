#!/bin/sh
# start with:
# wget -qO nosnodeinstaller1.sh 'https://raw.githubusercontent.com/MachoDrone/nosnodeinstaller/main/nosnodeinstaller1.sh' && sudo bash nosnodeinstaller1.sh

clear
# Display Ubuntu version
lsb_release -a

# Function to have green echo output
green_echo() {
    echo -e "\033[0;32m$1\033[0m"
}

# At the present, this script has only been tested on v22.04
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

# Prompt for login name to use with sudo commands
echo A REBOOT WILL HAPPEN AT THE END OF THIS INSTALLER. PRESS CTRL-C TO QUIT
read -p "Enter your Ubuntu login username for this PC: " username

# Include nano for pasting key and optional ssh install for minimum installed Ubuntu
sudo apt update -y
sudo apt install nano -y
sudo apt install openssh-server -y

# Create optional startnode.sh with redundancy if node stops/crashes
printf '\n#!/bin/sh\nbash <(wget -qO- https://nosana.io/testgrid.sh)\necho ------------------------------------------\necho 10 sec pause for ctrl-c option\necho ------------------------------------------\nsleep 10\n./startnode.sh\n' > /home/$SUDO_USER/startnode.sh
chmod +x /home/$username/startnode.sh

# This section creates a blank key with instructions to paste a key into nano.
sudo rm -r -f .nosana
mkdir /home/$username/.nosana
printf 'Delete this line and paste key here or do it later with nano ~/.nosana/nosana_key.json\n' > /home/$username/.nosana/nosana_key.json
sudo nano /home/$username/.nosana/nosana_key.json


### BEGIN NODE INSTALL GUIDE INSTRUCTIONS ‡
### Skip nothing from the Guide for the anal-retentive people, the people who can see this comment.

# Install required for minimal install Ubuntu
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

#   ‡ Optional repeated step, only because it's in the guide.
green_echo 'sudo apt update -y'
# sudo apt update -y

green_echo 'apt-cache policy docker-ce'
apt-cache policy docker-ce

green_echo 'sudo apt install docker-ce -y'
sudo apt install docker-ce -y

green_echo 'sudo systemctl status docker'
sudo systemctl status docker > statusdocker.tmp
cat statusdocker.tmp
rm statusdocker.tmp

green_echo 'sudo usermod -aG docker $username'
sudo usermod -aG docker $username

# After su command, green echo is lost. Switch to asterisks for echos. (Green echo can likely be included in next revision).
# Switch to the user and execute commands. Green echo will show their own username
green_echo 'su - $USER'
groups
su - $username -c "
echo '****** groups ******'
groups

# The following line was applied about 10 lines earlier
## sudo usermod -aG docker $USER

"
# Commands after switching from user
# green_echo 'Back to previous session'

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

# Optional instant reboot
sudo reboot
#echo ********************************
#echo "complete, now do a sudo reboot"
#echo ********************************


