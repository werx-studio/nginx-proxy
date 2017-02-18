FROM benhall/nginx-sticky:1.11.10

# Install curl and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
     ca-certificates \
     curl \
     && apt-get clean \
     && rm -r /var/lib/apt/lists/*

# Install Forego
RUN curl -L https://github.com/jwilder/forego/releases/download/v0.16.1/forego -o /usr/local/bin/forego \
  && chmod u+x /usr/local/bin/forego

ENV DOCKER_GEN_VERSION 0.7.3

RUN curl -L https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz -o /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
  && tar -C /usr/local/bin -xvf /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
  && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY . /app/
COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
