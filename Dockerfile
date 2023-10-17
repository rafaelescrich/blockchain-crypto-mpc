FROM ubuntu:18.04 as builder

# Disable interactive mode in apt-get to prevent prompts during build
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential make gcc g++ openssl libssl-dev openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /usr/src/blockchain-crypto-mpc
COPY . .
RUN make test
RUN make

# Copy library to clean image
FROM alpine:latest

COPY --from=builder ./usr/src/blockchain-crypto-mpc/libmpc_crypto.so ./usr/lib/