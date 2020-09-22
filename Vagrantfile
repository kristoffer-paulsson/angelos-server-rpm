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
  config.vm.synced_folder "data", "/home/vagrant/data", type: "virtualbox"
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    sudo dnf check-update
    sudo dnf upgrade -y

    sudo dnf groupinstall 'development tools' -y
    sudo dnf install nano git python3 python3-virtualenv rpm-build -y
    sudo dnf install bzip2-devel expat-devel gdbm-devel \
    ncurses-devel openssl-devel readline-devel sqlite-devel \
    tk-devel xz-devel zlib-devel libffi-devel -y

    mkdir rpmbuild/BUILD/ -p
    mkdir rpmbuild/BUILDROOT/ -p
    mkdir rpmbuild/RPMS/ -p
    mkdir rpmbuild/SOURCES/ -p
    mkdir rpmbuild/SPECS/ -p
    cp data/angelos.spec rpmbuild/SPECS/angelos.spec

    python3 -m virtualenv venv -p /usr/bin/python3
    source venv/bin/activate

    cd rpmbuild/SPECS/
    rpmbuild --target x86_64 -bb angelos.spec | tee build.log  # >build.log 2>&1
    mv build.log /home/vagrant/data
    mv rpmbuild/RPMS/x86_64/*.rpm /home/vagrant/data

    deactivate
  SHELL
end