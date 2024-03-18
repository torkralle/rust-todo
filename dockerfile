FROM rust:1.76 AS builder

WORKDIR /todo

COPY Cargo.toml Cargo.toml
RUN mkdir src
RUN echo "fn main(){}" > src/main.rs
RUN cargo build --release
COPY ./src ./src
COPY ./templates ./templates
RUN rm -f target/release/deps/todo*
RUN cargo build --release

FROM debian:latest
WORKDIR /todo
COPY --from=builder /todo/target/release/todo .
COPY --from=builder /lib/aarch64-linux-gnu/libc.so.6 /lib/aarch64-linux-gnu/libc.so.6
EXPOSE 8080
ENTRYPOINT [ "./todo" ]