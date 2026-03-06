FROM ghcr.io/openclaw/openclaw:latest

USER root
COPY ./scripts/root.sh /tmp/root.sh
RUN bash /tmp/root.sh && rm /tmp/root.sh

USER node
COPY --chown=node:node ./scripts/node.sh /tmp/node.sh
RUN bash /tmp/node.sh && rm /tmp/node.sh

