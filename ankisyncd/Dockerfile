ARG ANKISYNCD_ROOT=/opt/ankisyncd
ARG ANKISYNCD_DATA_ROOT=/srv/ankisyncd
ARG PYTHONUSERBASE=/opt/venv

# -- BUILD --
FROM python:3.9-buster AS build-env
ARG ANKISYNCD_ROOT
ARG ANKISYNCD_DATA_ROOT
ARG PYTHONUSERBASE

RUN mkdir -p ${ANKISYNCD_ROOT}
WORKDIR ${ANKISYNCD_ROOT}

COPY bin/download-release.sh ./bin/download-release.sh

RUN mkdir -p ${ANKISYNCD_DATA_ROOT}

RUN sh ./bin/download-release.sh && \
    pip3 install --upgrade pip && \
    pip3 install --user -r ./release/requirements.txt
WORKDIR /src

# -- PROD --
FROM python:3.9-slim-buster
ARG ANKISYNCD_ROOT
ARG ANKISYNCD_DATA_ROOT
ARG PYTHONUSERBASE

# Copy Python dependencies
ENV PYTHONUSERBASE=${PYTHONUSERBASE}
COPY --from=build-env ${PYTHONUSERBASE} ${PYTHONUSERBASE}

# Copy Anki Sync Server release and scripts
COPY --from=build-env ${ANKISYNCD_ROOT}/release ${ANKISYNCD_ROOT}
WORKDIR ${ANKISYNCD_ROOT}

# Create data volume.
COPY --from=build-env ${ANKISYNCD_DATA_ROOT} ${ANKISYNCD_DATA_ROOT}
VOLUME ${ANKISYNCD_DATA_ROOT}

# Set default environment variables.
ARG ANKISYNCD_PORT=27701
ARG ANKISYNCD_BASE_URL=/sync/
ARG ANKISYNCD_BASE_MEDIA_URL=/msync/
ARG ANKISYNCD_AUTH_DB_PATH=${ANKISYNCD_DATA_ROOT}/auth.db

ARG ANKISYNCD_SESSION_DB_PATH=${ANKISYNCD_DATA_ROOT}/session.db
ENV ANKISYNCD_HOST=0.0.0.0 \
    ANKISYNCD_PORT=${ANKISYNCD_PORT} \
    ANKISYNCD_DATA_ROOT=${ANKISYNCD_DATA_ROOT} \
    ANKISYNCD_BASE_URL=${ANKISYNCD_BASE_URL} \
    ANKISYNCD_BASE_MEDIA_URL=${ANKISYNCD_BASE_MEDIA_URL} \
    ANKISYNCD_AUTH_DB_PATH=${ANKISYNCD_AUTH_DB_PATH} \
    ANKISYNCD_SESSION_DB_PATH=${ANKISYNCD_SESSION_DB_PATH}

COPY bin/entrypoint.sh ./bin/entrypoint.sh

EXPOSE ${ANKISYNCD_PORT}

CMD ["/bin/sh", "./bin/entrypoint.sh"]

# Copy ankisyncctl to root if it exists
# COPY *./ankisyncd_cli/ankisyncctl.py .

# Healthcheck using script
COPY bin/healthcheck.py ./bin/healthcheck.py
HEALTHCHECK --interval=60s --timeout=3s CMD python ./bin/healthcheck.py
