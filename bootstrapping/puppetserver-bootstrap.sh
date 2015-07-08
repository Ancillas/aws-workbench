#!/bin/bash
set -e
set -u

codename=`lsb_release -sc`
install_deb="puppetlabs-release-pc1-${codename}.deb"

if [ -z "`dpkg -l | grep puppetlabs-release-pc1`" ]; then
    echo "Downloading ${install_deb}"
    curl -O https://apt.puppetlabs.com/${install_deb}
    echo "Installing ${install_deb}"
    sudo dpkg -i ${install_deb}
else
    echo "puppetlabs-release-pc1 repository already installed"
fi 

echo "Updating apt cache"
sudo apt-get update

if [ -z "`dpkg -l | grep puppetserver`" ]; then
    echo "Installing puppetserver"
    sudo apt-get -q -y install puppetserver
else
    echo "puppetserver package already installed"
fi

if [ -z "`dpkg -l | grep puppet-agent`" ]; then
    echo "Installing puppet agent"
    sudo apt-get -q -y install puppet-agent
else
    echo "puppet-agent package already installed"
fi

if [ ! -f "/etc/profile.d/puppetlabs-bin.sh" ]; then
sudo tee "/etc/profile.d/puppetlabs-bin.sh" > /dev/null <<'EOF'
if [ -d "/opt/puppetlabs/bin" ]; then
    PATH="/opt/puppetlabs/bin:$PATH" 
fi        
EOF
else
    echo "/etc/profile.d/pupetlabs-bin.sh already exists"
fi
sudo chmod 644 /etc/profile.d/puppetlabs-bin.sh
source /etc/profile.d/puppetlabs-bin.sh 

if [ -z "`grep \"/opt/puppetlabs/bin\" /etc/bash.bashrc`" ]; then
sudo tee -a "/etc/bash.bashrc" > /dev/null <<'EOF'
if [ -d "/opt/puppetlabs/bin" ]; then
    PATH="/opt/puppetlabs/bin:$PATH"
fi
EOF
else
    echo "/etc/bash.bashrc is already configured to add /opt/puppetlabs/bin to the PATH"
fi

