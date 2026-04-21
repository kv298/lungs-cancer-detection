# Quick Start: Docker Deployment to Render

## TL;DR - 5 Minute Setup

### 1. Test Locally (5 min)

```bash
# Build Docker image
docker build -t lung-cancer-detection:latest .

# Run with docker-compose
docker-compose up -d

# Open browser: http://localhost:8501

# Stop
docker-compose down
```

### 2. Push to GitHub (5 min)

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/lung-cancer-detection.git
git branch -M main
git push -u origin main
```

### 3. Deploy to Render (5 min)

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **New** → **Web Service** → **Connect GitHub repo**
3. Select `lung-cancer-detection` repository
4. Set **Environment**: Docker
5. Set **Start Command**: `streamlit run app.py --server.port=8501 --server.address=0.0.0.0`
6. Add environment variables:
   ```
   STREAMLIT_SERVER_HEADLESS=true
   TF_USE_LEGACY_KERAS=1
   ```
7. Click **Create Web Service**
8. Wait 5-10 minutes for build and deployment

✅ **Done!** Your app is live at `https://lung-cancer-detection.onrender.com`

---

## Full Details

See [DEPLOYMENT.md](DEPLOYMENT.md) for complete step-by-step guide.

---

## What Each File Does

| File                           | Purpose                               |
| ------------------------------ | ------------------------------------- |
| `Dockerfile`                   | Builds Docker container image         |
| `docker-compose.yml`           | Local development environment         |
| `.dockerignore`                | Excludes unnecessary files from image |
| `.github/workflows/deploy.yml` | Auto-deploys on git push              |
| `render.yaml`                  | Render deployment configuration       |
| `.streamlit/config.toml`       | Streamlit settings                    |

---

## Common Commands

### Docker

```bash
docker build -t lung-cancer:latest .
docker run -p 8501:8501 lung-cancer:latest
docker-compose up -d
docker-compose logs -f
docker-compose down
```

### Git

```bash
git add .
git commit -m "message"
git push origin main
```

---

## Troubleshooting

| Issue                   | Solution                                          |
| ----------------------- | ------------------------------------------------- |
| Models not found        | Check files exist in repo: `models/`, `datasets/` |
| Docker build fails      | `docker system prune -a` then rebuild             |
| Can't push to GitHub    | Check git remote: `git remote -v`                 |
| Large files (>100MB)    | Use Git LFS: `git lfs track "*.h5"`               |
| Render deployment fails | Check Render logs for error details               |

---

## Cost

- GitHub: FREE ✅
- Docker Hub: FREE ✅
- Render: FREE tier (750 hrs/mo) or $7/mo (always on)

---

## Need Help?

1. Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed steps
2. View Render logs at dashboard
3. Check GitHub Actions output
4. Ensure environment variables are set correctly

---

**Status**: ✅ Ready to Deploy
