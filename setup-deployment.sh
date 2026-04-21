#!/bin/bash

# Lung Cancer Detection - Docker & Render Deployment Setup Script
# This script automates initial deployment configuration

set -e

echo "================================"
echo "Lung Cancer Detection Deployment"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check prerequisites
print_step "Checking prerequisites..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker Desktop first."
    exit 1
fi
print_success "Docker is installed"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi
print_success "Git is installed"

# Check Docker daemon
if ! docker ps &> /dev/null; then
    print_error "Docker daemon is not running. Please start Docker Desktop."
    exit 1
fi
print_success "Docker daemon is running"

echo ""
print_step "Choose deployment type:"
echo "1) Local Docker testing only"
echo "2) Full deployment (GitHub + Docker + Render)"
read -p "Enter choice [1-2]: " CHOICE

case $CHOICE in
    1)
        print_step "Setting up for local Docker testing..."
        echo ""
        echo "Step 1: Build Docker image"
        echo "$ docker build -t lung-cancer-detection:latest ."
        read -p "Build now? (y/n) " BUILD_CHOICE
        if [[ $BUILD_CHOICE =~ ^[Yy]$ ]]; then
            docker build -t lung-cancer-detection:latest .
            print_success "Docker image built successfully"
        fi
        echo ""
        echo "Step 2: Run the container"
        echo "$ docker-compose up -d"
        read -p "Run now? (y/n) " RUN_CHOICE
        if [[ $RUN_CHOICE =~ ^[Yy]$ ]]; then
            docker-compose up -d
            print_success "Container started"
            echo ""
            echo "Your app is running at: http://localhost:8501"
            echo "View logs with: docker-compose logs -f"
            echo "Stop with: docker-compose down"
        fi
        ;;
    2)
        print_step "Full deployment setup (GitHub + Docker + Render)..."
        echo ""
        
        # Initialize Git
        print_step "Setting up Git repository..."
        if [ ! -d ".git" ]; then
            git init
            print_success "Git repository initialized"
        else
            print_warning "Git repository already exists"
        fi
        
        # Get GitHub username
        echo ""
        read -p "Enter your GitHub username: " GITHUB_USERNAME
        
        # Get GitHub repo name
        read -p "Enter GitHub repository name [lung-cancer-detection]: " REPO_NAME
        REPO_NAME=${REPO_NAME:-lung-cancer-detection}
        
        # Get Docker Hub credentials
        echo ""
        print_step "Docker Hub credentials (optional, for automated builds)"
        read -p "Docker Hub username [optional]: " DOCKER_USERNAME
        if [ ! -z "$DOCKER_USERNAME" ]; then
            read -sp "Docker Hub token [leave empty to skip]: " DOCKER_TOKEN
            echo ""
        fi
        
        # Stage and commit
        print_step "Staging files..."
        git add .
        git commit -m "Initial commit: Lung cancer detection with Docker and CI/CD" || print_warning "No new files to commit"
        print_success "Files staged and committed"
        
        # Add remote
        print_step "Adding GitHub remote..."
        GITHUB_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
        git remote remove origin 2>/dev/null || true
        git remote add origin "$GITHUB_URL"
        print_success "GitHub remote added: $GITHUB_URL"
        
        # Rename to main
        print_step "Setting main branch..."
        git branch -M main 2>/dev/null || print_warning "Already on main branch"
        print_success "Branch set to main"
        
        # Summary
        echo ""
        echo "================================"
        print_success "Setup complete!"
        echo "================================"
        echo ""
        echo "Next steps:"
        echo ""
        echo "1. Create GitHub repository:"
        echo "   - Go to https://github.com/new"
        echo "   - Name: $REPO_NAME"
        echo "   - Click 'Create repository'"
        echo ""
        echo "2. Push code to GitHub:"
        echo "   $ git push -u origin main"
        echo ""
        echo "3. Set up GitHub Secrets:"
        echo "   - Go to https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/secrets/actions"
        echo "   - Add secrets:"
        if [ ! -z "$DOCKER_USERNAME" ]; then
            echo "     DOCKERHUB_USERNAME = $DOCKER_USERNAME"
            echo "     DOCKERHUB_TOKEN = (your token)"
        else
            echo "     DOCKERHUB_USERNAME = (your Docker Hub username)"
            echo "     DOCKERHUB_TOKEN = (your Docker Hub token)"
        fi
        echo "     RENDER_DEPLOY_HOOK = (get from Render after creating service)"
        echo ""
        echo "4. Deploy to Render:"
        echo "   - Go to https://dashboard.render.com"
        echo "   - Click 'New' → 'Web Service'"
        echo "   - Connect GitHub repository"
        echo "   - Set Environment: Docker"
        echo "   - Set Start Command:"
        echo "     streamlit run app.py --server.port=8501 --server.address=0.0.0.0"
        echo "   - Add environment variables (see DEPLOYMENT.md)"
        echo "   - Click 'Create Web Service'"
        echo ""
        echo "5. Test locally before pushing:"
        echo "   $ docker-compose up -d"
        echo "   Open: http://localhost:8501"
        echo ""
        echo "For detailed instructions, see DEPLOYMENT.md"
        ;;
    *)
        print_error "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
print_success "Setup complete!"
