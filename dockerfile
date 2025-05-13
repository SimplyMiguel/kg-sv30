# Base image: Python 3.11 slim
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Production environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production \
    DEBUG=false

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p data

# Copy application code
COPY src/ ./src/
COPY templates/ ./templates/
COPY static/ ./static/
COPY wsgi.py gunicorn_config.py ./

# Cloud Run will use the PORT environment variable
# Default to 8080 for local testing
ENV PORT=8080

# Run as non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8080

# Production-ready command using Gunicorn config file
# Cloud Run automatically forwards requests to $PORT
CMD exec gunicorn --bind :$PORT -c gunicorn_config.py wsgi:app
