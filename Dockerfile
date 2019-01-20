FROM lsiobase/alpine.python:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HTPCMANAGER_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
        jq && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
	cherrypy && \
 echo "**** install app ****" && \
 if [ -z ${HTPCMANAGER_COMMIT+x} ]; then \
        HTPCMANAGER_COMMIT=$(curl -sX GET https://api.github.com/repos/Hellowlol/HTPC-Manager/commits/master2 \
        | jq -r '. | .sha'); \
 fi && \
 mkdir -p /app/htpcmanager && \
 cd /app/htpcmanager && \
 git init && \
 git remote add origin https://github.com/Hellowlol/HTPC-Manager.git && \
 git fetch --depth 1 origin ${HTPCMANAGER_COMMIT} && \
 git checkout FETCH_HEAD && \
 echo "**** cleanup ****" && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8085
VOLUME /config
