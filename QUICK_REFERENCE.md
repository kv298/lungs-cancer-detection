# 🎯 Quick Reference Card - Docker & Render Commands

## 🐳 Docker Commands

### Build and Run Locally

```bash
# Build image
docker build -t lung-cancer-detection:latest .

# Run container
docker run -p 8501:8501 lung-cancer-detection:latest

# Run with volume mounts (preserve data)
docker run -p 8501:8501 \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/datasets:/app/datasets \
  lung-cancer-detection:latest

# Windows (PowerShell)
docker run -p 8501:8501 `
  -v $PWD/models:/app/models `
  -v $PWD/datasets:/app/datasets `
  lung-cancer-detection:latest

# List running containers
docker ps

# Stop container
docker stop <container_id>

# Remove image
docker rmi lung-cancer-detection:latest

# View logs
docker logs <container_id>
```

## 🐳 Docker Compose Commands

```bash
# Start (build if needed)
docker-compose up

# Start in background
docker-compose up -d

# Build and start
docker-compose up --build

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f streamlit

# Restart services
docker-compose restart

# Remove all (containers, volumes)
docker-compose down -v
```

## 🔨 Build & Test Locally

```bash
# Test Docker build
docker build -t lung-cancer-detection:latest .

# Test Docker Compose
docker-compose up --build
# Visit: http://localhost:8501

# Run Python directly (no Docker)
pip install -r requirements.txt
streamlit run app.py
```

## 📦 Python Package Management

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Update pip
pip install --upgrade pip

# Check installed packages
pip list

# Freeze dependencies
pip freeze > requirements.txt
```

## 🔀 Git Commands

```bash
# Check status
git status

# Add all changes
git add .

# Commit changes
git commit -m "Your message"

# Push to GitHub
git push origin main

# Pull latest
git pull origin main

# View commit history
git log --oneline -5

# View changes
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1
```

## 🚀 Render Deployment

```bash
# Get deploy hook from Render dashboard:
# Service Settings → Deploy Hook → Copy URL

# Trigger deployment manually
curl https://api.render.com/deploy/srv-xxxxxxx

# View logs (via Render dashboard)
# Dashboard → Service → Logs tab

# Restart service (via Render dashboard)
# Dashboard → Service → Manual Deploy
```

## 🌐 GitHub Actions

```bash
# Check workflow status
# Go to: GitHub repo → Actions tab

# View workflow logs
# Actions → Workflow run → Click on job

# Manually trigger workflow
# Actions → Workflow → Run workflow
```

## 🔍 Debugging Commands

```bash
# Docker image info
docker inspect lung-cancer-detection:latest

# Docker container shell
docker exec -it <container_id> /bin/bash

# Check Docker disk usage
docker system df

# Clean up Docker
docker system prune -a

# Check port usage (Windows)
netstat -ano | findstr :8501

# Check port usage (Linux/Mac)
lsof -i :8501

# Kill process on port (Linux/Mac)
kill -9 <PID>
```

## 📊 Environment Variables

```bash
# View environment variables in container
docker exec <container_id> env

# Set environment variable for container
docker run -e KEY=value lung-cancer-detection:latest

# Load from .env file
# In docker-compose.yml:
env_file: .env
```

## 🔐 Docker Hub Commands

```bash
# Login to Docker Hub
docker login

# Tag image
docker tag lung-cancer-detection:latest username/lung-cancer-detection:latest

# Push to Docker Hub
docker push username/lung-cancer-detection:latest

# Pull from Docker Hub
docker pull username/lung-cancer-detection:latest

# Logout
docker logout
```

## 📋 Service Inspection Commands

```bash
# Check Streamlit app status
curl http://localhost:8501/_stcore/health

# Check Render service status
curl https://lung-cancer-detection.onrender.com/_stcore/health

# Verify models exist
docker exec <container_id> ls -la /app/models

# Check installed Python packages
docker exec <container_id> pip list

# Check Python version
docker exec <container_id> python --version
```

## 🔧 Troubleshooting Commands

```bash
# Rebuild without cache
docker build -t lung-cancer-detection:latest . --no-cache

# Full Docker Compose rebuild
docker-compose down -v
docker-compose up --build

# Check Docker daemon status
docker info

# Start Docker daemon (Linux)
sudo systemctl start docker

# View container resource usage
docker stats

# Check container health
docker inspect --format='{{.State.Health}}' <container_id>
```

## 📝 File Operations

```bash
# View file in container
docker exec <container_id> cat /app/app.py

# Copy file from container
docker cp <container_id>:/app/file.txt ./local_file.txt

# Copy file to container
docker cp ./local_file.txt <container_id>:/app/file.txt

# Check directory structure
docker exec <container_id> tree /app
```

## 🎯 Common Workflows

### Local Development

```bash
# 1. Start app
docker-compose up

# 2. Make changes to code
# 3. Code auto-reloads (if mounted)

# 4. Stop when done
docker-compose down
```

### Deploy to Production

```bash
# 1. Test locally
docker-compose up

# 2. Commit and push
git add .
git commit -m "Features"
git push origin main

# 3. Wait for GitHub Actions
# 4. Render auto-deploys
# 5. Check logs in Render
```

### Update Dependencies

```bash
# 1. Update requirements.txt
pip install new-package
pip freeze > requirements.txt

# 2. Test with Docker
docker build -t lung-cancer-detection:latest .
docker run -p 8501:8501 lung-cancer-detection:latest

# 3. Commit and deploy
git add requirements.txt
git commit -m "Update dependencies"
git push origin main
```

---

## ⌨️ Keyboard Shortcuts

| Action                | Command                               |
| --------------------- | ------------------------------------- |
| Stop Docker Compose   | `Ctrl + C`                            |
| Exit Docker container | `exit`                                |
| Clear terminal        | `clear` (Linux/Mac) / `cls` (Windows) |
| Previous command      | `↑` Arrow key                         |
| Autocomplete          | `Tab`                                 |

---

## 📞 Help Commands

```bash
# Docker help
docker --help
docker build --help

# Docker Compose help
docker-compose --help

# Streamlit help
streamlit --help

# Git help
git --help

# Pip help
pip --help
```

---

## 🔗 Quick Links

- **Docker Docs:** https://docs.docker.com
- **Render Docs:** https://render.com/docs
- **GitHub Actions:** https://docs.github.com/actions
- **Streamlit Docs:** https://docs.streamlit.io
- **TensorFlow Docs:** https://www.tensorflow.org

---

## 📊 Performance Tuning

```bash
# Limit memory usage
docker run -m 2G lung-cancer-detection:latest

# Limit CPU usage
docker run --cpus="1.5" lung-cancer-detection:latest

# Combine limits
docker run -m 2G --cpus="1.5" -p 8501:8501 lung-cancer-detection:latest
```

---

## ✅ Health Checks

```bash
# Check if Streamlit is responding
curl -f http://localhost:8501/_stcore/health

# Check if models load
docker exec <container_id> python -c "import pickle; pickle.load(open('models/final_model.sav', 'rb'))"

# Check TensorFlow
docker exec <container_id> python -c "import tensorflow; print(tensorflow.__version__)"

# Full diagnostic
docker run -it --rm lung-cancer-detection:latest python -m pip check
```

---

**Bookmark this page for quick reference during development and deployment!**
