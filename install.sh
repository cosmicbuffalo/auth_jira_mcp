#!/usr/bin/env bash
set -euo pipefail

REPOSITORY='cosmicbuffalo/auth_jira_mcp'
INSTALL_DIR="${HOME}/.local/bin"
INSTALL_PATH="$INSTALL_DIR/auth_jira_mcp"
SOURCE_URL="https://raw.githubusercontent.com/$REPOSITORY/main/bin/auth_jira_mcp"

command -v curl >/dev/null 2>&1 || {
  echo 'Error: curl is required to install auth_jira_mcp.' >&2
  exit 1
}

mkdir -p "$INSTALL_DIR"
temporary_path=$(mktemp "$INSTALL_DIR/.auth_jira_mcp.XXXXXX")
trap 'rm -f "$temporary_path"' EXIT

curl --fail --location --silent --show-error "$SOURCE_URL" --output "$temporary_path"
bash -n "$temporary_path"
chmod 755 "$temporary_path"
mv -f "$temporary_path" "$INSTALL_PATH"
trap - EXIT

echo "Installed auth_jira_mcp to $INSTALL_PATH"
if ! command -v auth_jira_mcp >/dev/null 2>&1; then
  echo "Add $INSTALL_DIR to PATH, then open a new shell." >&2
fi
