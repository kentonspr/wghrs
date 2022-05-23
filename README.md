# wghrs

This is a simple HTTP server to return the output of `systemctl is-actice wg-quick@wg0`. It is meant to be used in a GCP Instance Group/AWS Automatic Scaling Group where a health check is required. This allows you to use a scaling group size of one and ensure your instance is always redeployed from an image if there is a problem.

## Compile Binary

This is a Rust program and requires Rust build tools - https://www.rust-lang.org/tools/install

When you have a Rust environment in place, navigate to the repo root and build a release version with cargo - 

```
cargo build --release
```

## Build `.deb` Package

Repo includes everything needed to build a `.deb` file for installation to Debian/Ubuntu systems. Run the `builddeb.sh` script - 

```
build/builddeb.sh
```

When the build is complete, a `wghrs.deb` file should be in your working directory. This can be installed with apt or uploaded to a repo for later installation.

## Configuration

When installed from the `.deb` package, a default configuration is placed at `/etc/wghrs/config.toml`. The server is built using Rocket. Its config options can be found here - https://rocket.rs/v0.5-rc/guide/configuration/

The default is to listen on all interfaces, `0.0.0.0`, and on port `8000`
