#!/bin/bash
# Quick status checker for GitHub Pages deployment

echo "======================================"
echo "GitHub Pages Deployment Status Checker"
echo "======================================"
echo ""

# Repository info
GITHUB_USER="Ali-Anver"
REPO_NAME="dsge-ai-shock-demo"
DOMAIN="mightbeuseless.com"
GITHUB_URL="https://${GITHUB_USER}.github.io/${REPO_NAME}/"

echo "📦 Repository: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo "🌐 GitHub Pages URL: ${GITHUB_URL}"
echo "🎯 Custom Domain: ${DOMAIN}"
echo ""
echo "======================================"
echo "Checking Status..."
echo "======================================"
echo ""

# Check 1: Repository exists
echo "1. Repository Status:"
REPO_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://github.com/${GITHUB_USER}/${REPO_NAME}")
if [ "$REPO_STATUS" = "200" ]; then
    echo "   ✅ Repository exists"
else
    echo "   ❌ Repository not found (Status: $REPO_STATUS)"
fi
echo ""

# Check 2: GitHub Pages
echo "2. GitHub Pages Status:"
PAGES_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${GITHUB_URL}")
if [ "$PAGES_STATUS" = "200" ]; then
    echo "   ✅ GitHub Pages is LIVE!"
    echo "   🌐 Visit: ${GITHUB_URL}"
elif [ "$PAGES_STATUS" = "404" ]; then
    echo "   ❌ GitHub Pages NOT ENABLED"
    echo "   👉 Enable at: https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
    echo "   📝 Select: Branch 'main', Folder '/ (root)', then Save"
else
    echo "   ⚠️  Status unclear (HTTP $PAGES_STATUS)"
fi
echo ""

# Check 3: DNS Configuration
echo "3. DNS Configuration for ${DOMAIN}:"
DNS_RESULT=$(dig +short ${DOMAIN} @8.8.8.8 | head -4)
if [ -z "$DNS_RESULT" ]; then
    echo "   ❌ No DNS records found"
    echo "   👉 Add these A records at your domain registrar:"
    echo "      185.199.108.153"
    echo "      185.199.109.153"
    echo "      185.199.110.153"
    echo "      185.199.111.153"
else
    echo "   DNS A Records found:"
    echo "$DNS_RESULT" | while read -r line; do
        if echo "$line" | grep -q "185.199.10[89].[0-9]*\|185.199.11[01].[0-9]*"; then
            echo "   ✅ $line (GitHub IP)"
        else
            echo "   ⚠️  $line (Not a GitHub IP)"
        fi
    done
fi
echo ""

# Check 4: WWW CNAME
echo "4. WWW Subdomain:"
WWW_RESULT=$(dig +short www.${DOMAIN} @8.8.8.8)
if [ -z "$WWW_RESULT" ]; then
    echo "   ❌ No CNAME record found"
    echo "   👉 Add CNAME: www → ${GITHUB_USER}.github.io"
else
    echo "   ✅ CNAME: $WWW_RESULT"
fi
echo ""

# Check 5: Custom domain accessibility
echo "5. Custom Domain Status:"
DOMAIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://${DOMAIN}" 2>/dev/null)
if [ "$DOMAIN_STATUS" = "200" ]; then
    echo "   ✅ ${DOMAIN} is LIVE!"
    echo "   🎉 Your dashboard is online!"
elif [ "$DOMAIN_STATUS" = "000" ]; then
    echo "   ❌ ${DOMAIN} not accessible"
    echo "   ⏳ DNS may not be configured or still propagating"
else
    echo "   ⚠️  ${DOMAIN} returns HTTP $DOMAIN_STATUS"
fi
echo ""

echo "======================================"
echo "Summary & Next Steps"
echo "======================================"
echo ""

# Determine what needs to be done
PAGES_LIVE=$([ "$PAGES_STATUS" = "200" ] && echo "yes" || echo "no")
DNS_CONFIGURED=$([ -n "$DNS_RESULT" ] && echo "yes" || echo "no")
DOMAIN_LIVE=$([ "$DOMAIN_STATUS" = "200" ] && echo "yes" || echo "no")

if [ "$PAGES_LIVE" = "no" ]; then
    echo "🔴 PRIORITY 1: Enable GitHub Pages"
    echo "   1. Go to: https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
    echo "   2. Source: Deploy from a branch"
    echo "   3. Branch: main"
    echo "   4. Folder: / (root)"
    echo "   5. Click Save"
    echo "   6. Wait 2 minutes"
    echo ""
fi

if [ "$PAGES_LIVE" = "yes" ] && [ "$DNS_CONFIGURED" = "no" ]; then
    echo "🟡 NEXT: Configure DNS"
    echo "   1. Log in to your domain registrar"
    echo "   2. Add 4 A records pointing to GitHub IPs"
    echo "   3. Add 1 CNAME record for www"
    echo "   See: DNS_SETUP.md for detailed instructions"
    echo ""
fi

if [ "$PAGES_LIVE" = "yes" ] && [ "$DNS_CONFIGURED" = "yes" ] && [ "$DOMAIN_LIVE" = "no" ]; then
    echo "🟡 WAITING: DNS Propagation"
    echo "   DNS is configured but not fully propagated yet"
    echo "   This can take 24-48 hours"
    echo "   Check progress: https://dnschecker.org/#A/${DOMAIN}"
    echo ""
    echo "   In GitHub Pages settings, add custom domain:"
    echo "   https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
    echo "   Custom domain: ${DOMAIN}"
    echo ""
fi

if [ "$DOMAIN_LIVE" = "yes" ]; then
    echo "🟢 SUCCESS! Everything is working!"
    echo "   ✅ Your dashboard is live at: https://${DOMAIN}"
    echo "   ✅ Also accessible at: https://www.${DOMAIN}"
    echo "   ✅ GitHub Pages URL: ${GITHUB_URL}"
    echo ""
    echo "   Don't forget to enable HTTPS enforcement in GitHub Pages!"
    echo ""
fi

echo "======================================"
echo ""
echo "📚 Documentation:"
echo "   - ENABLE_PAGES_NOW.md - Enable GitHub Pages guide"
echo "   - DNS_SETUP.md - DNS configuration"
echo "   - DEPLOYMENT_GUIDE.md - Complete guide"
echo ""
echo "🔄 Run this script again anytime to check status:"
echo "   ./check_deployment_status.sh"
echo ""
echo "======================================"
