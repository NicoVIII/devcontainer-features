
# Scrut (via GitHub Releases) (scrut)

Scrut is a testing toolkit for CLI applications, with tests written in Markdown or Cram.

## Example Usage

```json
"features": {
    "ghcr.io/NicoVIII/devcontainer-features/scrut:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | The version of Scrut to install. Use 'latest' to install the latest version. | string | 0.5.0 |

The default is pinned to `0.5.0` rather than `latest`: the latest upstream release, v0.5.1,
was published without any downloadable files, so `latest` fails until upstream uploads them.

On arm64 no release installs yet: up to v0.5.0 the `linux-aarch64` archives contain x86_64
binaries (fixed upstream in v0.5.1), so the install fails with an exec format error.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
