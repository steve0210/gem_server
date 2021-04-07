#!/bin/sh

gemfile=$1
host=$2
wdir=$(pwd)
dir=$(dirname $gemfile)
verfile=$dir/.ruby-version
out=./scripts/upload/$(basename $dir).sh

if [ $(basename $gemfile) != "Gemfile" ]; then
  echo "Not a Gemfile" && exit
fi

if [ ! -f $verfile ]; then
  echo "No ruby version" && exit
fi

version=$(cat $verfile)
cache=$(rvm $version do rvm gemdir)/cache

cd $dir
gems=$(rvm $version do bundle | sed -e '/Using/!d' -e '/from/d' -e 's/Using \(.*\) \([0-9].*[0-9]\)/\1-\2/' | sort)
cd $wdir

echo "Creating upload: $out"
echo '#!/bin/sh\n' > $out
(for f in $gems; do
  if [ -f $cache/${f}.gem ]; then
    echo gem inabox $cache/${f}.gem -g $host
  else
    echo gem inabox $cache/${f}*.gem -g $host
  fi
done) >> $out
chmod +x $out
