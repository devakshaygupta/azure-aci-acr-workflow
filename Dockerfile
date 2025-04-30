FROM python:3.9-slim

WORKDIR /app

# Copy application files
COPY apps/app.py data.txt index.html /app/
COPY scripts/ /app/scripts/

# Make entrypoint script executable
RUN chmod +x /app/scripts/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["sh", "scripts/entrypoint.sh"]