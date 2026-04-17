FROM python:3.11-slim

WORKDIR /app

# Install git and other dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /app/state /app/workspace

# Clone hermes-agent (required dependency)
RUN git clone https://github.com/NousResearch/hermes-agent.git /hermes-agent

# Install hermes-agent dependencies
RUN pip install --no-cache-dir -r /hermes-agent/requirements.txt

# Copy webui files
COPY . /app

# Install webui dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Set environment variables
ENV HERMES_WEBUI_AGENT_DIR=/hermes-agent
ENV HERMES_WEBUI_HOST=0.0.0.0
ENV HERMES_WEBUI_PORT=8787
ENV HERMES_WEBUI_STATE_DIR=/app/state
ENV HERMES_WEBUI_DEFAULT_WORKSPACE=/app/workspace
ENV PYTHONUNBUFFERED=1

# Expose port
EXPOSE 8787

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8787/health || exit 1

# Run server
CMD ["python", "server.py"]
