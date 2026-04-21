# 🚀 Deploy to Render - Quick Start Guide

## Prerequisites

- GitHub account with this repository
- Render account (free at https://render.com)
- Docker Desktop running (Windows/Mac) or Docker installed (Linux)

---

## ⚡ Quick Steps (5 minutes)

### Step 1: Ensure Code is on GitHub

```bash
git add .
git commit -m "Ready for Render deployment"
git push origin main
```

### Step 2: Create Render Service

1. Go to https://dashboard.render.com
2. Click **"New +"** → **"Web Service"**
3. Select **"Deploy an existing repository"**
4. Paste your GitHub repo URL:
   ```
   https://github.com/YOUR_USERNAME/lung-cancer-detection.git
   ```
5. Click **"Connect"**

### Step 3: Configure Service

Fill in the fields:

- **Name:** `lung-cancer-detection`
- **Environment:** `Docker`
- **Instance Type:** `Standard` (must for ML model)
- **Auto-deploy:** Toggle ON
- Leave **Build Command** empty
- Leave **Start Command** empty

### Step 4: Add Environment Variables

Click **"Environment"** and add:

```
STREAMLIT_SERVER_HEADLESS=true
STREAMLIT_SERVER_ENABLE_CORS=false
STREAMLIT_LOGGER_LEVEL=info
TF_CPP_MIN_LOG_LEVEL=3
TF_USE_LEGACY_KERAS=1
```

### Step 5: Deploy

Click **"Create Web Service"** and wait 5-10 minutes for deployment.

---

## ✅ Verify Deployment

1. Go to Render dashboard
2. Click your service
3. Watch the **Logs** tab
4. Once deployed, visit: `https://lung-cancer-detection.onrender.com`

---

## 🔄 Auto-Deploy on Code Push

Your app will automatically redeploy whenever you push to `main`:

```bash
git push origin main  # Automatic deployment triggered!
```

---

## 📊 View Live Logs

**In Render Dashboard:**

- Service page → Logs tab → See real-time logs
- Common issues will appear here

---

## 🐳 Test Locally Before Deploying

### With Docker Compose (Easiest):

```bash
docker-compose up
```

Visit: `http://localhost:8501`

### With Docker:

```bash
docker build -t lung-cancer-detection:latest .
docker run -p 8501:8501 lung-cancer-detection:latest
```

### With Python (Direct):

```bash
pip install -r requirements.txt
streamlit run app.py
```

---

## 🆘 Troubleshooting

| Issue                  | Solution                                      |
| ---------------------- | --------------------------------------------- |
| **Build fails**        | Check logs in Render → increase instance type |
| **App crashes**        | View logs in Render dashboard for errors      |
| **Out of memory**      | Upgrade to larger instance type               |
| **Models not loading** | Ensure files are committed to Git             |
| **TensorFlow errors**  | Use "Standard" instance or larger             |
| **Port 8501 errors**   | Render uses 8501 automatically                |

---

## 💡 Pro Tips

1. **Custom Domain:** Add custom domain in Render service settings
2. **Free SSL:** Render provides free HTTPS
3. **Monitoring:** Check "Health" tab for uptime
4. **Rollback:** Previous versions available in deploy history
5. **Scaling:** Upgrade instance type anytime without redeploying

---

## 📚 Full Documentation

For detailed info, see: `DOCKER_RENDER_DEPLOYMENT.md`

---

## 🎯 Your App URLs

Once deployed:

- **Default:** `https://lung-cancer-detection.onrender.com`
- **Custom domain:** `https://yourdomain.com` (if configured)

---

**Questions?**

- Render Docs: https://render.com/docs
- Streamlit Docs: https://docs.streamlit.io
- Check Render logs for specific errors
