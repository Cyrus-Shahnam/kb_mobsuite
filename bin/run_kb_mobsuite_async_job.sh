#!/bin/bash
# Minimal module-specific async launcher (matches kb_blast style)

set -e

script_dir="$(dirname "$(readlink -f "$0")")"

# Make sure our module and the KBase-installed clients are importable
# - ../lib: your module code (kb_mobsuite/)
# - /kb/deployment/lib: installed_clients/*
export PYTHONPATH="${script_dir}/../lib:/kb/deployment/lib:${PYTHONPATH:-}"

# Hand control to the generated server
# Pass through all args from the platform
exec python -u "${script_dir}/../lib/kb_mobsuite/kb_mobsuiteServer.py" "$@"
