FROM python:3.9-slim

WORKDIR /app

# Install required dependencies, including Apache2
RUN apt-get update && apt-get install -y \
    apache2 \
    git \
    && apt-get clean

# Copy app and input files
COPY "index.html" "data.txt" /var/www/html/

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

# Start Apache2 as the default process
CMD ["apachectl", "-D", "FOREGROUND"]


