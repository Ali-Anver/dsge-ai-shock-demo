# Deploying to GitHub Pages with Custom Domain

## 🌐 Goal
Host your interactive dashboard at **mightbeuseless.com** using GitHub Pages (free with GitHub Education).

## 📋 Prerequisites

- ✅ GitHub account with Education benefits
- ✅ Domain name: mightbeuseless.com
- ✅ Simulation data generated (simulation_results/*.json)
- ✅ Working dashboard (interactive_dashboard.html)

---

## Step 1: Create GitHub Repository

### Option A: Using GitHub Website

1. Go to https://github.com/new
2. Repository name: `dsge-ai-shock-demo` (or any name you prefer)
3. Description: "Interactive DSGE model exploring AI productivity shocks"
4. **Public** repository (required for GitHub Pages)
5. Do NOT initialize with README (we'll push existing files)
6. Click "Create repository"

### Option B: Using GitHub CLI (if installed)

```bash
gh repo create dsge-ai-shock-demo --public --description "Interactive DSGE AI shock analysis"
```

---

## Step 2: Prepare Files for Deployment

We need to rename `interactive_dashboard.html` to `index.html` (GitHub Pages default):

```bash
cd "/Users/alianver/Desktop/Other Research/DGSE-AI-Shock-Demo"

# Copy interactive_dashboard.html to index.html
cp interactive_dashboard.html index.html

# Create .gitignore to exclude unnecessary files
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

# Keep only essential files
Untitled-*.jl
EOF
```

---

## Step 3: Initialize Git and Push

```bash
cd "/Users/alianver/Desktop/Other Research/DGSE-AI-Shock-Demo"

# Initialize git (if not already)
git init

# Add files
git add index.html
git add simulation_results/
git add README_GITHUB.md
git add DASHBOARD_GUIDE.md
git add SIMULATION_COMPLETE.md
git add TROUBLESHOOTING.md
git add .gitignore

# Commit
git commit -m "Initial commit: DSGE AI Shock Interactive Dashboard"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/dsge-ai-shock-demo.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## Step 4: Enable GitHub Pages

### Via GitHub Website:

1. Go to your repository: `https://github.com/YOUR_USERNAME/dsge-ai-shock-demo`
2. Click **Settings** tab
3. Scroll down to **Pages** section (left sidebar)
4. Under "Source":
   - Branch: **main**
   - Folder: **/ (root)**
5. Click **Save**
6. Wait 1-2 minutes for deployment

You'll see: "Your site is published at `https://YOUR_USERNAME.github.io/dsge-ai-shock-demo/`"

---

## Step 5: Connect Custom Domain (mightbeuseless.com)

### A. Configure DNS at Your Domain Registrar

Go to your domain registrar (GoDaddy, Namecheap, etc.) and add these DNS records:

#### For Apex Domain (mightbeuseless.com):

Add **4 A records** pointing to GitHub's IPs:
```
Type: A
Name: @
Value: 185.199.108.153
TTL: 3600

Type: A
Name: @
Value: 185.199.109.153
TTL: 3600

Type: A
Name: @
Value: 185.199.110.153
TTL: 3600

Type: A
Name: @
Value: 185.199.111.153
TTL: 3600
```

#### For WWW Subdomain (www.mightbeuseless.com):

Add **CNAME record**:
```
Type: CNAME
Name: www
Value: YOUR_USERNAME.github.io
TTL: 3600
```

### B. Configure GitHub Pages

1. Back in GitHub repository **Settings** → **Pages**
2. Under "Custom domain", enter: `mightbeuseless.com`
3. Click **Save**
4. Wait for DNS check (can take 24-48 hours, usually faster)
5. Once verified, check **"Enforce HTTPS"** (recommended)

---

## Step 6: Verify Deployment

### Test URLs:

1. **GitHub Pages URL**: `https://YOUR_USERNAME.github.io/dsge-ai-shock-demo/`
2. **Custom Domain**: `https://mightbeuseless.com`
3. **WWW**: `https://www.mightbeuseless.com`

### What to Check:

- ✅ Dashboard loads without errors
- ✅ All 4 charts display data
- ✅ Sliders move smoothly
- ✅ Browser console shows: "Loaded 125 simulations"
- ✅ HTTPS works (green padlock)

---

## Troubleshooting

### Issue: 404 Page Not Found

**Solution**: Make sure you renamed `interactive_dashboard.html` to `index.html`

```bash
cp interactive_dashboard.html index.html
git add index.html
git commit -m "Add index.html for GitHub Pages"
git push
```

### Issue: Charts don't load data

**Solution**: Check browser console for errors. Path to JSON might need adjustment.

In `index.html`, verify the fetch path:
```javascript
const response = await fetch('simulation_results/simulation_data.json');
```

### Issue: Custom domain not working

**Solutions**:
1. Wait 24-48 hours for DNS propagation
2. Check DNS records at: https://dnschecker.org
3. Verify CNAME file exists in repository root (GitHub creates this automatically)
4. Try clearing browser cache

### Issue: HTTPS not available

**Solution**: 
1. Wait for DNS verification to complete
2. Then enable "Enforce HTTPS" in Settings → Pages
3. May take additional 24 hours to provision certificate

---

## File Size Considerations

Your `simulation_data.json` is 2.9 MB - this is fine for GitHub Pages!

- GitHub Pages limit: 1 GB per site
- File size limit: 100 MB per file
- Your data: ~3 MB total ✅

If you need to reduce size:
```bash
# Compress JSON (optional)
gzip -k simulation_results/simulation_data.json
# Then update fetch() to load .json.gz file
```

---

## Future Updates

To update the website:

```bash
# Make changes to your files
# Then:
git add .
git commit -m "Update simulation parameters"
git push

# Changes appear in ~1 minute
```

---

## Alternative: Use GitHub Pages from /docs folder

If you want to keep source files separate:

1. Create `/docs` folder
2. Move `index.html` and `simulation_results/` into `/docs`
3. In GitHub Settings → Pages, select "docs" folder instead of root
4. Everything else stays the same

---

## Cost

**Total Cost: $0** 🎉

- GitHub Pages: Free (especially with Education)
- HTTPS: Free (Let's Encrypt via GitHub)
- Bandwidth: Free (unlimited for reasonable use)
- Your only cost: Domain registration (~$10-15/year)

---

## Summary Commands

```bash
# 1. Prepare files
cd "/Users/alianver/Desktop/Other Research/DGSE-AI-Shock-Demo"
cp interactive_dashboard.html index.html

# 2. Initialize git (if needed)
git init
git add index.html simulation_results/ *.md .gitignore
git commit -m "Initial commit: DSGE AI Shock Dashboard"

# 3. Push to GitHub (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/dsge-ai-shock-demo.git
git branch -M main
git push -u origin main

# 4. Configure GitHub Pages (via website)
# 5. Add DNS records at domain registrar
# 6. Add custom domain in GitHub Pages settings
# 7. Wait for DNS propagation
# 8. Enable HTTPS
```

---

## Success Checklist

- [ ] GitHub repository created
- [ ] Files pushed to GitHub
- [ ] GitHub Pages enabled
- [ ] Site accessible at github.io URL
- [ ] DNS records configured at registrar
- [ ] Custom domain added in GitHub Pages
- [ ] DNS verification passed
- [ ] HTTPS enabled
- [ ] Dashboard loads and works correctly
- [ ] mightbeuseless.com shows your dashboard!

---

## Need Help?

- **GitHub Pages Docs**: https://docs.github.com/en/pages
- **Custom Domain Guide**: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site
- **DNS Checker**: https://dnschecker.org

---

**Ready to deploy? Let's get your dashboard online! 🚀**
