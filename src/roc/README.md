
# Roc (nightly, via GitHub Releases) (roc)

Roc is a fast, friendly, functional language.

## Example Usage

```json
"features": {
    "ghcr.io/NicoVIII/devcontainer-features/roc:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | The nightly of Roc to install, given as '<date>-<commit>' (the release tag without its 'nightly-' prefix). Use 'latest' to install the most recent nightly. | string | latest |

Roc has no stable release yet: this feature installs nightly builds of the new compiler from
[roc-lang/nightlies][nightlies], the channel roc-lang.org's own installer uses. The alpha
releases in `roc-lang/roc` come from the previous compiler and are not installed.

There is no semantic versioning, so `version` takes a nightly identifier of the form
`<date>-<commit>`, e.g. `2026-08-22-db56022` — the release tag without its `nightly-` prefix,
though the full tag works too. Nightlies older than **2026-08-06** cannot be installed.

`latest` takes whatever was published most recently, so a rebuild can bring a different
compiler and Roc's syntax is still changing; pin a nightly for reproducible builds. The
compiler is a single static binary needing no extra packages, but adds ~200 MB to the image.

[nightlies]: https://github.com/roc-lang/nightlies/releases


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
