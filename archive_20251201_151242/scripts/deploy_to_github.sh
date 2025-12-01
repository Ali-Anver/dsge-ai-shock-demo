#!/bin/bash
# Automated deployment script for GitHub Pages
# This prepares your files for deployment to mightbeuseless.com

set -e  # Exit on error

echo "======================================"
echo "DSGE AI Shock - GitHub Pages Deployment"
echo "======================================"
echo ""

# Check if in correct directory
if [ ! -f "interactive_dashboard.html" ]; then
    echo "❌ Error: interactive_dashboard.html not found!"
    echo "Please run this script from the project root directory."
    exit 1
fi

# Check if simulation data exists
if [ ! -f "simulation_results/simulation_data.json" ]; then
    echo "❌ Error: Simulation data not found!"
    echo "Please run: julia run_parameter_sweep.jl"
    exit 1
fi

echo "✅ Found simulation data ($(ls -lh simulation_results/simulation_data.json | awk '{print $5}'))"
echo ""

# Step 1: Create index.html
echo "📝 Step 1: Creating index.html..."
cp interactive_dashboard.html index.html
echo "✅ Created index.html from interactive_dashboard.html"
echo ""

# Step 2: Create .gitignore
echo "📝 Step 2: Creating .gitignore..."
cat > .gitignore << 'EOF'
# Local server logs
*.log
nohup.out

# macOS
.DS_Store

# Julia
*.jl.*.cov
*.jl.cov
*.jl.mem
deps/deps.jl

# Editor
.vscode/
.idea/

# Temporary files
*~
*.swp
*.swo

# Don't push the entire DSGE.jl repo (too large)
DSGE.jl/

# Keep only essential files for web deployment
Untitled-*.jl
check_julia.sh
launch_dashboard.sh
quick_*.sh
run_examples.sh
test_fred_api.jl
quick_demo_with_data.jl
simple_dsge_demo.jl
parameter_sweep_simulation.jl
NY-FED.jl
sweep_output.log
EOF
echo "✅ Created .gitignore"
echo ""

# Step 3: Rename README
echo "📝 Step 3: Preparing README..."
if [ -f "README_GITHUB.md" ]; then
    cp README.md README_LOCAL.md 2>/dev/null || true
    cp README_GITHUB.md README.md
    echo "✅ Using README_GITHUB.md as README.md"
else
    echo "⚠️  README_GITHUB.md not found, keeping existing README.md"
fi
echo ""

# Step 4: Initialize git (if needed)
echo "📝 Step 4: Checking git repository..."
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    echo "✅ Git initialized"
else
    echo "✅ Git repository already exists"
fi
echo ""

# Step 5: Get GitHub username
echo "📝 Step 5: GitHub Configuration"
echo ""
echo "Please enter your GitHub username:"
read -p "Username: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "❌ GitHub username is required!"
    exit 1
fi

echo ""
echo "Repository name (default: dsge-ai-shock-demo):"
read -p "Repo name: " REPO_NAME
REPO_NAME=${REPO_NAME:-dsge-ai-shock-demo}

echo ""
echo "✅ GitHub URL: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""

# Step 6: Add files to git
echo "📝 Step 6: Adding files to git..."
git add index.html
git add simulation_results/
git add README.md
git add DASHBOARD_GUIDE.md
git add SIMULATION_COMPLETE.md
git add TROUBLESHOOTING.md
git add DEPLOYMENT_GUIDE.md
git add DASHBOARD_FIX.md
git add SETUP_GUIDE.md
git add run_parameter_sweep.jl
git add .gitignore

echo "✅ Files staged for commit"
echo ""

# Step 7: Commit
echo "📝 Step 7: Creating commit..."
if git diff --cached --quiet; then
    echo "⚠️  No changes to commit"
else
    git commit -m "Deploy DSGE AI Shock Interactive Dashboard

- Interactive web dashboard with 125 economic scenarios
- Real-time parameter adjustment via sliders
- Plotly.js visualizations for GDP, consumption, investment, wages, returns
- AI productivity shock analysis at period 25
- Ready for GitHub Pages deployment at mightbeuseless.com"
    echo "✅ Commit created"
fi
echo ""

# Step 8: Add remote
echo "📝 Step 8: Configuring remote repository..."
if git remote get-url origin >/dev/null 2>&1; then
    echo "⚠️  Remote 'origin' already exists:"
    git remote get-url origin
    echo ""
    echo "Do you want to update it? (y/n)"
    read -p "> " UPDATE_REMOTE
    if [ "$UPDATE_REMOTE" = "y" ]; then
        git remote set-url origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
        echo "✅ Remote updated"
    fi
else
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
    echo "✅ Remote added"
fi
echo ""

# Step 9: Push to GitHub
echo "📝 Step 9: Ready to push to GitHub"
echo ""
echo "⚠️  IMPORTANT: Before pushing, make sure you've created the repository on GitHub:"
echo "   1. Go to: https://github.com/new"
echo "   2. Repository name: $REPO_NAME"
echo "   3. Make it PUBLIC (required for free GitHub Pages)"
echo "   4. Do NOT initialize with README"
echo "   5. Click 'Create repository'"
echo ""
echo "Have you created the repository on GitHub? (y/n)"
read -p "> " REPO_CREATED

if [ "$REPO_CREATED" != "y" ]; then
    echo ""
    echo "Please create the repository first, then run:"
    echo "  git branch -M main"
    echo "  git push -u origin main"
    exit 0
fi

echo ""
echo "Pushing to GitHub..."
git branch -M main
git push -u origin main

echo ""
echo "======================================"
echo "✅ DEPLOYMENT PREPARED!"
echo "======================================"
echo ""
echo "📊 Files Ready:"
echo "  ✅ index.html (dashboard)"
echo "  ✅ simulation_results/ (2.9 MB data)"
echo "  ✅ Documentation files"
echo ""
echo "🚀 Next Steps:"
echo ""
echo "1. Enable GitHub Pages:"
echo "   - Go to: https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages"
echo "   - Source: Branch 'main', folder '/ (root)'"
echo "   - Click Save"
echo ""
echo "2. Wait 1-2 minutes, then visit:"
echo "   https://$GITHUB_USER.github.io/$REPO_NAME/"
echo ""
echo "3. Configure Custom Domain (mightbeuseless.com):"
echo "   - Add DNS records at your domain registrar:"
echo "     • 4 A records pointing to GitHub IPs"
echo "     • CNAME record for www subdomain"
echo "   - In GitHub Pages settings, add custom domain: mightbeuseless.com"
echo "   - Wait for DNS propagation (24-48 hours)"
echo "   - Enable HTTPS once verified"
echo ""
echo "📚 Full instructions: See DEPLOYMENT_GUIDE.md"
echo ""
echo "======================================"
