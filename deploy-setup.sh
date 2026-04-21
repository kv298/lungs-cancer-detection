#!/bin/bash
# Quick deployment script for Render

set -e

echo "🚀 Lung Cancer Detection - Render Deployment Setup"
echo "=================================================="
echo ""

# Check prerequisites
check_prerequisites() {
    echo "📋 Checking prerequisites..."
    
    if ! command -v git &> /dev/null; then
        echo "❌ Git is not installed. Please install Git first."
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    echo "✅ Git and Docker are installed"
}

# Test Docker build
test_docker_build() {
    echo ""
    echo "🐳 Testing Docker build..."
    
    if docker build -t lung-cancer-detection:test . --quiet; then
        echo "✅ Docker build successful"
        docker rmi lung-cancer-detection:test
    else
        echo "❌ Docker build failed. Check your Dockerfile."
        exit 1
    fi
}

# Create GitHub secrets documentation
create_secrets_doc() {
    echo ""
    echo "📝 GitHub Actions Secrets Required (for CI/CD):"
    echo "================================================"
    echo ""
    echo "Go to: GitHub repo → Settings → Secrets and variables → Actions"
    echo ""
    echo "Add these secrets:"
    echo ""
    echo "1. DOCKERHUB_USERNAME"
    echo "   └─ Your Docker Hub username"
    echo ""
    echo "2. DOCKERHUB_TOKEN"
    echo "   └─ Get from Docker Hub → Account Settings → Security"
    echo ""
    echo "3. RENDER_DEPLOY_HOOK"
    echo "   └─ Get from Render dashboard → Service Settings → Deploy Hook"
    echo ""
}

# Create Render setup documentation
create_render_doc() {
    echo ""
    echo "🚀 Render Setup Steps:"
    echo "===================="
    echo ""
    echo "1. Go to https://dashboard.render.com"
    echo "2. Click 'New +' → 'Web Service'"
    echo "3. Connect your GitHub repository"
    echo "4. Configure:"
    echo "   - Name: lung-cancer-detection"
    echo "   - Environment: Docker"
    echo "   - Instance Type: Standard (or higher)"
    echo "   - Auto-deploy: ON"
    echo ""
    echo "5. Render will automatically use:"
    echo "   - Dockerfile: ./Dockerfile"
    echo "   - Port: 8501"
    echo "   - Environment variables from render.yaml"
    echo ""
}

# Main execution
check_prerequisites
test_docker_build
create_secrets_doc
create_render_doc

echo ""
echo "✅ Setup check complete!"
echo ""
echo "Next steps:"
echo "1. Push your code to GitHub: git push origin main"
echo "2. Go to Render dashboard and create a new service"
echo "3. Your app will be live at: https://lung-cancer-detection.onrender.com"
echo ""
