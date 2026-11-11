The default is pinned to `0.5.0` rather than `latest`: the latest upstream release, v0.5.1,
was published without any downloadable files, so `latest` fails until upstream uploads them.

On arm64 no release installs yet: up to v0.5.0 the `linux-aarch64` archives contain x86_64
binaries (fixed upstream in v0.5.1), so the install fails with an exec format error.
