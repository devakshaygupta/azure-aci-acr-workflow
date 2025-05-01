FROM python:3.9-slim

WORKDIR /app

# Copy app and input files
COPY "index.html" "data.txt" /app/

# Copy app.py from the correct location
COPY .github/apps/app.py /app/

# Copy all scripts
COPY .github/scripts/ /app/scripts/

# Make entrypoint script executable
RUN chmod +x /app/scripts/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["sh", "/app/scripts/entrypoint.sh"]
