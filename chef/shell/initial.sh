#!/bin/bash

VAGRANT_DIR="/vagrant"

# Branding...
cat "$VAGRANT_DIR/chef/shell/vdd.txt"

# Upgrade Chef.
echo "Updating Chef to 12.16.42 version. This may take a few minutes..."
sh -c "echo 'LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8' > /etc/default/locale"
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo add-apt-repository ppa:nijel/phpmyadmin -y
sudo apt-get update
sudo apt-get upgrade
apt-get install python-software-properties -y &> /dev/null
apt-get update &> /dev/null
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get update &> /dev/null
echo "sources updated"
echo "installing ruby and chef"
apt-get install build-essential ruby ruby-dev --no-upgrade --yes
update-ca-certificates
gem install chef --version="12.16.42" --no-rdoc --no-ri --conservative
echo "installed ruby and chef"
