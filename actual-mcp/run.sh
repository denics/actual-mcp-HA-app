#!/usr/bin/with-contenv bashio

set -e

ARGS="--sse --port 3000"

if bashio::config.true 'enable_write'; then
  ARGS="$ARGS --enable-write"
  bashio::log.info "Write tools enabled"
fi

BEARER_TOKEN_VAL="$(bashio::config 'bearer_token')"
if [ -n "$BEARER_TOKEN_VAL" ]; then
  ARGS="$ARGS --enable-bearer"
  export BEARER_TOKEN="$BEARER_TOKEN_VAL"
  bashio::log.info "Bearer authentication enabled"
else
  bashio::log.warning "Bearer token not set - MCP endpoints will be public"
fi

ACTUAL_SERVER_URL_VAL="$(bashio::config 'actual_server_url')"
if [ -n "$ACTUAL_SERVER_URL_VAL" ]; then
  export ACTUAL_SERVER_URL="$ACTUAL_SERVER_URL_VAL"
  bashio::log.info "Actual server URL configured"
else
  bashio::log.warning "ACTUAL_SERVER_URL not set - using local data directory"
fi

export ACTUAL_PASSWORD="$(bashio::config 'actual_password')"
if [ -z "$ACTUAL_PASSWORD" ]; then
  bashio::log.error "ACTUAL_PASSWORD is required when using a remote server"
  exit 1
fi

SYNC_ID="$(bashio::config 'actual_budget_sync_id')"
if [ -n "$SYNC_ID" ]; then
  export ACTUAL_BUDGET_SYNC_ID="$SYNC_ID"
  bashio::log.info "Budget sync ID set to: $SYNC_ID"
fi

export ACTUAL_DATA_DIR="/share/actual-mcp"
mkdir -p "$ACTUAL_DATA_DIR"

bashio::log.info "Starting Actual Budget MCP Server on port 3000..."
bashio::log.info "SSE endpoint: http://<ha-host>:3000/sse"
bashio::log.info "Streamable HTTP endpoint: http://<ha-host>:3000/mcp"

exec node build/index.js $ARGS
