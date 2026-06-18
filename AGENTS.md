# AGENTS.md - Actual Budget MCP Server Home Assistant Add-on

## Project Overview

Home Assistant add-on wrapping the [actual-mcp](https://github.com/s-stefanov/actual-mcp) server to run it as a persistent service with SSE/HTTP transport inside Home Assistant.

## Project Structure

```
actual-mcp-HA-app/
├── README.md              # User-facing documentation
├── AGENTS.md              # This file - development guidelines
├── repository.yaml        # HA add-on store repository metadata
└── actual-mcp/            # Add-on directory
    ├── config.yaml        # Add-on configuration and schema
    ├── Dockerfile         # Build from upstream Docker image
    ├── run.sh             # Entrypoint script (bashio integration)
    └── translations/
        └── en.yaml        # UI label translations
```

## Development Guidelines

### Add-on Configuration

- **config.yaml** defines all user-configurable options via the HA UI
- Schema types: `str`, `password`, `bool`, `list(val1|val2|val3)`, `int`, `float`
- Optional fields use `?` suffix (e.g., `actual_budget_sync_id: str?`)
- Default values go in `options:` block

### Entrypoint Script (run.sh)

- Uses `bashio` for accessing add-on configuration
- `bashio::config 'key'` - get config value
- `bashio::config.true 'key'` - check boolean
- `bashio::log.info/warning/error` - log messages
- All config values are strings; empty string means unset
- Must `export` environment variables for the Node.js process
- Use `exec` for the final command to replace the shell process

### Dockerfile

- Builds FROM the upstream `sstefanov/actual-mcp:latest` image
- Installs `bashio` via apk (Alpine package manager)
- Copies and makes `run.sh` executable
- Keep it minimal - upstream image handles Node.js and actual-mcp

### Testing

- No automated tests in this add-on project
- Test by installing in Home Assistant and checking logs
- Verify endpoints with: `curl -H "Authorization: Bearer <token>" http://<ha-host>:3000/sse`

### Versioning

- Add-on version in `config.yaml` should track upstream actual-mcp version
- Format: `"X.Y.Z"` (quoted string, not number)
- Update when upstream releases new features or bug fixes

### Security

- Bearer token is mandatory for production use
- `ACTUAL_PASSWORD` uses `password` schema type (masked in UI)
- Never log sensitive values (passwords, tokens)
- Data directory (`/share/actual-mcp`) is isolated within HA

## HA MCP Integration Notes

- HA's MCP integration uses **Streamable HTTP** transport
- Connect add-on to HA via: `http://a0d7b954-actual-mcp:3000/mcp` or `http://localhost:3000/mcp`
- Bearer token must match between add-on config and HA MCP integration
- SSE endpoint (`/sse`) also works for clients that prefer SSE transport

## Release Process

1. Update `version` in `config.yaml`
2. Update `README.md` if configuration options changed
3. Commit and push to the repository
4. Users see update in HA Add-on Store
