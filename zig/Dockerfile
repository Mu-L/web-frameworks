FROM debian:12-slim AS build

# Set a non-root user for added security
RUN useradd -m ziguser

# Install dependencies (update to latest secure versions)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget xz-utils \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download the latest stable Zig binary from the official website
ARG ZIG_VERSION=0.13.0
RUN wget https://ziglang.org/download/0.13.0/zig-linux-{{arch}}-0.13.0.tar.xz

RUN tar -xvf zig-linux-{{arch}}-0.13.0.tar.xz

RUN mv zig-linux-{{arch}}-0.13.0 /usr/local/zig 

# Add Zig to the PATH
ENV PATH="/usr/local/zig:$PATH"

WORKDIR /home/ziguser

{{#files}}
COPY '{{source}}' '{{target}}'
RUN chown ziguser {{target}}
{{/files}}
RUN chown -R ziguser src

# Switch to the non-root user
USER ziguser

RUN zig build -Doptimize=ReleaseFast

FROM debian:12-slim

RUN apt-get -qq update 
RUN apt-get -qy install ca-certificates curl

COPY --from=build /app/zig-out/bin/httpz /server

ENTRYPOINT {{command}}

HEALTHCHECK CMD curl --fail http://0.0.0.0:3000 || exit
