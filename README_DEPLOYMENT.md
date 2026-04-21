# 🐳 Docker & Render Deployment - Complete Setup

This directory now contains everything you need to deploy your Lung Cancer Detection app on Render with a complete CI/CD pipeline.

## 📁 Deployment Files Overview

### Core Docker Files

#### `Dockerfile`

- **Purpose**: Defines the Docker container image
- **What it does**:
  - Uses Python 3.10 slim image (small, efficient)
  - Installs all Python dependencies
  - Sets up TensorFlow/Keras environment
  - Exposes port 8501 (Streamlit default)
  - Includes health checks
- **Build size**: ~2-3 GB
- **When to edit**: Add new system dependencies

#### `docker-compose.yml`

- **Purpose**: Local development setup
- **What it does**:
  - Runs the Docker container locally
  - Maps ports and volumes
  - Sets environment variables
  - Includes health checks
- **Usage**: `docker-compose up -d`
- **When to edit**: Change local port numbers or volume paths

#### `.dockerignore`

- **Purpose**: Excludes unnecessary files from Docker image
- **Files excluded**: Git, Python cache, IDE files, notebooks
- **Effect**: Reduces image size and build time
- **When to edit**: Never (unless you have extra large files to exclude)

### CI/CD Pipeline Files

#### `.github/workflows/deploy.yml`

- **Purpose**: Automates deployment on every push
- **What it does**:
  - Triggers on push to main/master branch
  - Builds Docker image
  - Pushes to Docker Hub
  - Triggers Render deployment
- **Trigger**: Automatically runs when you `git push`
- **When to edit**: Never (unless you change branch names)

#### `render.yaml`

- **Purpose**: Render platform configuration
- **What it does**:
  - Defines service name and settings
  - Sets start command for app
  - Configures environment variables
  - Specifies health check path
- **Location**: Detected automatically by Render
- **When to edit**: Rarely (only to change service configuration)

### Configuration Files

#### `.streamlit/config.toml`

- **Purpose**: Streamlit app configuration
- **What it does**:
  - Sets UI theme and styling
  - Configures server settings
  - Disables analytics for privacy
- **When to edit**: To customize app appearance

#### `.env.example`

- **Purpose**: Template for environment variables
- **What to do**: Copy to `.env` for local development
- **When to edit**: Add new environment variables

#### `.gitignore`

- **Purpose**: Prevents sensitive files from Git
- **Files ignored**: Virtual environments, Python cache, secrets
- **When to edit**: Add more patterns to ignore

### Documentation Files

#### `DEPLOYMENT.md` ⭐

- **Purpose**: Complete step-by-step deployment guide
- **Content**: 5+ detailed sections with all instructions
- **Read this first** for comprehensive guide
- **Length**: ~400 lines, very detailed

#### `QUICKSTART.md`

- **Purpose**: Fast 5-minute deployment summary
- **Content**: TL;DR version of DEPLOYMENT.md
- **Use if**: You're experienced with Docker/GitHub
- **Length**: ~50 lines, very concise

#### `DEPLOYMENT_CHECKLIST.md`

- **Purpose**: Interactive checklist to follow
- **Content**: ✅ boxes to check as you complete steps
- **Use for**: Tracking progress through deployment
- **Length**: ~400 lines, very organized

#### `README_DEPLOYMENT.md` (this file)

- **Purpose**: Explains all the deployment files
- **Content**: What each file does and when to edit
- **Read for**: Understanding the setup

### Setup Scripts

#### `setup-deployment.sh` (Linux/Mac)

- **Purpose**: Automate initial setup
- **Usage**: `bash setup-deployment.sh`
- **What it does**:
  - Checks prerequisites (Docker, Git)
  - Initializes Git repository
  - Guides you through GitHub setup
  - Sets up remote URLs
- **When to use**: First time setup

#### `setup-deployment.bat` (Windows)

- **Purpose**: Same as setup-deployment.sh but for Windows
- **Usage**: Double-click or `setup-deployment.bat`
- **What it does**: Same as above
- **When to use**: First time setup on Windows

---

## 🚀 Quick Start Guide

### For Local Testing (15 min)

```bash
# 1. Build Docker image
docker build -t lung-cancer-detection:latest .

# 2. Run with docker-compose
docker-compose up -d

# 3. Open browser
# Visit: http://localhost:8501

# 4. Stop when done
docker-compose down
```

### For Full Deployment (1 hour total)

1. **Read QUICKSTART.md** (5 min)

   ```bash
   cat QUICKSTART.md
   ```

2. **Follow DEPLOYMENT_CHECKLIST.md** (45 min)
   - Phase 1: Local Docker Testing
   - Phase 2: Push to GitHub
   - Phase 3: Configure GitHub Secrets
   - Phase 4: Deploy to Render
   - Phase 5: Test CI/CD Pipeline

3. **Reference DEPLOYMENT.md** (as needed)
   - Detailed explanation of each step
   - Troubleshooting guide
   - Cost information

---

## 📊 Deployment Architecture

```
Your Local Computer
    ↓
    ├─ Docker Build
    ├─ docker-compose up
    └─ Test at localhost:8501

        ↓

GitHub Repository
    ├─ Stores all code
    ├─ Triggers CI/CD on push
    └─ Manages GitHub Secrets

        ↓ (Automatic CI/CD)

GitHub Actions
    ├─ Builds Docker image
    ├─ Pushes to Docker Hub
    └─ Triggers Render deploy

        ↓

Docker Hub
    └─ Stores Docker image

        ↓

Render.com
    ├─ Hosts the app
    ├─ Monitors health
    └─ Auto-restarts on crash

        ↓

Live App
└─ https://lung-cancer-detection-xxxx.onrender.com
```

---

## 🔧 File Dependencies

```
.gitignore
  └─ Protects secrets and cache

.dockerignore
  └─ Reduces image size

Dockerfile
  ├─ Uses requirements.txt
  ├─ Uses .streamlit/config.toml
  └─ Creates Docker image

docker-compose.yml
  ├─ Uses Dockerfile
  ├─ Uses .env (optional)
  └─ Defines local environment

.github/workflows/deploy.yml
  ├─ Triggers on git push
  ├─ Uses Dockerfile
  └─ Uses GitHub Secrets

render.yaml
  └─ Configures Render deployment

.streamlit/config.toml
  └─ Streamlit app settings

.env.example
  └─ Template for .env file
```

---

## 🎯 Key Concepts

### Docker Container

- **What**: Packages your app with all dependencies
- **Why**: Works the same everywhere (local, GitHub, Render)
- **File**: `Dockerfile` defines what goes in the container

### CI/CD Pipeline

- **What**: Automatically builds and deploys on code changes
- **Why**: No manual pushing; just `git push` and it deploys
- **File**: `.github/workflows/deploy.yml` automates the process

### Environment Variables

- **What**: Settings that change based on environment
- **Why**: Different configs for local (debug) vs production
- **Files**: `.env.example` (template), `render.yaml` (production)

### Docker Hub

- **What**: Registry where Docker images are stored
- **Why**: Render pulls the image from here
- **Used by**: GitHub Actions (automatic) and you (manual)

### Render

- **What**: Platform that runs your Docker container
- **Why**: Free/cheap hosting with auto-deploy
- **Config**: `render.yaml` tells Render how to run it

---

## ✅ Pre-Deployment Checklist

Before you deploy, verify:

- [ ] All model files exist (_.h5, _.sav files)
- [ ] All dataset files exist (\*.csv files)
- [ ] All image files exist (_.jpg, _.png files)
- [ ] Docker installed and running
- [ ] Git installed and configured
- [ ] GitHub account created
- [ ] Docker Hub account created
- [ ] Render account created

---

## 🆘 Common Issues & Solutions

### Issue: "Can't find models"

**Solution**: Ensure files are in repo before pushing to GitHub

### Issue: "GitHub Actions failing"

**Solution**: Check GitHub Secrets are set (Settings → Secrets)

### Issue: "Render build takes forever"

**Solution**: Normal first time (5-10 min); caches subsequent builds

### Issue: "Out of memory on Render"

**Solution**: Upgrade from free to paid plan ($7/mo)

### Issue: "Docker build fails locally"

**Solution**: `docker system prune -a` then rebuild

---

## 📈 Deployment Timeline

```
Time      Step                          Duration
────────────────────────────────────────────────────
0:00      Read QUICKSTART.md            5 min
0:05      Test Docker locally           10 min
0:15      Push code to GitHub           10 min
0:25      Configure GitHub Secrets      5 min
0:30      Deploy to Render              20 min (building)
0:50      Verify live deployment        5 min
────────────────────────────────────────────────────
1:00      Total Time                    60 min
```

---

## 🎓 Learning Resources

| Topic          | Resource                            | Time   |
| -------------- | ----------------------------------- | ------ |
| Docker Basics  | https://docs.docker.com/get-started | 30 min |
| GitHub Actions | https://github.com/features/actions | 20 min |
| Render Docs    | https://render.com/docs             | 15 min |
| Streamlit      | https://docs.streamlit.io           | varies |

---

## 📞 Support

### I need help with:

- **Docker issues** → See DEPLOYMENT.md → Troubleshooting
- **GitHub setup** → See DEPLOYMENT.md → Setting Up GitHub Repository
- **Render deployment** → See DEPLOYMENT.md → Deploying to Render
- **CI/CD pipeline** → See DEPLOYMENT.md → CI/CD Pipeline Configuration
- **Quick overview** → See QUICKSTART.md
- **Detailed guide** → See DEPLOYMENT.md

---

## 🔄 What Happens After Deployment

### On Your Local Computer

```bash
git add .
git commit -m "Fix bug"
git push origin main
```

### Automatically

1. GitHub detects push
2. Triggers GitHub Actions workflow
3. Builds Docker image
4. Pushes to Docker Hub
5. Calls Render deploy hook

### On Render

1. Detects deployment trigger
2. Pulls latest Docker image
3. Starts new container
4. Runs health checks
5. Routes traffic to new version

### Result

- ✅ Your app updates automatically
- ✅ No downtime (zero-downtime deployment)
- ✅ Old version is backed up
- ✅ Automatic rollback on failure

---

## 🎉 Success Indicators

You'll know it's working when:

- ✅ `docker-compose up` works locally
- ✅ Browser shows app at http://localhost:8501
- ✅ GitHub shows all files committed
- ✅ GitHub Actions workflow completes successfully
- ✅ Render shows green "Live" status
- ✅ App accessible at render.com URL
- ✅ Any changes to GitHub auto-deploy within 5 min

---

## 📊 Cost Summary

| Service    | Free Plan       | Paid Plan    |
| ---------- | --------------- | ------------ |
| GitHub     | ✅ Unlimited    | (not needed) |
| Docker Hub | ✅ Unlimited    | (not needed) |
| Render     | 750 hrs/month\* | $7/month     |

\*Free auto-pauses after 15 min inactivity

---

## 📝 File Editing Guide

| File                         | How Often | Who    | Reason           |
| ---------------------------- | --------- | ------ | ---------------- |
| app.py                       | Often     | You    | Add features     |
| requirements.txt             | Sometimes | You    | Add dependencies |
| Dockerfile                   | Rarely    | DevOps | Change runtime   |
| docker-compose.yml           | Never     | DevOps | Local setup      |
| .github/workflows/deploy.yml | Never     | DevOps | CI/CD            |
| render.yaml                  | Rarely    | DevOps | Service config   |
| .streamlit/config.toml       | Sometimes | You    | Appearance       |

---

## 🚀 Next Steps

1. **Read** `QUICKSTART.md` (5 min)
2. **Test** Docker locally (10 min)
3. **Follow** `DEPLOYMENT_CHECKLIST.md` (50 min)
4. **Monitor** `DEPLOYMENT.md` for reference
5. **Deploy** to Render
6. **Share** your live app!

---

**Status**: ✅ Ready to Deploy  
**Last Updated**: April 2024  
**Version**: 1.0  
**License**: Same as project
