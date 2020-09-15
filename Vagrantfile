#
# Copyright (c) 2018-2020 by Kristoffer Paulsson <kristoffer.paulsson@talenten.se>.
#
# This software is available under the terms of the MIT license. Parts are licensed under
# different terms if stated. The legal terms are attached to the LICENSE file and are
# made available on:
#
#     https://opensource.org/licenses/MIT
#
# SPDX-License-Identifier: MIT
#
# Contributors:
#     Kristoffer Paulsson - initial implementation
#

Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos8"
  config.vm.synced_folder "rpmbuild", "/home/vagrant/rpmbuild", type: "virtualbox"
  config.vm.provision "shell", privileged: false, inline: <<-SHELL

    sudo dnf check-update
    sudo dnf upgrade -y
    sudo dnf groupinstall 'development tools' -y
    sudo dnf install nano git python3 python3-virtualenv -y
    sudo dnf install bzip2-devel expat-devel gdbm-devel \
    ncurses-devel openssl-devel readline-devel sqlite-devel \
    tk-devel xz-devel zlib-devel libffi-devel -y

    git clone https://github.com/kristoffer-paulsson/angelos.git
    cd angelos

    python3 -m virtualenv venv -p /usr/bin/python3
    source venv/bin/activate
    pip install pip --upgrade
    pip install setuptools --upgrade
    pip install wheel --upgrade
    pip install -r requirements.txt
    pip install -e .

    sudo mkdir /opt/angelos -p
    sudo chown vagrant:vagrant /opt/angelos
    python setup.py venv --prefix=/opt/angelos

    deactivate

  SHELL
end