# Build stage
FROM ubuntu:20.04 as builder

# Install dependencies needed for building Rust projects
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    curl

WORKDIR /app

# Copy the code into the container
COPY . . 

# Accept the build argument
ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Build the Rust project
RUN cargo build --release

# Production stage
FROM ubuntu:20.04

WORKDIR /usr/local/bin

# Copy the built binary from the builder stage
COPY --from=builder /app/target/release/learn-rust .

CMD ["./learn-rust"]
