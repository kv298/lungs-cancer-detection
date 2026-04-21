# Complete Docker & Render Deployment Guide

## 🐛 Fix Docker Error (Windows)

The error `Head "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine/_ping"` means **Docker Desktop is not running**.

### Solution:

1. **Start Docker Desktop** on Windows:
   - Search for "Docker Desktop" in Start menu
   - Click to open it
   - Wait 2-3 minutes for Docker to fully start
   - You should see a running Docker icon in your system tray

2. **Verify Docker is running:**
   ```bash
   docker --version
   docker ps
   ```

---

## 🐳 Run Locally with Docker

### Step 1: Build the Docker Image

```bash
docker build -t lung-cancer-detection:latest .
```

### Step 2: Run the Container

```bash
docker run -p 8501:8501 \
  -v %cd%/models:/app/models \
  -v %cd%/datasets:/app/datasets \
  -v %cd%/images:/app/images \
  -v %cd%/ctscan_images:/app/ctscan_images \
  lung-cancer-detection:latest
```

On Linux/Mac:

```bash
docker run -p 8501:8501 \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/datasets:/app/datasets \
  -v $(pwd)/images:/app/images \
  -v $(pwd)/ctscan_images:/app/ctscan_images \
  lung-cancer-detection:latest
```

### Step 3: Access the App

Open: `http://localhost:8501`

---

## 🐳 Run with Docker Compose (Easiest)

```bash
docker-compose up --build
```

Access: `http://localhost:8501`

To stop:

```bash
docker-compose down
```

---

## 🚀 Deploy to Render with CI/CD

### Prerequisites:

- GitHub account
- Render account (https://render.com)
- Docker Hub account (optional, for image caching)

### Step 1: Push Your Code to GitHub

If not already on GitHub:

```bash
git init
git add .
git commit -m "Initial commit with Docker and Render config"
git remote add origin https://github.com/YOUR_USERNAME/lung-cancer-detection.git
git branch -M main
git push -u origin main
```

### Step 2: Create Render Service

1. Go to https://dashboard.render.com
2. Click "New +" → "Web Service"
3. Select "Deploy an existing repository" or "Public Git repository"
4. Enter: `https://github.com/YOUR_USERNAME/lung-cancer-detection.git`
5. Configure:
   - **Name:** `lung-cancer-detection`
   - **Environment:** `Docker`
   - **Build Command:** (leave empty - uses Dockerfile)
   - **Start Command:** (leave empty - uses Dockerfile CMD)
   - **Instance Type:** `Standard` (or higher for better performance)
   - **Auto-deploy:** Enable (auto-deploy on git push)

6. Add Environment Variables:

   ```
   PORT=8501
   STREAMLIT_SERVER_HEADLESS=true
   STREAMLIT_SERVER_ENABLE_CORS=false
   TF_CPP_MIN_LOG_LEVEL=3
   TF_USE_LEGACY_KERAS=1
   ```

7. Click "Create Web Service"

### Step 3: Set Up GitHub Actions (Optional but Recommended)

The `.github/workflows/deploy.yml` automates everything:

1. **On GitHub**, go to Settings → Secrets and variables → Actions
2. Add these secrets:

   **Option A: Docker Hub (Faster builds with caching)**
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: Your Docker Hub personal access token

   **Option B: For Deploy Hook Only**
   - `RENDER_DEPLOY_HOOK`: Get from Render dashboard
     - Go to your service settings → Deploy Hook
     - Copy the URL

The workflow will:

- Run on every push to `main` branch
- Build Docker image
- Push to Docker Hub (if credentials provided)
- Trigger Render deployment

### Step 4: Get Render Deploy Hook (Optional)

If using GitHub Actions for auto-deployment:

1. In Render dashboard, go to your service
2. Settings → Deploy Hook
3. Copy the hook URL
4. On GitHub: Settings → Secrets → Add `RENDER_DEPLOY_HOOK`

---

## 📊 Monitoring & Logs

### View Render Logs:

1. Go to https://dashboard.render.com
2. Select your service
3. Click "Logs" tab
4. Watch real-time logs as app deploys and runs

### Common Issues:

**Build fails with TensorFlow errors:**

- Increase instance type to "Standard" or higher
- Add more memory in Render settings

**App crashes on startup:**

- Check logs in Render dashboard
- Ensure all model files are committed to git

**Memory issues:**

- Upgrade to larger Render instance
- Reduce TensorFlow verbosity (TF_CPP_MIN_LOG_LEVEL=3)

---

## 📋 Deployment Checklist

- [ ] Docker Desktop running (Windows)
- [ ] Local Docker build works: `docker build -t lung-cancer-detection:latest .`
- [ ] Docker compose works: `docker-compose up`
- [ ] Code pushed to GitHub
- [ ] Render service created
- [ ] Environment variables set on Render
- [ ] GitHub Actions secrets configured (optional)
- [ ] App accessible at Render URL
- [ ] Check Render logs for any errors

---

## 🔄 Deployment Workflow

### After Making Changes:

1. **Test locally:**

   ```bash
   docker-compose up
   ```

2. **Push to GitHub:**

   ```bash
   git add .
   git commit -m "Your changes"
   git push origin main
   ```

3. **Render auto-deploys** (if enabled)

4. **Check Render logs** to verify deployment

---

## 🎯 Quick Commands Reference

```bash
# Local development
streamlit run app.py

# Docker build
docker build -t lung-cancer-detection:latest .

# Docker run
docker run -p 8501:8501 lung-cancer-detection:latest

# Docker compose
docker-compose up --build

# Stop Docker compose
docker-compose down

# View logs
docker-compose logs -f

# Remove Docker image
docker rmi lung-cancer-detection:latest
```

---

## 📱 Access Your Deployed App

Once deployed to Render, your app will be available at:

```
https://lung-cancer-detection.onrender.com
```

(or your custom domain if configured)

---

## 🆘 Troubleshooting

| Problem                  | Solution                                   |
| ------------------------ | ------------------------------------------ |
| Docker not found         | Start Docker Desktop                       |
| Port 8501 already in use | Change port: `docker run -p 8502:8501 ...` |
| Build takes too long     | Use Docker Hub caching in CI/CD            |
| Models not loading       | Ensure files are in git, not in .gitignore |
| TensorFlow errors        | Increase Render instance size              |
| Out of memory            | Upgrade to "Standard" instance or higher   |

---

For more help, see:

- Render Docs: https://render.com/docs
- Docker Docs: https://docs.docker.com
- Streamlit Docs: https://docs.streamlit.io
