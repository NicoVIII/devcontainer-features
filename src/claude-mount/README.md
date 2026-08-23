
# Claude config mount (claude-mount)

Bind-mounts the host's ~/.claude into the container so Claude Code skills, settings, memory and login carry over.

## Example Usage

```json
"features": {
    "ghcr.io/NicoVIII/devcontainer-features/claude-mount:0": {}
}
```



This feature bind-mounts the host's `~/.claude` to `/mnt/host-claude` and symlinks it to
`~/.claude` of the container's remote user. Everything there — skills, settings, memory **and
your login credentials** — is shared **read-write** with the host, so a Claude Code session
started in the container is already authenticated, and any state it writes (e.g. `projects/`,
`todos/`) lands in your host `~/.claude` as well.

Your host `~/.claude` **must exist**: the bind mount uses `docker --mount`, which aborts
container creation if the source path is missing. If you have never run Claude Code on the
host, create it first with `mkdir -p ~/.claude`.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
