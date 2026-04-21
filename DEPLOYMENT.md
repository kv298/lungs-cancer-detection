# Deployment Guide: Lung Cancer Detection on Render

This guide provides complete instructions for deploying the Lung Cancer Detection Streamlit app on Render using Docker and CI/CD pipeline.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Docker Testing](#local-docker-testing)
3. [Setting Up GitHub Repository](#setting-up-github-repository)
4. [Setting Up Docker Hub](#setting-up-docker-hub)
5. [Deploying to Render](#deploying-to-render)
6. [CI/CD Pipeline Configuration](#cicd-pipeline-configuration)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before deploying, ensure you have:

- **Docker** installed ([Download Docker Desktop](https://www.docker.com/products/docker-desktop))
- **GitHub Account** ([GitHub](https://github.com))
- **Docker Hub Account** ([Docker Hub](https://hub.docker.com))
- **Render Account** ([Render](https://render.com)) - Sign up for free
- **Git** installed on your machine

---

## Local Docker Testing

### Step 1: Build the Docker Image Locally

```bash
# Navigate to your project directory
cd path/to/Lung_Cancer_Streamlit-main

# Build the Docker image
docker build -t lung-cancer-detection:latest .
```

### Step 2: Run the Docker Container Locally

#### Option A: Using Docker Run

```bash
docker run -p 8501:8501 \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/datasets:/app/datasets \
  -v $(pwd)/images:/app/images \
  -v $(pwd)/ctscan_images:/app/ctscan_images \
  lung-cancer-detection:latest
```

#### Option B: Using Docker Compose

```bash
# Build and run using docker-compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

### Step 3: Access the App

Open your browser and go to:

```
http://localhost:8501
```

### Step 4: Stop the Container

```bash
# If using docker run
docker stop <container_id>

# If using docker-compose
docker-compose down
```

---

## Setting Up GitHub Repository

### Step 1: Initialize Git Repository

```bash
# Navigate to your project directory
cd path/to/Lung_Cancer_Streamlit-main

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Lung cancer detection app with Docker"
```

### Step 2: Create GitHub Repository

1. Go to [GitHub](https://github.com/new)
2. Create a new repository named `lung-cancer-detection`
3. Do NOT initialize with README (you already have one)
4. Click "Create repository"

### Step 3: Push Code to GitHub

```bash
# Add remote origin (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/lung-cancer-detection.git

# Rename branch to main
git branch -M main

# Push code to GitHub
git push -u origin main
```

### Step 4: Set Up GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Add the following secrets:

| Secret Name          | Value                                                                                               |
| -------------------- | --------------------------------------------------------------------------------------------------- |
| `DOCKERHUB_USERNAME` | Your Docker Hub username                                                                            |
| `DOCKERHUB_TOKEN`    | Your Docker Hub access token (from [Docker Hub Settings](https://hub.docker.com/settings/security)) |
| `RENDER_DEPLOY_HOOK` | Your Render deploy hook URL (see Render setup below)                                                |

---

## Setting Up Docker Hub

### Step 1: Create Docker Hub Account

1. Go to [Docker Hub](https://hub.docker.com)
2. Sign up for a free account

### Step 2: Create Access Token

1. Log in to Docker Hub
2. Click your username → **Account Settings** → **Security**
3. Click **New Access Token**
4. Name it `lung-cancer-ci`
5. Copy the token (you'll use it as `DOCKERHUB_TOKEN` in GitHub Secrets)

### Step 3: Create Repository (Optional)

You can create a public repository for your image:

1. Click **Create Repository**
2. Name: `lung-cancer-detection`
3. Description: "Lung Cancer Detection using Machine Learning"
4. Make it public (free tier allows unlimited public repos)

---

## Deploying to Render

### Step 1: Create Render Account

1. Go to [Render](https://render.com)
2. Sign up with your GitHub account
3. Verify your email

### Step 2: Create Web Service

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **New** → **Web Service**
3. Select **Docker** as the environment
4. Choose your GitHub repository (`lung-cancer-detection`)
5. Click **Connect**

### Step 3: Configure Service

Fill in the following details:

| Field             | Value                                                              |
| ----------------- | ------------------------------------------------------------------ |
| **Name**          | `lung-cancer-detection`                                            |
| **Environment**   | `Docker`                                                           |
| **Branch**        | `main`                                                             |
| **Build Command** | (Leave empty)                                                      |
| **Start Command** | `streamlit run app.py --server.port=8501 --server.address=0.0.0.0` |

### Step 4: Add Environment Variables

Click **Advanced** and add:

```
STREAMLIT_SERVER_HEADLESS=true
STREAMLIT_SERVER_ENABLE_CORS=false
TF_CPP_MIN_LOG_LEVEL=3
TF_USE_LEGACY_KERAS=1
```

### Step 5: Choose Plan

- **Free Plan**: Sufficient for testing (auto-spins down after 15 min of inactivity)
- **Paid Plan**: Recommended for production (starts at $7/month)

### Step 6: Deploy

1. Click **Create Web Service**
2. Render will start building your Docker image
3. This takes 5-10 minutes on first build
4. Once complete, you'll get a URL like: `https://lung-cancer-detection.onrender.com`

### Step 7: Get Deploy Hook URL

1. Go to your service settings on Render
2. Scroll to **Deploy Hook**
3. Click **Copy URL**
4. Add this as `RENDER_DEPLOY_HOOK` secret in GitHub

---

## CI/CD Pipeline Configuration

### How the Pipeline Works

```
Push to GitHub main branch
         ↓
GitHub Actions triggers
         ↓
Build Docker image
         ↓
Push to Docker Hub
         ↓
Trigger Render deploy hook
         ↓
Render pulls latest image
         ↓
Auto-deploy to production
```

### Pipeline Files

1. **`.github/workflows/deploy.yml`** - GitHub Actions workflow
2. **`render.yaml`** - Render configuration
3. **`Dockerfile`** - Docker container specification
4. **`.dockerignore`** - Files to exclude from Docker image

### Manual Deployment Trigger

To manually trigger deployment without pushing code:

```bash
curl -X POST "YOUR_RENDER_DEPLOY_HOOK_URL"
```

---

## Troubleshooting

### Problem: Docker Build Fails Locally

**Solution:**

```bash
# Clean up Docker cache
docker system prune -a

# Rebuild with verbose output
docker build -t lung-cancer-detection:latest . --no-cache

# Check for missing files
ls -la models/ datasets/ images/
```

### Problem: Models or Datasets Not Found

**Solution:**

Ensure these files exist in your repo:

- `models/final_model.sav`
- `models/keras_model.h5`
- `cnn model/lungcancer_model_cnn.h5`
- `datasets/data.csv`
- `images/lung-cancer.jpg`

If files are too large (>100MB), use **Git LFS**:

```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.h5"
git lfs track "*.sav"
git lfs track "*.csv"

# Add and push
git add .gitattributes
git commit -m "Add Git LFS tracking"
git push origin main
```

### Problem: GitHub Actions Secrets Not Working

**Solution:**

Verify secrets are set correctly:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Ensure all secrets are present:
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN`
   - `RENDER_DEPLOY_HOOK`
3. Re-trigger the workflow

### Problem: Render Deployment Fails

**Solution:**

Check Render logs:

1. Go to your service on Render
2. Click **Logs** tab
3. Look for error messages
4. Common issues:
   - Missing environment variables
   - Memory limit exceeded (upgrade to paid plan)
   - Port not properly configured

### Problem: TensorFlow/Keras Import Errors

**Solution:**

Already handled in `Dockerfile` and `app.py` with:

```dockerfile
ENV TF_USE_LEGACY_KERAS=1
ENV TF_CPP_MIN_LOG_LEVEL=3
```

If still failing, ensure `requirements.txt` has correct versions:

```
tensorflow>=2.11.0
keras>=2.11.0
```

### Problem: Out of Memory on Render Free Plan

**Solution:**

The free plan has limited resources. Options:

1. Upgrade to paid plan (recommended)
2. Optimize model loading (lazy load models)
3. Use smaller model variants

---

## Monitoring Deployment

### Render Dashboard

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click your service
3. View:
   - **Logs**: Real-time application logs
   - **Metrics**: CPU, memory, network usage
   - **Events**: Deployment history
   - **Settings**: Modify configuration

### Health Check

Render automatically checks: `/_stcore/health`

If health checks fail:

1. Check app logs
2. Restart service: Click **Manual Deploy**
3. Check environment variables

### Custom Domain (Optional)

To add a custom domain:

1. Go to service settings
2. Click **Custom Domain**
3. Add your domain (e.g., `cancer-detection.com`)
4. Follow DNS setup instructions

---

## File Structure

```
Lung_Cancer_Streamlit-main/
├── Dockerfile                    # Docker container specs
├── docker-compose.yml           # Local development setup
├── .dockerignore                # Files to exclude from image
├── render.yaml                  # Render configuration
├── requirements.txt             # Python dependencies
├── app.py                       # Streamlit application
├── README.md                    # Project documentation
├── DEPLOYMENT.md                # This file
├── .github/
│   └── workflows/
│       └── deploy.yml           # GitHub Actions CI/CD
├── models/
│   ├── final_model.sav
│   └── keras_model.h5
├── datasets/
│   ├── data.csv
│   ├── train.csv
│   └── test.csv
└── images/
    └── lung-cancer.jpg
```

---

## Quick Reference Commands

```bash
# Local Development
docker-compose up -d              # Start container
docker-compose logs -f            # View logs
docker-compose down               # Stop container

# Docker Management
docker build -t lung-cancer:latest .     # Build image
docker run -p 8501:8501 lung-cancer:latest  # Run container
docker images                     # List images
docker ps -a                      # List containers
docker system prune -a            # Clean up

# Git Commands
git add .                         # Stage changes
git commit -m "message"           # Commit
git push origin main              # Push to GitHub
git log --oneline                 # View history

# Render Deployment
# Manual trigger (with deploy hook URL)
curl -X POST "YOUR_DEPLOY_HOOK_URL"
```

---

## Cost Estimation

| Service    | Free Tier            | Cost           |
| ---------- | -------------------- | -------------- |
| GitHub     | ✅ Unlimited         | Free           |
| Docker Hub | ✅ Unlimited public  | Free           |
| Render     | ✅ 750 hours/month\* | Starting $7/mo |

\*Free tier auto-spins down after 15 min inactivity

---

## Next Steps

1. ✅ Test Docker locally
2. ✅ Push to GitHub
3. ✅ Set up Docker Hub
4. ✅ Configure GitHub Secrets
5. ✅ Deploy to Render
6. ✅ Monitor and maintain

---

## Support & Resources

- [Docker Documentation](https://docs.docker.com)
- [Render Documentation](https://render.com/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Streamlit Documentation](https://docs.streamlit.io)
- [TensorFlow Documentation](https://www.tensorflow.org/guide)

---

## Additional Tips

### For Production Deployment

1. Use paid Render plan for consistent availability
2. Enable auto-deploy for continuous integration
3. Set up monitoring and alerts
4. Use environment-specific configs
5. Implement proper error logging
6. Regular backups of data

### Security Best Practices

1. Never commit secrets to GitHub
2. Use GitHub Secrets for sensitive data
3. Enable branch protection rules
4. Review Docker image security
5. Keep dependencies updated
6. Use HTTPS for all connections

---

**Last Updated:** 2024
**Deployment Status:** Ready for Production
