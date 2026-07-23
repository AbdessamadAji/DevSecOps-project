FROM alpine:3.22

RUN apk add --no-cache \
    postgresql17-client \
    curl \
    ca-certificates

RUN curl -fsSL https://dl.min.io/client/mc/release/linux-amd64/mc \
    -o /usr/local/bin/mc \
    && chmod +x /usr/local/bin/mc

COPY backup.sh /usr/local/bin/backup.sh

RUN chmod +x /usr/local/bin/backup.sh

WORKDIR /workspace

CMD ["/usr/local/bin/backup.sh"]
