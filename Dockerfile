# Dockerfile
FROM quay.io/aptible/autobuild
RUN apt-get -y install default-jdk
RUN apt-get -y install imagemagick