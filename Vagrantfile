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
    # cp data/angelos.spec rpmbuild/SPECS/angelos.spec

    python3 -m virtualenv venv -p /usr/bin/python3
    source venv/bin/activate

    if cd angelos > /dev/null 2&>1
    then
      git pull
    else
      git clone https://github.com/kristoffer-paulsson/angelos.git angelos
      cd angelos
    fi

    if [ -s "/home/vagrant/data/libsodium-1.0.18.tar.gz" ]
    then
      ln -sf /home/vagrant/data/libsodium-1.0.18.tar.gz ./angelos-bin/tarball/libsodium-1.0.18.tar.gz
    fi

    if [ -s "/home/vagrant/data/Python-3.8.5.tgz" ]
    then
      ln -sf /home/vagrant/data/Python-3.8.5.tgz ./angelos-server/tarball/Python-3.8.5.tgz
    fi

    pip install pip --upgrade
    pip install setuptools --upgrade
    pip install wheel --upgrade
    pip install -r requirements.txt
    pip install -e .

    sudo mkdir /opt/angelos -p
    sudo chown vagrant:vagrant /opt/angelos
    python setup.py venv --prefix=/opt/angelos --step=1-9

    find /opt/angelos -type f | grep "/test/\|/tests/\|/unittest/\|/test_\|/distutils/\|/angelos/meta/\|/tkinter/\|/turtledemo/\|/idlelib/\|/ensurepip/\|/lib2to3/\|/venv/" | xargs -I'{}' rm '{}'
    find /opt/angelos -type d | grep "/test/\|/tests/\|/unittest/\|/test_\|/distutils/\|/angelos/meta/\|/tkinter/\|/turtledemo/\|/idlelib/\|/ensurepip/\|/lib2to3/\|/venv/" | xargs -I'{}' rm -fR '{}'

    angelos-meta/bin/angelos-rpm-spec -r=0 > ../rpmbuild/SPECS/angelos.spec
    cp ../rpmbuild/SPECS/angelos.spec /home/vagrant/data

    cd ../rpmbuild/SPECS/
    rpmbuild --target x86_64 -bb angelos.spec 2>&1 | tee -a build.log
    mv build.log /home/vagrant/data
    mv ../../rpmbuild/RPMS/x86_64/*.rpm /home/vagrant/data

    deactivate
  SHELL
end