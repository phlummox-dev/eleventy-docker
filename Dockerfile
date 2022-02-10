
FROM node:16.10.0-alpine3.14@sha256:4348589598e18251212266117f1b0af23ed3549bbf9392bbde8e2b1d1101f399

RUN \
  apk add \
    tidyhtml \
    tidyhtml-dev \
  && \
  npm config set prefix ~/.local && \
  npm config set unsafe-perm true && \
  npm install -g npm@latest

# not sure if last command is needed -- fixes
# probs like this:
# - https://stackoverflow.com/questions/55926705/docker-error-eacces-permission-denied-mkdir-project-node-modules-cache
# see https://geedew.com/What-does-unsafe-perm-in-npm-actually-do/

ENV HOME=/root
ENV PATH=$HOME/.local/bin:$PATH

ARG PACKAGE_DIR=/opt/site

WORKDIR $PACKAGE_DIR

COPY eleventy.sh package.json package-lock.json ./

RUN \
  chmod a+rx eleventy.sh && \
  npm install && \
  npm link

WORKDIR /app
