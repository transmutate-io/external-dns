# builder image
FROM golang:1.12.9-alpine3.10 as builder

ENV VERSION "v0.5.16"

RUN mkdir -p /src/external-dns && \
   cd /src/external-dns && \
   apk add git bzr make && \
   git clone https://github.com/kubernetes-incubator/external-dns.git . && \
   git checkout ${VERSION} && \
   make

# final image
FROM alpine:3.10.0

RUN apk add ca-certificates

COPY --from=builder /src/external-dns/build/external-dns /external-dns

ENTRYPOINT ["/external-dns"]
