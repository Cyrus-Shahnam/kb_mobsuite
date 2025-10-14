FROM kbase/sdkpython:3.8.10
LABEL maintainer="ac.shahnam"

# Use bash for RUN steps
SHELL ["/bin/bash", "-lc"]

# --- Conda bootstrap (install if missing; no apt) ---
ENV CONDA_DIR=/opt/conda
ENV PATH=${CONDA_DIR}/bin:$PATH
RUN if ! command -v conda >/dev/null 2>&1; then \
      python -c "import urllib.request as u; u.urlretrieve('https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh','/tmp/mambaforge.sh')"; \
      bash /tmp/mambaforge.sh -b -p ${CONDA_DIR}; \
      rm -f /tmp/mambaforge.sh; \
    fi

# Channels + install mamba (tiny solve), then use mamba for everything else (fast)
RUN conda config --add channels conda-forge \
 && conda config --add channels bioconda \
 && conda config --set channel_priority flexible \
 && conda install -y -c conda-forge 'mamba>=1.5' \
 && conda clean --all -y

# Core tools (minimal pins to avoid backtracking); mamba = fast solver
RUN mamba install -y -c conda-forge -c bioconda \
      python=3.8 \
      mob_suite=3.1.9 \
      'blast>=2.13' \
      'mash>=2.3' \
      curl \
      ca-certificates \
      bzip2 \
      pigz \
      procps-ng \
  && mamba clean -a -y

# (Optional) If you need pandas/biopython explicitly for your HTML rendering,
# pull them *after* the core solve to reduce conflicts:
RUN mamba install -y -c conda-forge -c bioconda \
      pandas \
      biopython \
  && mamba clean -a -y

# Fixed (optional) DB location for MOB-suite
ENV MOB_DB_DIR=/opt/mob_db
RUN mkdir -p "${MOB_DB_DIR}"
 
# KBase module payload
WORKDIR /kb/module
COPY . /kb/module

# Python runtime niceties
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
