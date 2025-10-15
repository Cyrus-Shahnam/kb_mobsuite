#!/bin/bash
# Minimal KBase SDK smoke tests for kb_mobsuite
set -euo pipefail

echo "== kb_mobsuite smoke test =="

echo "[1/3] MOB-suite CLIs present and versioned"
which mob_recon mob_typer mob_cluster
mob_recon --version
mob_typer --version
mob_cluster --version

echo "[2/3] Python Impl + KBase clients importable (no server init)"
# Ensure both module lib and installed_clients are on PYTHONPATH (like the job runner)
export PYTHONPATH="/kb/module/lib:/kb/deployment/lib:${PYTHONPATH:-}"
python - <<'PY'
import importlib
# Import Impl only; Server instantiates the Impl and needs a real config
I = importlib.import_module("kb_mobsuite.kb_mobsuiteImpl")
from installed_clients.AssemblyUtilClient import AssemblyUtil
from installed_clients.DataFileUtilClient import DataFileUtil
from installed_clients.KBaseReportClient import KBaseReport
print("Impl module OK:", I.__file__)
print("Clients OK:", AssemblyUtil, DataFileUtil, KBaseReport)
PY

echo "[3/3] All smoke tests passed."
