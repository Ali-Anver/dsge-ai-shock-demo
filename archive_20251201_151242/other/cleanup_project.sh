#!/bin/zsh

echo "🧹 DSGE Project Cleanup Script"
echo "================================"
echo ""

# Create backup directory
BACKUP_DIR="archive_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "✓ Created backup directory: $BACKUP_DIR"
echo ""

# Files to KEEP (essential for website and simulations)
KEEP_FILES=(
    "index.html"                          # Main website
    "dsge_dashboard.html"                 # DSGE dashboard backup
    "frbus_dashboard.html"                # FRB/US dashboard
    "CNAME"                               # Custom domain
    "parameter_sweep_simulation.jl"       # DSGE simulation script
    "run_frbus_simplified.py"             # FRB/US simulation script
    "README.md"                           # Main README
)

# Directories to KEEP
KEEP_DIRS=(
    "simulation_results"                  # DSGE data (essential!)
    "frbus_simulations"                   # FRB/US data (essential!)
    "DSGE.jl"                            # DSGE library (needed for simulations)
    "pyfrbus"                            # FRB/US library
)

# Documentation files to ARCHIVE (redundant/outdated)
DOC_FILES=(
    "CUSTOM_DOMAIN_SETUP.md"
    "DASHBOARD_FIX.md"
    "DASHBOARD_GUIDE.md"
    "DASHBOARD_IMPROVEMENTS.md"
    "DEPLOY_NOW.md"
    "DEPLOYMENT_GUIDE.md"
    "DEPLOYMENT_READY.md"
    "DEPLOYMENT_TO_CUSTOM_DOMAIN.md"
    "DNS_SETUP.md"
    "ENABLE_GITHUB_PAGES_NOW.md"
    "ENABLE_PAGES_NOW.md"
    "FIX_EMPTY_WEBSITE.md"
    "FRBUS_COMPLETE.md"
    "FRED_API_READY.md"
    "NAVIGATION_COMPLETE.md"
    "PAGES_LIVE_NOW.md"
    "PROJECT_COMPLETE.md"
    "PROJECT_SUCCESS.md"
    "QUICK_START_CUSTOM_DOMAIN.md"
    "README_DEPLOYMENT.md"
    "README_GITHUB.md"
    "README_LOCAL.md"
    "REDESIGN_SUMMARY.md"
    "ROLLBACK_COMPLETE.md"
    "RUNNING_EXAMPLES.md"
    "SETUP_GUIDE.md"
    "SIMULATION_COMPLETE.md"
    "TROUBLESHOOTING.md"
)

# Scripts to ARCHIVE (redundant/testing)
SCRIPT_FILES=(
    "check_deployment_status.sh"
    "check_julia.sh"
    "deploy_to_github.sh"
    "diagnose_pages.sh"
    "launch_dashboard.sh"
    "quick_commands.sh"
    "quick_reference.sh"
    "quick_start.sh"
    "run_examples.sh"
)

# Other files to ARCHIVE
OTHER_FILES=(
    "interactive_dashboard.html"          # Duplicate/old version
    "NY-FED.jl"                          # Test file
    "quick_demo_with_data.jl"            # Demo file
    "run_parameter_sweep.jl"             # Duplicate simulation script
    "simple_dsge_demo.jl"                # Demo file
    "sweep_output.log"                   # Log file
    "test_fred_api.jl"                   # Test file
    "Untitled-1.jl"                      # Untitled file
    "run_frbus_parameter_sweep.py"       # Duplicate FRB/US script
)

# Archive documentation files
echo "📁 Archiving documentation files..."
DOC_ARCHIVE="$BACKUP_DIR/documentation"
mkdir -p "$DOC_ARCHIVE"
archived_docs=0
for file in "${DOC_FILES[@]}"; do
    if [ -f "$file" ]; then
        mv "$file" "$DOC_ARCHIVE/"
        echo "  ✓ Archived: $file"
        ((archived_docs++))
    fi
done
echo "  Total: $archived_docs documentation files archived"
echo ""

# Archive script files
echo "📁 Archiving script files..."
SCRIPT_ARCHIVE="$BACKUP_DIR/scripts"
mkdir -p "$SCRIPT_ARCHIVE"
archived_scripts=0
for file in "${SCRIPT_FILES[@]}"; do
    if [ -f "$file" ]; then
        mv "$file" "$SCRIPT_ARCHIVE/"
        echo "  ✓ Archived: $file"
        ((archived_scripts++))
    fi
done
echo "  Total: $archived_scripts script files archived"
echo ""

# Archive other files
echo "📁 Archiving miscellaneous files..."
OTHER_ARCHIVE="$BACKUP_DIR/other"
mkdir -p "$OTHER_ARCHIVE"
archived_other=0
for file in "${OTHER_FILES[@]}"; do
    if [ -f "$file" ]; then
        mv "$file" "$OTHER_ARCHIVE/"
        echo "  ✓ Archived: $file"
        ((archived_other++))
    fi
done
echo "  Total: $archived_other miscellaneous files archived"
echo ""

# Summary
echo "================================"
echo "✅ Cleanup Complete!"
echo "================================"
echo ""
echo "📊 Summary:"
echo "  Documentation files: $archived_docs archived"
echo "  Script files:        $archived_scripts archived"
echo "  Other files:         $archived_other archived"
echo "  Total archived:      $((archived_docs + archived_scripts + archived_other)) files"
echo ""
echo "📁 All archived files are in: $BACKUP_DIR/"
echo ""
echo "✓ Essential files kept:"
echo "  - index.html (main website)"
echo "  - DSGE & FRB/US dashboards"
echo "  - simulation_results/ (2.9 MB)"
echo "  - frbus_simulations/ (1.4 MB)"
echo "  - Simulation scripts"
echo "  - CNAME (custom domain)"
echo "  - README.md"
echo ""
echo "🗑️  To permanently delete archived files later:"
echo "  rm -rf $BACKUP_DIR"
echo ""
echo "♻️  To restore a file:"
echo "  mv $BACKUP_DIR/<subfolder>/<filename> ."
echo ""
