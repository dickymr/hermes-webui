# Hermes WebUI - Railway Deployment

This repository contains the configuration files needed to deploy [Hermes WebUI](https://github.com/nesquena/hermes-webui) on [Railway](https://railway.app/).

## ⚠️ Important Caveat

Hermes WebUI is designed for local/SSH use with the server binding to `127.0.0.1` by default. This deployment configuration modifies the app to work on Railway by:
- Binding to `0.0.0.0` (required for Railway)
- Including the hermes-agent dependency (cloned at build time)
- Configuring persistent storage for state

## Quick Start

### 1. Fork the Original Repository

First, fork the original hermes-webui repository:
```bash
git clone https://github.com/nesquena/hermes-webui.git
cd hermes-webui
```

### 2. Copy Deployment Files

Copy all files from this repository into your forked hermes-webui:
```bash
cp -r /path/to/hermes-webui-railway/* /path/to/hermes-webui/
```

### 3. Push to GitHub

```bash
git add .
git commit -m "Add Railway deployment configuration"
git push origin main
```

### 4. Deploy on Railway

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click **New Project**
3. Select **Deploy from GitHub repo**
4. Choose your forked hermes-webui repository
5. Railway will automatically detect the `railway.json` and build using Docker

## Environment Variables

Configure these in your Railway project settings:

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HERMES_WEBUI_HOST` | Yes | `0.0.0.0` | Bind address (must be 0.0.0.0 for Railway) |
| `HERMES_WEBUI_PORT` | Yes | `8787` | Server port |
| `HERMES_WEBUI_STATE_DIR` | Yes | `/app/state` | Persistent state directory |
| `HERMES_WEBUI_DEFAULT_WORKSPACE` | Yes | `/app/workspace` | Default workspace path |
| `HERMES_WEBUI_AGENT_DIR` | Auto | `/hermes-agent` | Path to hermes-agent (auto-set) |
| `OPENAI_API_KEY` | Optional | - | OpenAI API key |
| `ANTHROPIC_API_KEY` | Optional | - | Anthropic API key |
| Other API keys | Optional | - | Any API keys Hermes requires |

## Deployment Methods

### Option 1: Docker (Recommended)
The `Dockerfile` and `railway.json` provide a complete containerized deployment that:
- Clones hermes-agent at build time
- Sets up all dependencies
- Configures proper networking

### Option 2: Nixpacks
The `nixpacks.toml` provides an alternative build method using Railway's Nixpacks builder.

### Option 3: Procfile
The `Procfile` can be used with traditional buildpacks, though you may need to manually handle the hermes-agent dependency.

## Persistence

Railway's filesystem is ephemeral. To persist sessions and state:

1. Go to your Railway project
2. Navigate to **Volumes**
3. Create a volume mounted at `/app/state`
4. Redeploy

## Troubleshooting

### Port Binding Issues
If you see "Address already in use" errors, ensure `HERMES_WEBUI_HOST` is set to `0.0.0.0` and `HERMES_WEBUI_PORT` matches Railway's `$PORT`.

### Agent Not Found
The hermes-agent is cloned during the Docker build. If you see import errors:
- Check that `HERMES_WEBUI_AGENT_DIR` is set to `/hermes-agent`
- Verify the clone succeeded in build logs

### State Not Persisting
Ensure you've added a Railway Volume mounted at `/app/state`. Without this, all data is lost on redeploy.

## Files Included

- `Dockerfile` - Multi-stage Docker build with hermes-agent
- `railway.json` - Railway deployment configuration
- `nixpacks.toml` - Alternative Nixpacks build configuration
- `Procfile` - Heroku-style process definition
- `requirements.txt` - Python dependencies for the webui

## License

See the original [hermes-webui](https://github.com/nesquena/hermes-webui) repository for license information.
