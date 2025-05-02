FROM python:3.9-slim

WORKDIR /app

# Install required dependencies, including Git
RUN apt-get update && apt-get install -y \
    git \
    && apt-get clean

# Copy app and input files
COPY "index.html" "data.txt" "README.md" /app/

# Copy app.py from the correct location
COPY .github/apps/app.py /app/

# Copy all scripts
COPY .github/scripts/ /app/scripts/

# Copy the .git directory into the container
COPY .git /app/.git

# Expose port 80
EXPOSE 80

# Make entrypoint script executable
RUN chmod +x /app/scripts/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["sh", "/app/scripts/entrypoint.sh"]


