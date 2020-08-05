FROM debian:latest as builder

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG MAPPER_VERSION=20180224.0
WORKDIR /app
RUN wget https://github.com/wangyu-/tinyPortMapper/releases/download/$MAPPER_VERSION/tinymapper_binaries.tar.gz \
  && tar -xzvf tinymapper_binaries.tar.gz


FROM debian:stable-slim

COPY --from=builder /app/tinymapper_amd64 /usr/local/bin
RUN chmod +x /usr/local/bin/tinymapper_amd64

ENV LOCAL_ADDR 0.0.0.0:4097
ENV REMOTE_ADDR 127.0.0.1:4096
ENV ARGS -t -u
ENV SOCKET_BUF 10240
ENV LOG_LEVEL 3

CMD exec tinymapper_amd64 \
    $ARGS \
    -l $LOCAL_ADDR \
    -r $REMOTE_ADDR \
    --sock-buf $SOCKET_BUF \
    --log-level $LOG_LEVEL
