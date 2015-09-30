#!/usr/bin/env bash

# this script installs everything necessary to run the gadgetron tool chain.
#
# It assumes you start with a clean, default ubuntu 15.04 installation.
#
# It was built to prepare a VM for gadgetron develompent.  It's probably not
# safe to run this on an existing machine, but it should provide a good roadmap
# for installation in general.

function banner () {
    echo
    echo "========================================================"
    echo $1
    echo "========================================================"
    echo
}

function request () {
    echo
    echo "===================== TAKE ACTION! ====================="
    echo $1
    echo "========================================================"
    echo
}


if ! [ -e /usr/local/bin/brew ]; then
    request "You need to install brew.  \nThis will clash if you have another package manager installed, so I am not going to do it automatically.\nYou can do it with 'ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"'"
    exit ;
fi

request "Checking for Xcode.  If a window appears asking if you want to install XCode.  Go ahead and instalt it."

if ! gcc /dev/null -c -o /dev/null 2>&1; then
    gcc
fi

banner Installing Brew packages

brew tap homebrew/x11
brew install python spatialindex cgal swig sdl sdl_image sdl_mixer sdl_ttf portmidi hg inkscape curl nodejs libxml2 libxslt wget 

# install 32-bit eagle (didn’t need any of the apt-get craziness on wiki)
banner "Installing Eagle..."
http://web.cadsoft.de/ftp/eagle/program/7.4/eagle-mac64-7.4.0.zip
unzip eagle-mac64-7.4.0.zip
open eagle-mac64-7.4.0.pkg

request "Please complete the Eagle installer, and then press return"
read junk

#/opt/eagle-7.4.0/bin/eagle # click ok about creating the directory.

#install system-wide packages
#banner "Installing system-wide packages (this will take a while)..."
#sudo apt-get -y install python-pip libspatialindex-dev python-pygame libcgal-dev swig inkscape curl nodejs npm subversion emacs git cython python-lxml npm swig libpython-dev libxml2 libxml2-dev libxslt1-dev arduino vim
#sudo apt-get remove arduino #  It's the wrong version, but it gives us all the support libs (E.g., java)

#banner "Get latest pip"
#sudo -H pip install -U pip
#sudo -H pip install -U pip

#Install latest version of arduino:
banner "Installing latest version of Arduino..."
wget -O arduino-1.6.4-macosx.zip http://arduino.cc/download.php?f=/arduino-1.6.4-macosx.zip
unzip arduino-1.6.4-macosx.zip
mv Arduino.app /Applications/

#install Arduino

#wget -O arduino-1.6.4-linux32.tar.xz http://arduino.cc/download.php?f=/arduino-1.6.4-linux32.tar.xz
#sudo tar xf arduino-1.6.4-linux32.tar.xz -C  /usr/local/ 
#sudo ln -sf /usr/local/arduino-1.6.4/arduino /usr/local/bin/

#echo
#echo "Arduino is is going to ask you if you want be added to the dialout group.  Say yes, then exit."
#echo
#arduino  # click “add” when it asks you about the “dial up group”

banner "Installing python virtualenv..."
#install virtualenv
pip install virtualenv

#banner "Installing cgal bindings (this will take a while)..."
#sudo pip install --upgrade --no-cache-dir --force-reinstall  cgal-bindings

#install global javascript resources
banner "Installing global javascript resources..."
npm install -g bower tsd grunt grunt-cli 

#banner "Installing python packages..."
# optionally install python stuff globally.
pip install cython lxml pypng beautifulsoup4 requests svgwrite Mako clang bintrees numpy jinja2 Sphinx asciitree rtree pyparsing
#cgal-bindings

banner "Installing Google app engine..."

wget -O GoogleAppEngineLauncher-1.9.27.dmg https://storage.googleapis.com/appengine-sdks/featured/GoogleAppEngineLauncher-1.9.27.dmg
open GoogleAppEngineLauncher-1.9.27.dmg

request "Copy the app into the your Applications folder.  Press return when done"
read junk

request "Click 'yes' when Google App Engine asks about creating symlinks."

open /Applications/GoogleAppEngineLauncher.app

#request "Making github work easily (say 'yes')"
#git clone git@github.com:NVSL/gadgetron-vm-util.git
#rm -rf gadgetron-vm-util
#git clone git@github.com:NVSL/gadgetron-vm-util.git
#rm -rf gadgetron-vm-util


#mkdir ~/.ssh
if ! grep bb- ~/.ssh/config; then 
    banner Configuring ssh
    cat > ~/.ssh/config  <<EOF
Host bb-*
Port 425
Host bbfs-*
Port 425
EOF
    chmod og-rwx -R ~/.ssh
else
    banner Your ssh seems to be configured correctly for the NVSL cluster
fi

echo export USE_VENV=yes >> ~/.bashrc

banner "All done!!!"


