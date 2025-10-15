#!/bin/bash
set -euo pipefail

# Tell the async runner our module name (belt + suspenders)
export KB_SDK_MODULE_NAME="kb_mobsuite"
export SDK_MODULE_NAME="kb_mobsuite"

# Ensure both module code and KBase-installed clients are importable
export PYTHONPATH="/kb/module/lib:/kb/deployment/lib:${PYTHONPATH:-}"

# Hand off to the standard SDK async runner
exec /kb/deployment/bin/run_async_job.sh --sdk-module-name kb_mobsuite "$@"
