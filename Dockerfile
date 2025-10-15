FROM kbase/sdkpython:3.8.10
LABEL maintainer="ac.shahnam"

SHELL ["/bin/bash", "-lc"]

# --- Conda bootstrap (sdkpython already has conda, but keep this guard) ---
ENV CONDA_DIR=/opt/conda
ENV PATH=${CONDA_DIR}/bin:$PATH
RUN if ! command -v conda >/dev/null 2>&1; then \
      python -c "import urllib.request as u; u.urlretrieve('https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh','/tmp/mambaforge.sh')" && \
      bash /tmp/mambaforge.sh -b -p "${CONDA_DIR}" && \
      rm -f /tmp/mambaforge.sh; \
    fi

# Channels and fast solver
RUN conda config --add channels conda-forge \
 && conda config --add channels bioconda \
 && conda config --set channel_priority flexible \
 && conda install -y -c conda-forge 'mamba>=1.5' \
 && conda clean --all -y

# Core tools (single transaction keeps it consistent)
RUN mamba install -y -c conda-forge -c bioconda \
      mob_suite=3.1.9 \
      'blast>=2.13' \
      'mash>=2.3' \
      curl \
      ca-certificates \
      bzip2 \
      pigz \
      procps-ng \
      pandas \
      biopython \
  && mamba clean -a -y

# Fixed DB location (empty at build time; populate at runtime if needed)
ENV MOB_DB_DIR=/opt/mob_db
RUN mkdir -p "${MOB_DB_DIR}"

# KBase module payload
WORKDIR /kb/module
COPY . /kb/module

# Ensure launchers are executable and Python can import the module
RUN chmod +x /kb/module/bin/*.sh /kb/module/scripts/*.sh || true
ENV PYTHONPATH=/kb/module/lib:$PYTHONPATH

# Python runtime niceties
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Make sure files and entrypoint are usable
RUN mkdir -p /kb/module/work \
 && chmod -R a+rw /kb/module \
 && if [ -f /kb/module/scripts/entrypoint.sh ]; then chmod +x /kb/module/scripts/entrypoint.sh; fi

ENTRYPOINT ["/kb/module/scripts/entrypoint.sh"]
CMD []
