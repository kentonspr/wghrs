CWD="$(dirname $(pwd))"

# https://stackoverflow.com/a/4774063
# Change directory into the directory where this script resides
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH

TIME="$(date +"%Y-%m-%dT%H:%M:%S%Z")"

mkdir -p /tmp/wghrs-$TIME/usr/local/sbin
mkdir -p /tmp/wghrs-$TIME/etc/wg-health
mkdir -p /tmp/wghrs-$TIME/etc/systemd/system

cp ../target/release/wghrs /tmp/wghrs-$TIME/usr/local/sbin/
cp ../files/Rocket.toml /tmp/wghrs-$TIME/etc/wghrs/
cp ../files/wghrs.service /tmp/wghrs-$TIME/etc/systemd/system/
cp -r ../DEBIAN /tmp/wghrs-$TIME/

dpkg-deb --build /tmp/wghrs-$TIME

mv /tmp/wghrs.deb $CWD
rm -rf /tmp/wghrs-$TIME
