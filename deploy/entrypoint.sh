#!/bin/bash
# Entrypoint wrapper for wakaama lwm2mclient.
# Translates LWM2M_SERVER / LWM2M_ENDPOINT env vars into the CLI flags
# that lwm2mclient expects: -h HOST -p PORT -n NAME -l LOCAL_PORT -t LIFETIME -4
set -e

# Defaults
ENDPOINT="${LWM2M_ENDPOINT:-wakaama-dut-01}"
LOCAL_PORT="${LWM2M_LOCAL_PORT:-56830}"
LIFETIME="${LWM2M_LIFETIME:-300}"
SERVER_URI="${LWM2M_SERVER:-coap://adv-lwm2m-server:5683}"

# Parse coap://host:port from the URI
# Strip scheme prefix
HOSTPORT="${SERVER_URI#coap://}"
HOSTPORT="${HOSTPORT#coaps://}"
# Split host and port
HOST="${HOSTPORT%%:*}"
PORT="${HOSTPORT##*:}"
# If no port was specified, default to 5683
if [ "$HOST" = "$PORT" ]; then
    PORT=5683
fi

# Select binary
if [ "${LWM2M_DTLS:-0}" = "1" ]; then
    BINARY=/app/lwm2mclient_tinydtls
else
    BINARY=/app/lwm2mclient
fi

echo "[wakaama-dut] Starting ${BINARY}"
echo "[wakaama-dut]   endpoint=${ENDPOINT} server=${HOST}:${PORT} local_port=${LOCAL_PORT} lifetime=${LIFETIME}"

exec "$BINARY" \
    -n "$ENDPOINT" \
    -h "$HOST" \
    -p "$PORT" \
    -l "$LOCAL_PORT" \
    -t "$LIFETIME" \
    -4
