# from your repo root
mkdir -p bin
cat > bin/run_kb_mobsuite_async_job.sh <<'EOF'
#!/bin/bash
set -euo pipefail
# Delegate to the standard SDK runner with the correct module name
exec /kb/deployment/bin/run_async_job.sh --sdk-module-name kb_mobsuite "$@"
EOF
chmod 755 bin/run_kb_mobsuite_async_job.sh
