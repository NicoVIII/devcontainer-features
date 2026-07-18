This feature bind-mounts the host's `~/.claude` to `/mnt/host-claude` and symlinks it to
`~/.claude` of the container's remote user. Everything under `~/.claude` — skills, settings,
memory **and your login credentials** — is therefore shared **read-write** with the host.

Because the login is shared, a Claude Code session started inside the container is already
authenticated. Any session state the container writes (e.g. `projects/`, `todos/`) lands in
your host `~/.claude` as well; `projects/` is keyed by working-directory path, so container
paths produce additional entries next to your host ones.

The mount source is your host `~/.claude`. If it does not exist, the container runtime creates
an empty directory in its place.
