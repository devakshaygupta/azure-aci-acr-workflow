FROM python:3.9-slim

WORKDIR /app

# Copy app and input files
COPY "index.html" "data.txt" /app/

# Copy app.py
COPY .github/workflows/apps/app.py /app/

# Copy all scripts
COPY .github/workflows/scripts/ /app/scripts/

# Make entrypoint script executable
RUN chmod +x /app/scripts/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["sh", "/app/scripts/entrypoint.sh"]
