#!/bin/sh
#
# Pull and build a ruby install
#

# ensure the basic path is there....
PATH=/bin:/usr/bin:/usr/local/bin:$PATH
export PATH

ruby_version=$1
if [ "X${ruby_version}" = "X" ]
then
    ruby_version='1.9.3-p327'
fi

# lets see if its already installed
if [ -x /usr/local/bin/ruby ]
then
    installed_version=`/usr/local/bin/ruby --version|awk '{print $2}'`
    compared_version=`echo ${ruby_version} | tr -d -`
    if [ "${installed_version}" = "${compared_version}" ]
    then
        exit 0
    fi
fi

BUILD_DIR=`mktemp --directory --tmpdir`

cd ${BUILD_DIR} || exit 2

ruby_base_version=`echo ${ruby_version} | awk -F. '{printf "%d.%d\n",$1,$2}'`

wget http://ftp.ruby-lang.org/pub/ruby/${ruby_base_version}/ruby-${ruby_version}.tar.gz
tar xfvz ruby-${ruby_version}.tar.gz
cd ruby-${ruby_version}
./configure
make
make install

# install the gem bundler
gem install bundler

cd /
rm -rf ${BUILD_DIR}