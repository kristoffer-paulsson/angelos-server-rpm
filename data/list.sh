#!/bin/bash

find /opt/angelos -type d | grep -v "/test/\|/tests/\|/unittest/\|/test_\|/distutils/\|/angelos/meta/\|/tkinter/\|/turtledemo/\|/idlelib/\|/ensurepip/\|/lib2to3/\|/venv/" > /home/vagrant/data/directories.txt

find /opt/angelos -type f | grep -v "/test/\|/tests/\|/unittest/\|/test_\|/distutils/\|/angelos/meta/\|/tkinter/\|/turtledemo/\|/idlelib/\|/ensurepip/\|/lib2to3/\|/venv/" > /home/vagrant/data/files.txt