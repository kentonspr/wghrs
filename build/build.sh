CWD="$(pwd)"

# https://stackoverflow.com/a/4774063
# Change directory into the directory where this script resides
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH

RANDO="$(echo $RANDOM | md5sum | head -c 20; echo;)"

mkdir -p /tmp/wghrs-$RANDO/usr/local/sbin
mkdir -p /tmp/wghrs-$RANDO/etc/wghrs
mkdir -p /tmp/wghrs-$RANDO/etc/systemd/system

cp ../target/release/wghrs /tmp/wghrs-$RANDO/usr/local/sbin/
cp ../files/default-config.toml /tmp/wghrs-$RANDO/etc/wghrs/default-config.toml
cp ../files/wghrs.service /tmp/wghrs-$RANDO/etc/systemd/system/
cp -r ../DEBIAN /tmp/wghrs-$RANDO/

dpkg-deb --build /tmp/wghrs-$RANDO

mv /tmp/wghrs-$RANDO.deb $CWD/wghrs.deb
rm -rf /tmp/wghrs-$RANDO
