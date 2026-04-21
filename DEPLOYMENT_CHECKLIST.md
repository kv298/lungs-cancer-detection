# Deployment Checklist & Overview

Complete step-by-step checklist for deploying Lung Cancer Detection app to Render.

## 📋 Deployment Architecture

```
┌─────────────────┐
│   GitHub Repo   │
│  (Your Code)    │
└────────┬────────┘
         │ (On Push)
         ▼
┌─────────────────────────────┐
│  GitHub Actions (CI/CD)      │
│  - Build Docker Image       │
│  - Push to Docker Hub       │
│  - Trigger Render Deploy    │
└────────┬────────────────────┘
         │
    ┌────▼─────────────────┐
    │                      │
    ▼                      ▼
┌──────────────┐    ┌────────────────┐
│  Docker Hub  │    │  Render.com    │
│  (Registry)  │    │  (Hosting)     │
└──────────────┘    └────────┬───────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Live App        │
                    │  lung-cancer...  │
                    │  .onrender.com   │
                    └──────────────────┘
```

---

## ✅ Pre-Deployment Checklist

### Required Accounts

- [ ] GitHub Account (free at github.com)
- [ ] Docker Hub Account (free at hub.docker.com)
- [ ] Render Account (free at render.com)

### Installed Software

- [ ] Docker Desktop installed and running
- [ ] Git installed on your computer
- [ ] All model files present:
  - [ ] `models/final_model.sav`
  - [ ] `models/keras_model.h5`
  - [ ] `cnn model/lungcancer_model_cnn.h5`
- [ ] All dataset files present:
  - [ ] `datasets/data.csv`
  - [ ] `datasets/train.csv`
  - [ ] `datasets/test.csv`
- [ ] Image files present:
  - [ ] `images/lung-cancer.jpg`
  - [ ] `images/menwa.png`
  - [ ] `images/stove.png`

---

## 🐳 Phase 1: Local Docker Testing (15 minutes)

### Step 1: Build Docker Image

```bash
cd path/to/Lung_Cancer_Streamlit-main
docker build -t lung-cancer-detection:latest .
```

Expected output:

- ✓ Image successfully built
- ✓ Size: ~2-3 GB (normal)
- ✓ No errors in build log

### Step 2: Run Container Locally

```bash
docker-compose up -d
```

Expected output:

- ✓ Service starts without errors
- ✓ "lung-cancer-detection is up"

### Step 3: Test the App

- [ ] Open http://localhost:8501
- [ ] Verify all pages load correctly:
  - [ ] Introduction page loads
  - [ ] Dataset analysis works
  - [ ] Predictions function
  - [ ] CNN model works
- [ ] Test predictions with sample data
- [ ] No error messages in browser console

### Step 4: Stop Container

```bash
docker-compose down
```

✅ **Phase 1 Complete** - Docker works locally!

---

## 📤 Phase 2: Push to GitHub (15 minutes)

### Step 1: Initialize Git (if not done)

```bash
git init
git add .
git commit -m "Initial commit: Lung cancer detection with Docker and CI/CD"
```

### Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Fill in details:
   - [ ] Repository name: `lung-cancer-detection`
   - [ ] Description: "Lung Cancer Detection using ML"
   - [ ] Public (free) or Private (requires paid GitHub)
   - [ ] DO NOT initialize with README
3. Click "Create repository"

### Step 3: Connect Local Repo to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/lung-cancer-detection.git
git branch -M main
git push -u origin main
```

### Step 4: Verify on GitHub

1. Go to your repository on GitHub
2. Verify all files are present
3. Check that `.github/workflows/deploy.yml` is there

✅ **Phase 2 Complete** - Code is on GitHub!

---

## 🔐 Phase 3: Configure GitHub Secrets (10 minutes)

### Step 1: Get Docker Hub Token

1. Log in to Docker Hub: https://hub.docker.com
2. Click your username → Account Settings → Security
3. Click "New Access Token"
4. Create token named `lung-cancer-ci`
5. Copy the token (you'll use it below)

### Step 2: Add GitHub Secrets

1. Go to your repository: https://github.com/YOUR_USERNAME/lung-cancer-detection
2. Click Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add three secrets:

#### Secret 1: DOCKERHUB_USERNAME

- Name: `DOCKERHUB_USERNAME`
- Value: Your Docker Hub username
- [ ] Added

#### Secret 2: DOCKERHUB_TOKEN

- Name: `DOCKERHUB_TOKEN`
- Value: Token from Docker Hub (step 1)
- [ ] Added

#### Secret 3: RENDER_DEPLOY_HOOK

- Name: `RENDER_DEPLOY_HOOK`
- Value: (You'll get this after creating Render service - add it later)
- [ ] Added

✅ **Phase 3 Complete** - Secrets configured!

---

## 🚀 Phase 4: Deploy to Render (20 minutes)

### Step 1: Create Render Account

1. Go to https://render.com
2. Sign up (use GitHub account for easier setup)
3. Verify email

### Step 2: Create Web Service

1. Go to https://dashboard.render.com
2. Click "New" → "Web Service"
3. Click "Build and deploy from a Git repository"

### Step 3: Connect GitHub Repository

1. Click "Connect GitHub account" (if needed)
2. Find repository `lung-cancer-detection`
3. Click "Connect"

### Step 4: Configure Service

Fill in the following on Render:

| Field             | Value                                                              |
| ----------------- | ------------------------------------------------------------------ |
| **Name**          | `lung-cancer-detection`                                            |
| **Environment**   | `Docker`                                                           |
| **Branch**        | `main`                                                             |
| **Build Command** | (leave empty)                                                      |
| **Start Command** | `streamlit run app.py --server.port=8501 --server.address=0.0.0.0` |

- [ ] Configuration saved

### Step 5: Add Environment Variables

Click **Advanced** section and add:

```
STREAMLIT_SERVER_HEADLESS=true
STREAMLIT_SERVER_ENABLE_CORS=false
TF_CPP_MIN_LOG_LEVEL=3
TF_USE_LEGACY_KERAS=1
PORT=8501
```

- [ ] All variables added

### Step 6: Choose Plan

- [ ] Free Plan (sufficient for testing, auto-stops after 15 min inactivity)
- [ ] Paid Plan ($7/month+, always running)

### Step 7: Deploy

1. Click "Create Web Service"
2. Render will start building
3. Wait 5-10 minutes for completion
4. You'll get a URL like: `https://lung-cancer-detection-xxxxxx.onrender.com`

- [ ] Deployment successful
- [ ] Web URL assigned

### Step 8: Add Deploy Hook to GitHub Secrets

1. In Render dashboard, go to your service settings
2. Find "Deploy Hook" section
3. Copy the hook URL
4. Go to GitHub → Settings → Secrets and variables → Actions
5. Update `RENDER_DEPLOY_HOOK` secret with this URL

- [ ] Deploy hook URL added to GitHub

### Step 9: Test the Deployment

1. Click the Render service URL
2. Verify the app loads
3. Test the same things you tested locally:
   - [ ] Introduction page works
   - [ ] Dataset analysis loads
   - [ ] Predictions function
   - [ ] No errors

✅ **Phase 4 Complete** - App is live!

---

## 🔄 Phase 5: Verify CI/CD Pipeline (5 minutes)

### Step 1: Test Automatic Deployment

1. Make a small change to `README.md`
2. Commit and push:
   ```bash
   git add README.md
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```

### Step 2: Monitor Deployment

1. Go to GitHub Actions: https://github.com/YOUR_USERNAME/lung-cancer-detection/actions
2. Watch the workflow run
3. Should see:
   - [ ] Checkout code ✓
   - [ ] Build Docker image ✓
   - [ ] Push to Docker Hub ✓
   - [ ] Deploy to Render ✓

### Step 3: Verify Live Update

1. Go to Render dashboard
2. Check service logs for deployment activity
3. Verify your app is still running

✅ **Phase 5 Complete** - CI/CD pipeline working!

---

## 📊 Monitoring & Maintenance

### Daily Monitoring

- [ ] Check app availability: Visit your live URL
- [ ] Monitor Render dashboard for errors
- [ ] Check GitHub Actions for any failed workflows

### Weekly Maintenance

- [ ] Review Render logs for errors
- [ ] Check Docker Hub for image updates
- [ ] Monitor storage usage

### Monthly Maintenance

- [ ] Update dependencies in `requirements.txt`
- [ ] Check for security updates
- [ ] Review usage metrics on Render

---

## 🆘 Troubleshooting Guide

### Docker Build Fails

**Error**: `failed to solve with frontend dockerfile.v0`

**Solution**:

```bash
docker system prune -a
docker build -t lung-cancer-detection:latest . --no-cache
```

### Models Not Found

**Error**: `FileNotFoundError: models/final_model.sav`

**Solution**:

1. Ensure files exist locally:
   ```bash
   ls -la models/
   ```
2. If files are >100MB, use Git LFS:
   ```bash
   git lfs install
   git lfs track "*.h5" "*.sav"
   git add .gitattributes
   git commit -m "Add Git LFS"
   git push
   ```

### GitHub Actions Fails

**Error**: `secret DOCKERHUB_TOKEN not found`

**Solution**:

1. Go to GitHub Settings → Secrets
2. Verify all three secrets exist:
   - DOCKERHUB_USERNAME
   - DOCKERHUB_TOKEN
   - RENDER_DEPLOY_HOOK
3. Re-run workflow

### Render Deployment Fails

**Error**: `Build failed` or `Service crashed`

**Solution**:

1. Check Render logs (Dashboard → Logs tab)
2. Common issues:
   - Out of memory → Upgrade to paid plan
   - Missing environment variables → Re-add them
   - Port binding error → Check start command

### App Runs Locally but Not on Render

**Solution**:

1. Check environment variables on Render
2. Verify all files are in Git
3. Check Render logs for specific errors
4. Rebuild: Click "Manual Deploy" on Render

---

## 📈 Performance Optimization

### Reduce Image Size

Current image size: ~2-3 GB

To optimize:

1. Remove unused dependencies from `requirements.txt`
2. Remove unnecessary data files
3. Use `.dockerignore` to exclude files

### Faster Startup

Add to Render environment:

```
TF_CPP_MIN_LOG_LEVEL=3
TF_FORCE_GPU_ALLOW_GROWTH=true
```

### Reduce Memory Usage

For free Render tier:

1. Lazy load models
2. Use model compression
3. Reduce dataset size for demos

---

## 📞 Support & Resources

| Resource        | Link                               |
| --------------- | ---------------------------------- |
| Docker Docs     | https://docs.docker.com            |
| Render Docs     | https://render.com/docs            |
| GitHub Actions  | https://docs.github.com/en/actions |
| Streamlit Docs  | https://docs.streamlit.io          |
| TensorFlow Docs | https://www.tensorflow.org/guide   |

---

## ✨ Next Steps After Deployment

1. **Add custom domain** (optional)
   - Go to Render service settings
   - Add custom domain
   - Follow DNS setup

2. **Enable auto-restart**
   - Render automatically restarts on crashes
   - Already enabled by default

3. **Set up monitoring alerts**
   - Monitor app performance
   - Set up error notifications

4. **Create documentation**
   - Add usage instructions
   - Document API endpoints (if any)

5. **Gather feedback**
   - Share app with users
   - Collect usage data
   - Iterate improvements

---

## 📝 Deployment Summary

| Component      | Status | URL/Details                                          |
| -------------- | ------ | ---------------------------------------------------- |
| GitHub Repo    | ✅     | `github.com/YOUR_USERNAME/lung-cancer-detection`     |
| Docker Image   | ✅     | `hub.docker.com/YOUR_USERNAME/lung-cancer-detection` |
| CI/CD Pipeline | ✅     | GitHub Actions (automatic on push)                   |
| Live App       | ✅     | `https://lung-cancer-detection-xxxxxx.onrender.com`  |
| Monitoring     | ✅     | Render Dashboard                                     |

---

## 🎉 Congratulations!

Your Lung Cancer Detection app is now:

- ✅ Containerized with Docker
- ✅ Version controlled with Git
- ✅ Automated with CI/CD
- ✅ Deployed on Render
- ✅ Monitoring and logging enabled
- ✅ Accessible globally

**Your app URL**: `https://lung-cancer-detection-xxxxxx.onrender.com`

---

**Last Updated**: April 2024  
**Status**: Ready for Production  
**Support**: Check DEPLOYMENT.md for detailed guidance
