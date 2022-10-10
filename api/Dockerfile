FROM rust:1-slim AS BUILDER
WORKDIR /src/

RUN rustup set profile minimal && \
    rustup toolchain install nightly --target x86_64-unknown-linux-musl

RUN apt update && apt install -y \
    musl-dev \
    musl-tools \
    protobuf-compiler

COPY ./proto /src/proto/
COPY ./tactibetter /src/tactibetter/
COPY ./Cargo.toml /src/

RUN cargo +nightly -Z sparse-registry build --target x86_64-unknown-linux-musl --release

FROM alpine
RUN apk add --no-cache ca-certificates
RUN adduser tactibetter -s /bin/false -D -H
EXPOSE 8080

COPY --from=BUILDER /src/target/x86_64-unknown-linux-musl/release/tactibetter /usr/local/bin/tactibetter
RUN chmod a+rx /usr/local/bin/*

USER tactibetter
WORKDIR /usr/local/bin
ENTRYPOINT [ "/usr/local/bin/tactibetter" ]