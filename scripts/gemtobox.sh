#!/bin/sh

gemfile=$1
host=$2
wdir=$(pwd)
out=./scripts/upload.sh

if [ $(basename $gemfile) != "Gemfile" ]; then
  echo "Not a Gemfile" && exit
fi

dir=$(dirname $gemfile)
verfile=$dir/.ruby-version
if [ ! -f $verfile ]; then
  echo "No ruby version" && exit
fi

version=$(cat $verfile)
cache=$(rvm $version do rvm gemdir)/cache

cd $dir
gems=$(rvm $version do bundle | sed -e '/Using/!d' -e '/from/d' -e 's/Using \(.*\) \([0-9].*[0-9]\)/\1-\2/' | sort)
cd $wdir
(for f in $gems; do
  echo gem inabox $cache/${f}*.gem -g $host
done) > $out
chmod +x $out
