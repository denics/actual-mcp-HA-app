# Actual Budget MCP Server - Home Assistant Add-on

Home Assistant add-on for running the [Actual Budget MCP Server](https://github.com/s-stefanov/actual-mcp) as a persistent service with SSE/HTTP transport.

## What This Does

This add-on runs the Actual Budget MCP server inside Home Assistant, exposing your financial data to AI assistants through the Model Context Protocol. It supports:

- **SSE Transport**: Connect via `/sse` endpoint
- **Streamable HTTP**: Connect via `/mcp` endpoint
- **Bearer Token Authentication**: Secure your MCP endpoints
- **Persistent Storage**: Budget data survives add-on restarts
- **HA UI Configuration**: Manage settings through Home Assistant

## Installation

### 1. Add Repository

1. Open Home Assistant
2. Go to **Settings** → **Add-ons** → **Add-on Store**
3. Click the **⋮** menu (top-right) → **Repositories**
4. Add this repository URL: `https://github.com/denics/actual-mcp-HA-app`
5. Click **Add** → **Close**

### 2. Install Add-on

1. Find **Actual Budget MCP Server** in the add-on store
2. Click **Install**
3. Wait for installation to complete

### 3. Configure

In the add-on **Configuration** tab, set:

| Option | Required | Description |
|--------|----------|-------------|
| Actual Server URL | Yes* | URL of your Actual Budget server (e.g., `http://actualbudget:5006`) |
| Actual Password | Yes* | Password for your Actual Budget server |
| Budget Sync ID | No | Specific budget ID to use |
| Bearer Token | Yes | Secret token for MCP authentication |
| Enable Write Tools | No | Allow data-modifying tools |
| Log Level | No | Log verbosity (default: info) |

*Required if connecting to a remote Actual server.

### 4. Start

Click **Start** and check the **Logs** tab to verify successful startup.

## Connecting to Home Assistant MCP Integration

Once the add-on is running:

1. Go to **Settings** → **Devices & Services** → **Add Integration**
2. Search for **MCP** or **Model Context Protocol**
3. Configure with:
   - **Server URL**: `http://a0d7b954-actual-mcp:3000/sse` (for SSE) or `http://a0d7b954-actual-mcp:3000/mcp` (for Streamable HTTP)
   - **Bearer Token**: The same token you configured in the add-on
4. Save and verify connection

> **Note**: The internal hostname `a0d7b954-actual-mcp` uses the add-on slug. If this doesn't work, use `http://localhost:3000/sse` or your HA instance's IP address.

## Endpoints

| Endpoint | Transport | Description |
|----------|-----------|-------------|
| `/sse` | Server-Sent Events | Legacy SSE transport (GET to connect, POST to `/messages`) |
| `/mcp` | Streamable HTTP | Modern MCP transport (single endpoint for all requests) |
| `/` | Streamable HTTP | Alias for `/mcp` |

## Security

- **Always set a Bearer Token** - Without it, your MCP endpoints are publicly accessible on your network
- **Use HA Secrets** - Store sensitive values in `secrets.yaml` and reference them via `!secret` if your HA setup supports it
- **Network Isolation** - The add-on only exposes port 3000; no other ports are opened

## Data Persistence

Budget cache and session data is stored in `/share/actual-mcp` within Home Assistant. This directory persists across:
- Add-on restarts
- Add-on updates
- Home Assistant reboots

## Troubleshooting

### "Resource test failed" in logs
- Verify `ACTUAL_SERVER_URL` is reachable from the add-on container
- Check `ACTUAL_PASSWORD` is correct
- Ensure the Actual Budget server is running

### MCP integration can't connect
- Verify the Bearer Token matches exactly
- Try `http://localhost:3000/sse` as an alternative URL
- Check add-on logs for startup errors

### Port conflict
- Change the port mapping in the add-on **Configuration** tab
- Update the MCP integration URL accordingly

## Maintainer

**Denics** - [github.ue37e@passmail.net](mailto:github.ue37e@passmail.net)

Repository: [Actual Budget MCP Server Add-on Repository](https://github.com/denics/actual-mcp-HA-app)

## License

MIT (same as upstream actual-mcp)
