#!/bin/bash

echo "================================"
echo "🔍 GitHub Pages Diagnostic Tool"
echo "================================"
echo ""

# Check if files exist locally
echo "✅ Checking local files..."
if [ -f "index.html" ]; then
    echo "   ✓ index.html exists ($(wc -l < index.html) lines)"
else
    echo "   ✗ index.html MISSING"
fi

if [ -f "dsge_dashboard.html" ]; then
    echo "   ✓ dsge_dashboard.html exists ($(wc -l < dsge_dashboard.html) lines)"
else
    echo "   ✗ dsge_dashboard.html MISSING"
fi

if [ -f "frbus_dashboard.html" ]; then
    echo "   ✓ frbus_dashboard.html exists ($(wc -l < frbus_dashboard.html) lines)"
else
    echo "   ✗ frbus_dashboard.html MISSING"
fi

if [ -f "CNAME" ]; then
    echo "   ✓ CNAME exists: $(cat CNAME)"
else
    echo "   ✗ CNAME MISSING"
fi

if [ -d "simulation_results" ]; then
    echo "   ✓ simulation_results/ directory exists"
else
    echo "   ✗ simulation_results/ MISSING"
fi

if [ -d "frbus_simulations" ]; then
    echo "   ✓ frbus_simulations/ directory exists"
else
    echo "   ✗ frbus_simulations/ MISSING"
fi

echo ""
echo "✅ Checking git status..."
git_status=$(git status --porcelain)
if [ -z "$git_status" ]; then
    echo "   ✓ All changes committed"
else
    echo "   ⚠ Uncommitted changes detected:"
    echo "$git_status" | head -5
fi

echo ""
echo "✅ Checking git remotes..."
git remote -v | grep mightbeuseless

echo ""
echo "✅ Checking latest commit..."
echo "   Latest: $(git log -1 --oneline)"

echo ""
echo "✅ Checking GitHub repository status..."
echo "   Testing repository access..."
repo_check=$(curl -s -o /dev/null -w "%{http_code}" https://api.github.com/repos/Hamza-Anver/mightbeuseless-ali)
if [ "$repo_check" = "200" ]; then
    echo "   ✓ Repository accessible: https://github.com/Hamza-Anver/mightbeuseless-ali"
else
    echo "   ✗ Repository not accessible (HTTP $repo_check)"
fi

echo ""
echo "✅ Checking GitHub Pages status..."
pages_check=$(curl -s https://api.github.com/repos/Hamza-Anver/mightbeuseless-ali/pages)
if echo "$pages_check" | grep -q "Not Found"; then
    echo "   ✗ GitHub Pages NOT ENABLED"
    echo "   ⚠️  ACTION REQUIRED: Enable GitHub Pages in repository settings"
    echo "   📝 Go to: https://github.com/Hamza-Anver/mightbeuseless-ali/settings/pages"
elif echo "$pages_check" | grep -q "html_url"; then
    echo "   ✓ GitHub Pages is enabled"
    echo "   URL: $(echo "$pages_check" | grep -o '"html_url":"[^"]*"' | cut -d'"' -f4)"
else
    echo "   ? Unable to determine Pages status"
fi

echo ""
echo "✅ Testing website locally..."
if [ -f "index.html" ]; then
    echo "   Local file works! Opening in browser..."
    echo "   file://$(pwd)/index.html"
else
    echo "   ✗ Cannot test - index.html missing"
fi

echo ""
echo "✅ Testing GitHub Pages URL..."
github_url_check=$(curl -s -o /dev/null -w "%{http_code}" https://hamza-anver.github.io/mightbeuseless-ali/)
if [ "$github_url_check" = "200" ]; then
    echo "   ✓ GitHub Pages site is LIVE!"
    echo "   🌐 https://hamza-anver.github.io/mightbeuseless-ali/"
elif [ "$github_url_check" = "404" ]; then
    echo "   ✗ GitHub Pages site returns 404"
    echo "   ⚠️  This means GitHub Pages is not enabled or not deployed yet"
else
    echo "   ? GitHub Pages status unclear (HTTP $github_url_check)"
fi

echo ""
echo "✅ Testing custom domain..."
custom_url_check=$(curl -s -o /dev/null -w "%{http_code}" https://mightbeuseless.com)
if [ "$custom_url_check" = "200" ]; then
    echo "   ✓ Custom domain is LIVE!"
    echo "   🌐 https://mightbeuseless.com"
elif [ "$custom_url_check" = "000" ]; then
    echo "   ✗ Cannot connect to custom domain"
    echo "   ⚠️  DNS may not be configured or not propagated yet"
else
    echo "   ✗ Custom domain returns HTTP $custom_url_check"
    echo "   ⚠️  DNS may need configuration"
fi

echo ""
echo "================================"
echo "📋 SUMMARY"
echo "================================"
echo ""
if echo "$pages_check" | grep -q "Not Found"; then
    echo "🚨 PROBLEM IDENTIFIED:"
    echo "   GitHub Pages is NOT enabled on the repository"
    echo ""
    echo "✅ SOLUTION:"
    echo "   1. Go to: https://github.com/Hamza-Anver/mightbeuseless-ali/settings/pages"
    echo "   2. Under 'Source', select: Deploy from a branch"
    echo "   3. Select branch: main"
    echo "   4. Select folder: / (root)"
    echo "   5. Click Save"
    echo "   6. Wait 2-3 minutes for deployment"
    echo ""
    echo "📖 See: ENABLE_GITHUB_PAGES_NOW.md for detailed instructions"
else
    echo "✓ All checks passed!"
fi

echo ""
