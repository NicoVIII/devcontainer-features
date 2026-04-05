
# Gleam (via GitHub Releases) (gleam)

Gleam is a friendly language for building type-safe systems that scale!

## Example Usage

```json
"features": {
    "ghcr.io/NicoVIII/devcontainer-features/gleam:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | The version of Gleam to install. Use 'latest' to install the latest version. | string | latest |

## Customizations

### VS Code Extensions

- `gleam.gleam`

This feature installs only the gleam tool. It needs erlang to be installed in the container for it to work.
You can either use an additional feature to install erlang or install it manually. For more information on how to install erlang, please refer to the official documentation:
https://gleam.run/install/ubuntu-linux/erlang/


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
