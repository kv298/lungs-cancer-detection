# 📋 Complete Docker & Render Deployment Checklist

## Pre-Deployment Verification

### Local Testing

- [ ] Docker Desktop is running (Windows/Mac)
- [ ] `docker build -t lung-cancer-detection:latest .` succeeds
- [ ] `docker run -p 8501:8501 lung-cancer-detection:latest` works
- [ ] App accessible at http://localhost:8501
- [ ] All features work (model loading, predictions, UI)
- [ ] `docker-compose up` works correctly
- [ ] `docker-compose down` stops cleanly

### Code Quality

- [ ] No syntax errors in Python files
- [ ] `requirements.txt` is complete and tested
- [ ] All imports are available
- [ ] Models are in correct directories
- [ ] No hardcoded paths or credentials
- [ ] `.gitignore` excludes unnecessary files
- [ ] `.dockerignore` is optimized

### Git Setup

- [ ] GitHub account created
- [ ] Repository created on GitHub
- [ ] Local repository linked to GitHub
- [ ] Code committed: `git add .`
- [ ] Code committed: `git commit -m "Ready for deployment"`
- [ ] Pushed to main branch: `git push origin main`
- [ ] All files visible on GitHub

---

## GitHub Actions & Secrets Setup

### Docker Hub Setup (Optional but Recommended)

- [ ] Docker Hub account created (https://hub.docker.com)
- [ ] Personal access token created
- [ ] GitHub secret `DOCKERHUB_USERNAME` added
- [ ] GitHub secret `DOCKERHUB_TOKEN` added

### GitHub Secrets Configuration

1. Go to: GitHub Repo → Settings → Secrets and variables → Actions
2. Add:
   - [ ] `DOCKERHUB_USERNAME` (your Docker Hub username)
   - [ ] `DOCKERHUB_TOKEN` (Docker Hub personal access token)
   - [ ] `RENDER_DEPLOY_HOOK` (from Render service)

### Verify CI/CD Pipeline

- [ ] `.github/workflows/deploy.yml` exists
- [ ] Workflow file is syntactically correct
- [ ] Push to main triggers GitHub Actions
- [ ] Check Actions tab shows workflow run
- [ ] Workflow completes successfully (green checkmark)

---

## Render Deployment

### Render Service Creation

1. Go to https://dashboard.render.com
2. Click "New +" → "Web Service"
3. Select "Deploy an existing repository"
4. Enter GitHub URL: `https://github.com/YOUR_USERNAME/lung-cancer-detection`
5. Configure:
   - [ ] **Name:** `lung-cancer-detection`
   - [ ] **Environment:** `Docker`
   - [ ] **Dockerfile Path:** `./Dockerfile` (auto-detected)
   - [ ] **Instance Type:** `Standard` (minimum for ML)
   - [ ] **Auto-deploy:** Toggle ON
   - [ ] **Build Command:** (leave empty)
   - [ ] **Start Command:** (leave empty)

### Environment Variables on Render

Add these via Render dashboard Environment tab:

- [ ] `STREAMLIT_SERVER_HEADLESS=true`
- [ ] `STREAMLIT_SERVER_ENABLE_CORS=false`
- [ ] `STREAMLIT_LOGGER_LEVEL=info`
- [ ] `TF_CPP_MIN_LOG_LEVEL=3`
- [ ] `TF_USE_LEGACY_KERAS=1`
- [ ] `PYTHONUNBUFFERED=1`

### Get Render Deploy Hook

1. In Render service → Settings
2. Scroll to "Deploy Hook"
3. Copy the URL
4. Add to GitHub as `RENDER_DEPLOY_HOOK` secret

### Deploy Service

- [ ] Click "Create Web Service"
- [ ] Wait for initial build (5-10 minutes)
- [ ] Monitor Logs tab for any errors
- [ ] Verify health check passes
- [ ] App is live and accessible

---

## Verification & Testing

### Live Deployment Checks

1. Go to Render dashboard → Your service
   - [ ] Status shows "Live"
   - [ ] No errors in Logs
   - [ ] Health check status is "Healthy"

2. Access your app:
   - [ ] `https://lung-cancer-detection.onrender.com` loads
   - [ ] All pages are accessible
   - [ ] Features work correctly
   - [ ] Model predictions work
   - [ ] No errors in console

3. Check GitHub Actions:
   - [ ] Latest workflow run is successful
   - [ ] Docker build completed
   - [ ] Deployment hook triggered
   - [ ] Build time < 10 minutes

### Test Auto-Deployment

- [ ] Make a small code change
- [ ] Commit and push: `git push origin main`
- [ ] GitHub Actions starts automatically
- [ ] Render redeploys automatically
- [ ] Changes appear in live app

---

## Performance Optimization (Optional)

### For Better Performance

- [ ] Upgrade to "Standard" Render instance
- [ ] Enable Docker Hub caching in CI/CD
- [ ] Configure CDN if adding custom domain
- [ ] Set up monitoring and alerts
- [ ] Configure auto-scaling if needed

### Cost Optimization

- [ ] Use free tier Render instance if under usage limits
- [ ] Optimize Docker image size (current multi-stage build)
- [ ] Clean up old Docker images
- [ ] Monitor Render resource usage

---

## Troubleshooting Guide

| Issue                 | Check          | Fix                                      |
| --------------------- | -------------- | ---------------------------------------- |
| **Build fails**       | Render logs    | Run `docker build` locally, fix errors   |
| **App crashes**       | Render logs    | Check TensorFlow/dependency versions     |
| **Out of memory**     | Resource usage | Upgrade instance type                    |
| **Models not found**  | Git status     | `git add models/` and push               |
| **Port errors**       | render.yaml    | Should use 8501                          |
| **CORS errors**       | Logs           | Set `STREAMLIT_SERVER_ENABLE_CORS=false` |
| **Deploy hook fails** | GitHub Actions | Verify secret is set correctly           |

---

## Post-Deployment

### Ongoing Maintenance

- [ ] Monitor app performance weekly
- [ ] Check Render logs for errors
- [ ] Update dependencies monthly
- [ ] Test new features before pushing
- [ ] Keep GitHub repo clean

### Custom Domain (Optional)

- [ ] Purchase domain (if not owned)
- [ ] Add domain in Render settings
- [ ] Update DNS records
- [ ] Verify SSL certificate
- [ ] Test custom domain access

### Backup & Monitoring

- [ ] Set up GitHub releases for versions
- [ ] Document deployment process
- [ ] Create update checklist
- [ ] Set up monitoring alerts
- [ ] Plan rollback procedure

---

## Success Criteria ✅

- [ ] Docker builds successfully locally
- [ ] GitHub repo is up to date
- [ ] Render service is created and running
- [ ] App is live and accessible
- [ ] All features work correctly
- [ ] CI/CD pipeline is active
- [ ] Auto-deployment on push works

---

## Quick Command Reference

```bash
# Local testing
docker build -t lung-cancer-detection:latest .
docker run -p 8501:8501 lung-cancer-detection:latest
docker-compose up

# Git workflow
git add .
git commit -m "message"
git push origin main

# Check deployment
git log --oneline -5
```

---

## Support Resources

- 📚 Full Guide: [DOCKER_RENDER_DEPLOYMENT.md](DOCKER_RENDER_DEPLOYMENT.md)
- ⚡ Quick Start: [RENDER_QUICKSTART.md](RENDER_QUICKSTART.md)
- 🐳 Docker: https://docs.docker.com
- 🚀 Render: https://render.com/docs
- 📊 Streamlit: https://docs.streamlit.io

---

**Date Completed:** ******\_******
**Deployed By:** ********\_********
**App URL:** **********\_**********
