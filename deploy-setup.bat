#!/bin/bash
# Windows batch file for deployment setup

@echo off
setlocal enabledelayedexpansion

echo.
echo 🚀 Lung Cancer Detection - Render Deployment Setup
echo ==================================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git is not installed. Please install Git first.
    exit /b 1
)

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed. Please install Docker first.
    exit /b 1
)

echo ✅ Git and Docker are installed
echo.

REM Test Docker build
echo 🐳 Testing Docker build...
docker build -t lung-cancer-detection:test . -q >nul 2>&1

if errorlevel 1 (
    echo ❌ Docker build failed. Check your Dockerfile.
    exit /b 1
) else (
    echo ✅ Docker build successful
    docker rmi lung-cancer-detection:test >nul 2>&1
)

echo.
echo 📝 GitHub Actions Secrets Required (for CI/CD):
echo ================================================
echo.
echo Go to: GitHub repo → Settings → Secrets and variables → Actions
echo.
echo Add these secrets:
echo.
echo 1. DOCKERHUB_USERNAME
echo    └─ Your Docker Hub username
echo.
echo 2. DOCKERHUB_TOKEN
echo    └─ Get from Docker Hub → Account Settings → Security
echo.
echo 3. RENDER_DEPLOY_HOOK
echo    └─ Get from Render dashboard → Service Settings → Deploy Hook
echo.

echo.
echo 🚀 Render Setup Steps:
echo ====================
echo.
echo 1. Go to https://dashboard.render.com
echo 2. Click 'New +' → 'Web Service'
echo 3. Connect your GitHub repository
echo 4. Configure:
echo    - Name: lung-cancer-detection
echo    - Environment: Docker
echo    - Instance Type: Standard (or higher)
echo    - Auto-deploy: ON
echo.
echo 5. Render will automatically use:
echo    - Dockerfile: ./Dockerfile
echo    - Port: 8501
echo    - Environment variables from render.yaml
echo.

echo.
echo ✅ Setup check complete!
echo.
echo Next steps:
echo 1. Push your code to GitHub: git push origin main
echo 2. Go to Render dashboard and create a new service
echo 3. Your app will be live at: https://lung-cancer-detection.onrender.com
echo.

pause
