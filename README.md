# auth_jira_mcp

A small terminal helper for authenticating the Atlassian Jira MCP server through
[`mcp-remote`](https://www.npmjs.com/package/mcp-remote).

It removes stale `mcp-remote` processes and callback-port listeners, starts a
fresh OAuth flow, copies the authorization URL when one is required, and exits
once authentication succeeds.

## Why

Atlassian MCP authentication can expire or otherwise require re-authorization
fairly often. This tool streamlines that repetitive process by clearing stale
callback state, guiding you through OAuth, and handling the authorization URL
and completion check in one command.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/cosmicbuffalo/auth_jira_mcp/main/install.sh | bash
```

The installer places the command in `~/.local/bin`. Ensure that directory is on
your `PATH`.

## Usage

```sh
auth_jira_mcp
```

The helper uses callback port `64887` and connects to
`https://mcp.atlassian.com/v1/sse`.

### Running over SSH

The browser authorization redirects to `localhost:64887`. If you run the helper
on a remote machine over SSH, forward that port before starting it:

```sh
ssh -L 64887:localhost:64887 user@remote-host
```

Run `auth_jira_mcp` in that SSH session, then open the authorization URL in a
browser on your local machine.

Controls while it runs:

- `c` copies the authorization URL again, when authorization is needed.
- `i` toggles the underlying `mcp-remote` output for troubleshooting.
- `Ctrl-C` cancels the helper.

## Requirements

- Bash 4+
- Node.js and `npx`
- `lsof`, `pkill`, `tail`, and `base64`

Clipboard support is optional. The helper tries `xsel`, `xclip`, `wl-copy`, and
`pbcopy`, then falls back to OSC52 terminal clipboard sequences.

## What it changes

Before beginning a sign-in, the helper terminates processes listening on TCP port
`64887` and matching Atlassian `mcp-remote` processes. It also ends the temporary
`mcp-remote` process after authentication is complete.

## Updating

Re-run the install command. The installation is a single executable at
`~/.local/bin/auth_jira_mcp`.
