mkdir -p /tmp/wg-health/usr/local/sbin
mkdir -p /tmp/wg-health/etc/wg-health
mkdir -p /tmp/wg-health/etc/systemd/system

cp ./wg-health/target/release/wg-health /tmp/wg-health/usr/local/sbin/
cp ./wg-health/files/Rocket.toml /tmp/wg-health/etc/wg-health/
cp ./wg-health/files/wg-health.service /tmp/wg-health/etc/systemd/system/
cp -r ./wg-health/DEBIAN /tmp/wg-health/

dpkg-deb --build /tmp/wg-health
