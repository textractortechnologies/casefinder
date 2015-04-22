FROM progrium/buildstep
MAINTAINER Michael Gurley <michaeljamesgurley@gmail.com>

# See https://github.com/docker/docker/issues/6345#issuecomment-49245365
RUN ln -s -f /bin/true /usr/bin/chfn

ADD files/exec-wrapper /exec-wrapper
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ONBUILD ADD . /app
ONBUILD RUN /build/builder

# Set and expose default port
ENV PORT 3000
EXPOSE 3000

ENTRYPOINT ["/exec-wrapper"]