@echo off
REM Lung Cancer Detection - Docker & Render Deployment Setup Script for Windows

setlocal enabledelayedexpansion

echo.
echo ================================
echo Lung Cancer Detection Deployment
echo ================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo X Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)
echo √ Docker is installed

REM Check if Git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo X Git is not installed. Please install Git first.
    pause
    exit /b 1
)
echo √ Git is installed

REM Check Docker daemon
docker ps >nul 2>&1
if errorlevel 1 (
    echo X Docker daemon is not running. Please start Docker Desktop.
    pause
    exit /b 1
)
echo √ Docker daemon is running

echo.
echo Menu - Choose deployment type:
echo 1) Local Docker testing only
echo 2) Full deployment (GitHub + Docker + Render)
echo.
set /p CHOICE="Enter choice [1-2]: "

if "%CHOICE%"=="1" (
    echo.
    echo Setting up for local Docker testing...
    echo.
    echo Step 1: Build Docker image
    echo $ docker build -t lung-cancer-detection:latest .
    echo.
    set /p BUILD="Build now? (y/n): "
    if /i "!BUILD!"=="y" (
        docker build -t lung-cancer-detection:latest .
        echo √ Docker image built successfully
    )
    echo.
    echo Step 2: Run the container
    echo $ docker-compose up -d
    echo.
    set /p RUN="Run now? (y/n): "
    if /i "!RUN!"=="y" (
        docker-compose up -d
        echo √ Container started
        echo.
        echo Your app is running at: http://localhost:8501
        echo View logs with: docker-compose logs -f
        echo Stop with: docker-compose down
    )
) else if "%CHOICE%"=="2" (
    echo.
    echo Full deployment setup (GitHub + Docker + Render)...
    echo.
    
    REM Initialize Git
    echo Setting up Git repository...
    if not exist ".git" (
        git init
        echo √ Git repository initialized
    ) else (
        echo Note: Git repository already exists
    )
    
    REM Get GitHub credentials
    echo.
    set /p GITHUB_USERNAME="Enter your GitHub username: "
    set /p REPO_NAME="Enter GitHub repository name [lung-cancer-detection]: "
    if "!REPO_NAME!"=="" set REPO_NAME=lung-cancer-detection
    
    REM Get Docker Hub credentials
    echo.
    echo Docker Hub credentials (optional, for automated builds)
    set /p DOCKER_USERNAME="Docker Hub username [optional]: "
    
    REM Stage and commit
    echo.
    echo Staging files...
    git add .
    git commit -m "Initial commit: Lung cancer detection with Docker and CI/CD" || echo Note: No new files to commit
    echo √ Files staged and committed
    
    REM Add remote
    echo Setting up GitHub remote...
    set GITHUB_URL=https://github.com/!GITHUB_USERNAME!/!REPO_NAME!.git
    git remote remove origin 2>nul || echo.
    git remote add origin "!GITHUB_URL!"
    echo √ GitHub remote added: !GITHUB_URL!
    
    REM Rename to main
    echo Setting main branch...
    git branch -M main 2>nul || echo Note: Already on main branch
    echo √ Branch set to main
    
    REM Summary
    echo.
    echo ================================
    echo √ Setup complete!
    echo ================================
    echo.
    echo Next steps:
    echo.
    echo 1. Create GitHub repository:
    echo    - Go to https://github.com/new
    echo    - Name: !REPO_NAME!
    echo    - Click 'Create repository'
    echo.
    echo 2. Push code to GitHub:
    echo    $ git push -u origin main
    echo.
    echo 3. Set up GitHub Secrets:
    echo    - Go to https://github.com/!GITHUB_USERNAME!/!REPO_NAME!/settings/secrets/actions
    echo    - Add secrets:
    if not "!DOCKER_USERNAME!"=="" (
        echo      DOCKERHUB_USERNAME = !DOCKER_USERNAME!
        echo      DOCKERHUB_TOKEN = (your token)
    ) else (
        echo      DOCKERHUB_USERNAME = (your Docker Hub username)
        echo      DOCKERHUB_TOKEN = (your Docker Hub token)
    )
    echo      RENDER_DEPLOY_HOOK = (get from Render after creating service)
    echo.
    echo 4. Deploy to Render:
    echo    - Go to https://dashboard.render.com
    echo    - Click 'New' ^> 'Web Service'
    echo    - Connect GitHub repository
    echo    - Set Environment: Docker
    echo    - Set Start Command:
    echo      streamlit run app.py --server.port=8501 --server.address=0.0.0.0
    echo    - Add environment variables (see DEPLOYMENT.md)
    echo    - Click 'Create Web Service'
    echo.
    echo 5. Test locally before pushing:
    echo    $ docker-compose up -d
    echo    Open: http://localhost:8501
    echo.
    echo For detailed instructions, see DEPLOYMENT.md
) else (
    echo Invalid choice. Exiting.
    exit /b 1
)

echo.
echo √ Setup complete!
pause
