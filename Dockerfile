FROM benhall/nginx-sticky:1.11.9
MAINTAINER Jason Wilder mail@jasonwilder.com

# Install wget and install/updates certificates
RUN apk add --no-cache --virtual .run-deps \
    ca-certificates bash wget \
    && update-ca-certificates

# Configure Nginx and apply fix for very long server names
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
 && sed -i 's/^http {/&\n    server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf

# Install Forego
ADD https://github.com/jwilder/forego/releases/download/v0.16.1/forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego

ENV DOCKER_GEN_VERSION 0.7.3

RUN wget --quiet https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY . /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
