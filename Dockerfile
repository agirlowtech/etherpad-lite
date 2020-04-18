# Etherpad Lite Dockerfile
#
# https://github.com/ether/etherpad-lite
#
# Author: muxator

FROM node:10-buster-slim
LABEL maintainer="Etherpad team, https://github.com/ether/etherpad-lite"

# plugins to install while building the container. By default no plugins are
# installed.
# If given a value, it has to be a space-separated, quoted list of plugin names.
#
# EXAMPLE:
#   ETHERPAD_PLUGINS="ep_codepad ep_author_neat"
ARG ETHERPAD_PLUGINS=

# Set the following to production to avoid installing devDeps
# this can be done with build args (and is mandatory to build ARM version)
ENV NODE_ENV=development

RUN mkdir /opt/etherpad-lite

WORKDIR /opt/etherpad-lite

COPY ./ ./

# phantomJS deps
RUN apt udpate && apt install -y bzip2

# install node dependencies for Etherpad
RUN bin/installDeps.sh && \
	rm -rf ~/.npm/_cacache

# Install the plugins, if ETHERPAD_PLUGINS is not empty.
#
# Bash trick: in the for loop ${ETHERPAD_PLUGINS} is NOT quoted, in order to be
# able to split at spaces.
RUN for PLUGIN_NAME in ${ETHERPAD_PLUGINS}; do npm install "${PLUGIN_NAME}"; done

# Copy the configuration file.
COPY ./settings.json.docker /opt/etherpad-lite/settings.json

EXPOSE 9001
CMD ["node", "node_modules/ep_etherpad-lite/node/server.js"]
