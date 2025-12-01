# 🧹 Project Cleanup Plan

## What Will Be Kept (Essential Files)

### ✅ Website Files
- `index.html` - Your main DSGE dashboard (live on mightbeuseless.com)
- `dsge_dashboard.html` - Backup copy of DSGE dashboard
- `frbus_dashboard.html` - FRB/US dashboard (accessible but not linked)
- `CNAME` - Custom domain configuration

### ✅ Simulation Scripts
- `parameter_sweep_simulation.jl` - DSGE model simulation script
- `run_frbus_simplified.py` - FRB/US model simulation script

### ✅ Data Directories (4.3 MB total)
- `simulation_results/` - DSGE simulation data (2.9 MB)
  - simulation_data.json
  - simulation_lookup.json
- `frbus_simulations/` - FRB/US simulation data (1.4 MB)
  - frbus_simulation_data.json
  - frbus_simulation_lookup.json

### ✅ Libraries
- `DSGE.jl/` - DSGE modeling library (needed if you rerun simulations)
- `pyfrbus/` - FRB/US Python library (needed if you rerun simulations)

### ✅ Documentation
- `README.md` - Main project README

---

## What Will Be Archived (Moved to Backup)

### 📁 Documentation Files (29 total → Archive 27)
These are redundant guides from the development process:
- `CUSTOM_DOMAIN_SETUP.md`
- `DASHBOARD_FIX.md`
- `DASHBOARD_GUIDE.md`
- `DASHBOARD_IMPROVEMENTS.md`
- `DEPLOY_NOW.md`
- `DEPLOYMENT_GUIDE.md`
- `DEPLOYMENT_READY.md`
- `DEPLOYMENT_TO_CUSTOM_DOMAIN.md`
- `DNS_SETUP.md`
- `ENABLE_GITHUB_PAGES_NOW.md`
- `ENABLE_PAGES_NOW.md`
- `FIX_EMPTY_WEBSITE.md`
- `FRBUS_COMPLETE.md`
- `FRED_API_READY.md`
- `NAVIGATION_COMPLETE.md`
- `PAGES_LIVE_NOW.md`
- `PROJECT_COMPLETE.md`
- `PROJECT_SUCCESS.md`
- `QUICK_START_CUSTOM_DOMAIN.md`
- `README_DEPLOYMENT.md`
- `README_GITHUB.md`
- `README_LOCAL.md`
- `REDESIGN_SUMMARY.md`
- `ROLLBACK_COMPLETE.md`
- `RUNNING_EXAMPLES.md`
- `SETUP_GUIDE.md`
- `SIMULATION_COMPLETE.md`
- `TROUBLESHOOTING.md`

### 📁 Script Files (9 total)
Development and testing scripts no longer needed:
- `check_deployment_status.sh`
- `check_julia.sh`
- `deploy_to_github.sh`
- `diagnose_pages.sh`
- `launch_dashboard.sh`
- `quick_commands.sh`
- `quick_reference.sh`
- `quick_start.sh`
- `run_examples.sh`

### 📁 Other Files (9 total)
Duplicate, test, and development files:
- `interactive_dashboard.html` - Old/duplicate version
- `NY-FED.jl` - Test file
- `quick_demo_with_data.jl` - Demo file
- `run_parameter_sweep.jl` - Duplicate simulation script
- `simple_dsge_demo.jl` - Demo file
- `sweep_output.log` - Log file
- `test_fred_api.jl` - Test file
- `Untitled-1.jl` - Untitled file
- `run_frbus_parameter_sweep.py` - Duplicate FRB/US script

---

## How Cleanup Works

### Safe Archive Process
1. Creates timestamped backup folder: `archive_YYYYMMDD_HHMMSS/`
2. Organizes files into subfolders:
   - `archive_*/documentation/` - All .md files
   - `archive_*/scripts/` - All .sh files
   - `archive_*/other/` - Miscellaneous files
3. **Files are MOVED, not deleted** - you can restore them anytime

### After Cleanup, You'll Have:
```
/DGSE-AI-Shock-Demo/
├── index.html                      # Main website
├── dsge_dashboard.html             # DSGE dashboard
├── frbus_dashboard.html            # FRB/US dashboard
├── CNAME                           # Domain config
├── parameter_sweep_simulation.jl   # DSGE script
├── run_frbus_simplified.py         # FRB/US script
├── README.md                       # Main docs
├── simulation_results/             # DSGE data
├── frbus_simulations/              # FRB/US data
├── DSGE.jl/                       # DSGE library
├── pyfrbus/                       # FRB/US library
└── archive_YYYYMMDD_HHMMSS/       # Archived files
    ├── documentation/
    ├── scripts/
    └── other/
```

---

## Benefits

### Before: ~60+ files cluttering the directory
### After: 8 essential files + 3 data/library folders + 1 archive folder

✅ **Cleaner workspace** - Only essential files visible
✅ **Nothing lost** - All files safely archived
✅ **Easy to restore** - Simple `mv` command to bring back any file
✅ **Website unaffected** - All live files kept intact
✅ **Simulations preserved** - All data and scripts remain

---

## To Run Cleanup

```bash
cd /Users/alianver/Desktop/Other\ Research/DGSE-AI-Shock-Demo
./cleanup_project.sh
```

## To Restore a File

```bash
# Example: restore a specific documentation file
mv archive_*/documentation/DASHBOARD_IMPROVEMENTS.md .

# Example: restore all archived docs
mv archive_*/documentation/* .
```

## To Permanently Delete Archives (Optional)

```bash
# Only do this if you're sure you don't need the archived files
rm -rf archive_*
```

---

**Recommendation**: Run the cleanup! It will make your project much cleaner while keeping everything you need. The archived files can be deleted later once you're confident you don't need them.
