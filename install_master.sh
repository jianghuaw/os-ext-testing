#!/usr/bin/env bash
set -eux

THIS_DIR=`pwd`
DATA_PATH=/root/os-ext-data

# Steps to reinstall:
# 1) Create new Ubuntu 14.04 server (copy password)
# 1a) 7.5GB Compute v1 flavor
# 1b) Enable monitoring and security updates
# 2) Disable password authentication
# 2a) ssh-copy-id to copy a key to the server
# 2b) edit /etc/sshd_config to set "PermitRootLogin without-password"
# 3) Copy the secret credentials dir (http://hg.uk.xensource.com/openstack/infrastructure.hg/os-ext-data) to /root
# 4) Clone this repo git:
# 4a) git clone https://github.com/citrix-openstack/os-ext-testing.git
# 4b) cd os-ext-testing; git checkout common_ci
# ?) Follow steps below
# ?) Set up monitoring checks https://intelligence.rackspace.com/cloud/entities/enWCIYVVnt

# Copied from the following URL Feb 2016
# http://docs.openstack.org/infra/openstackci/third_party_ci.html

# Install puppet
[ -e install_puppet.sh ] && rm install_puppet.sh
wget https://git.openstack.org/cgit/openstack-infra/system-config/plain/install_puppet.sh
bash install_puppet.sh

# Install puppet modules to /etc/puppet/modules
[ -e system-config ] && rm -rf system-config
git clone https://git.openstack.org/openstack-infra/system-config
cd system-config
./install_modules.sh

# Setup the site we're deploying
cp /etc/puppet/modules/openstackci/contrib/single_node_ci_site.pp /etc/puppet/manifests/site.pp

# And the secret credentials store
cp /etc/puppet/modules/openstackci/contrib/hiera.yaml /etc/puppet

# Verify that our config file matches the latest template file
# If this check fails, copy the new template to os-ext-data and create a new secrets file
diff -q /root/os-ext-data/single_node_ci_data_orig.yaml /etc/puppet/modules/openstackci/contrib/single_node_ci_data.yaml
# Since the template hasn't changed, just use the existing secrets
cp /root/os-ext-data/single_node_ci_data.yaml /etc/puppet/environments/common.yaml

# Add 'jenkins' to the hostname so Apache is happy
sed -i -e 's/^\(127\.0\.0\.1.*\)$/\1 jenkins/' /etc/hosts

sudo puppet apply --verbose /etc/puppet/manifests/site.pp
