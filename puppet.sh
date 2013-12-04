export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y vim wget curl git

wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update

sudo apt-get install -y ruby1.9.1 rubygems
sudo gem install rmate
sudo apt-get install -y puppet

#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# Vagrant sets up it's own path which includes puppet 2.7.x which I don't want
sudo rm -f /etc/profile.d/vagrant_ruby.sh



