# Production image - optimized for ML applications
FROM python:3.10-slim

WORKDIR /app

# Install only runtime dependencies (no build tools needed - using pre-built wheels)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Set environment variables for TensorFlow and Streamlit
ENV PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=0 \
    PIP_NO_CACHE_DIR=1 \
    TF_CPP_MIN_LOG_LEVEL=3 \
    TF_USE_LEGACY_KERAS=1 \
    STREAMLIT_SERVER_HEADLESS=true \
    STREAMLIT_SERVER_ENABLE_CORS=false \
    STREAMLIT_SERVER_ENABLE_XSRF_PROTECTION=false \
    STREAMLIT_LOGGER_LEVEL=info

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p models datasets images ctscan_images/test/{large.cell.carcinoma,normal}

# Expose Streamlit port
EXPOSE 8501

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD sh -c "curl -f http://localhost:${PORT:-8501}/_stcore/health || exit 1"

# Run Streamlit app (Render injects PORT)
CMD sh -c "streamlit run app.py --server.port=${PORT:-8501} --server.address=0.0.0.0"
