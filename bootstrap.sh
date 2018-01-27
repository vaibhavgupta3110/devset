#!/usr/bin/env bash

set -x

# housekeeping
sudo apt-get --fix-missing update
sudo apt-get --fix-missing dist-upgrade
sudo apt-get -y --fix-missing upgrade
sudo apt -y full-upgrade
sudo apt-get -y autoremove

# install usuals
sudo apt-get -y -f install \
linux-headers-"$(uname -r)" \
git g++ libssl-dev \
libncurses5-dev bc m4 make unzip libmnl-dev libssh-dev \
bison cmake automake autoconf build-essential libpq-dev libffi-dev clang ssh \
curl wget libtool python python-pip cpio bzip2 gcc python3-ply ncurses-dev \
python-yaml graphviz python-apt openssl fop xsltproc unixodbc-dev \
python3-apt arduino gcc-avr avr-libc avrdude arduino-core arduino-mk \
python-configobj python-jinja2 python-serial default-jdk squashfs-tools \
ssh-askpass software-properties-common libicu-dev git attr build-essential \
libacl1-dev libattr1-dev libblkid-dev libgnutls-dev libreadline-dev python-dev \
libpam0g-dev python-dnspython gdb pkg-config libpopt-dev libldap2-dev dnsutils \
libbsd-dev attr krb5-user docbook-xsl libcups2-dev acl ntp ntpdate winbind

# update package sources & keys
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc \
| sudo apt-key add -
wget --quiet -O - \
http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc \
| sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" \
| sudo tee -a /etc/apt/sources.list
echo "deb http://packages.erlang-solutions.com/ubuntu trusty contrib" \
| sudo tee -a /etc/apt/sources.list
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
gpg --keyserver hkp://keys.gnupg.net --recv-keys \
409B6B1796C275462A1703113804BB82D39DC0E3

# housekeeping
sudo apt-get update
sudo apt-get -y upgrade

# install rvm
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm

# install ruby 2.4.0
rvm install ruby-2.4.2 --default --binary

#install couchdb repos
sudo apt-add-repository -y ppa:couchdb/stable
sudo apt-get update
sudo apt-get -y -f remove couchdb couchdb-bin couchdb-common
sudo apt-get install -y -f couchdb
# test couchdb installation
curl localhost:5984

# install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo -e "\n. $HOME/.asdf/asdf.sh" >> ~/.bashrc
echo -e "\n. $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
# just in case
source ~/.asdf/asdf.sh
source ~/.asdf/completions/asdf.bash

# add asdf plugins
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
asdf plugin-update --all

# install latest versions of all
touch ~/.tool-versions
echo -n "nodejs " >> ~/.tool-versions
echo "$(asdf list-all nodejs | sort -nr - | head -1)" >> ~/.tool-versions
echo -n "erlang " >> ~/.tool-versions
echo "$(asdf list-all erlang | sort -nr - | head -1)" >> ~/.tool-versions
echo -n "elixir " >> ~/.tool-versions
echo "$(asdf list-all elixir | sort -nr - | head -1)" >> ~/.tool-versions
echo -n "postgres " >> ~/.tool-versions
echo "$(asdf list-all postgres | sort -nr - | head -1)" >> ~/.tool-versions

# install the tool-versions
asdf install

# get rid of duplicate sources
git clone https://github.com/davidfoerster/apt-remove-duplicate-source-entries.git
cd ~/apt-remove-duplicate-source-entries
sudo ./apt-remove-duplicate-source-entries.py --help
sleep 10s
sudo ./apt-remove-duplicate-source-entries.py -y && cd ~/
sleep 10s

# house keeping
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove

# reboot because why naht
sudo reboot
