FROM ghcr.io/openclaw/openclaw:latest

USER root
COPY ./scripts/root.sh /tmp/root.sh
RUN bash /tmp/root.sh

USER node
COPY --chown=node:node ./scripts/node.sh /tmp/node.sh
RUN bash /tmp/node.sh

# Make all installed tools available to every process
# Build-time tools are in /opt/tools and /usr/local (not hidden by /home/node volume mount)
# Runtime ENVs point to /home/node so new installs persist in the volume
ENV GOPATH="/home/node/go"
ENV NPM_CONFIG_PREFIX="/home/node/.npm-global"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/opt/tools/go/bin:/usr/local/go/bin:/opt/tools/uv/bin:/home/node/go/bin:/home/node/.local/bin:/home/node/.npm-global/bin:${PATH}"

