# =============================================================================
# Wakaama DUT Client — Docker Image
# =============================================================================
# Builds the wakaama lwm2mclient binary for use as a DUT in the Op IoT Journey
# test harness. Supports both NoSec and DTLS (TinyDTLS) builds.
#
# The root CMakeLists.txt only builds tests. The actual client examples are in
# examples/client/udp/ (NoSec) and examples/client/tinydtls/ (DTLS).
#
# Usage:
#   docker build -f deploy/Dockerfile -t op-iot-dut:wakaama .
#   docker run --rm op-iot-dut:wakaama

# ---- Build stage ------------------------------------------------------------
FROM ubuntu:24.04 AS build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        git \
        pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

# Build the UDP (NoSec) client from examples/client/udp/
RUN rm -rf build-dut && \
    cmake -S examples/client/udp -B build-dut \
      -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DWAKAAMA_UNIT_TESTS=OFF && \
    cmake --build build-dut --target lwm2mclient -j"$(nproc)"

# Build the TinyDTLS (DTLS) client from examples/client/tinydtls/
RUN rm -rf build-tinydtls && \
    cmake -S examples/client/tinydtls -B build-tinydtls \
      -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DWAKAAMA_UNIT_TESTS=OFF && \
    cmake --build build-tinydtls --target lwm2mclient_tinydtls -j"$(nproc)"

# ---- Runtime stage -----------------------------------------------------------
FROM ubuntu:24.04 AS runtime

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /src/build-dut/lwm2mclient /app/lwm2mclient
COPY --from=build /src/build-tinydtls/lwm2mclient_tinydtls /app/lwm2mclient_tinydtls
COPY deploy/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Environment variables:
#   LWM2M_SERVER   — full server URI (e.g. coap://host:5683) — parsed for -h/-p
#   LWM2M_ENDPOINT — endpoint name (default: wakaama-dut-01)
#   LWM2M_LOCAL_PORT — local UDP port (default: 56830)
#   LWM2M_LIFETIME — registration lifetime in seconds (default: 300)
#   LWM2M_DTLS     — set to "1" to use the TinyDTLS build
ENTRYPOINT ["/app/entrypoint.sh"]
