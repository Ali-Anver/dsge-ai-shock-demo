# Dashboard Troubleshooting Guide

## Issue: "Error loading simulation data"

### Problem
When opening `interactive_dashboard.html` directly by double-clicking, you see an error message: **"Error loading simulation data. Please run the Julia simulation first."**

### Root Cause
Modern browsers block local file access (CORS policy) when HTML files are opened with the `file://` protocol. The dashboard cannot load the JSON data files even though they exist.

### ✅ Solution: Use Local Web Server

Instead of opening the HTML file directly, serve it through a local web server.

#### **Option 1: Quick Launch (Recommended)**
```bash
./launch_dashboard.sh
```

This script will:
- Check if simulation data exists
- Start a local web server on port 8000
- Open the dashboard in your browser
- Keep running until you press Ctrl+C

#### **Option 2: Manual Server Start**
```bash
# Start server
cd "/Users/alianver/Desktop/Other Research/DGSE-AI-Shock-Demo"
python3 -m http.server 8000

# Then open in browser:
# http://localhost:8000/interactive_dashboard.html
```

#### **Option 3: Using Different Port**
If port 8000 is busy:
```bash
python3 -m http.server 8080
# Then open: http://localhost:8080/interactive_dashboard.html
```

---

## Other Common Issues

### Issue: Sliders don't update charts

**Cause:** JavaScript error or data not loaded properly

**Solutions:**
1. Open browser console (F12 or Cmd+Option+I on Mac)
2. Look for error messages
3. Verify data loaded: Should see "Loaded 125 simulations" in console
4. Refresh the page (Cmd+R)

### Issue: Charts show no data

**Cause:** Parameter combination not found in simulation data

**Solution:**
The sliders map to specific parameter values. Make sure you've run the full simulation that covers all 125 combinations:
```bash
julia run_parameter_sweep.jl
```

### Issue: Server won't start - "Address already in use"

**Cause:** Another process is using port 8000

**Solutions:**
```bash
# Find and kill the process
lsof -ti:8000 | xargs kill -9

# Or use a different port
python3 -m http.server 8001
```

### Issue: Simulation data doesn't exist

**Error:** `simulation_results/simulation_data.json` not found

**Solution:** Run the parameter sweep:
```bash
julia run_parameter_sweep.jl
```

This takes ~30 seconds and generates:
- `simulation_results/simulation_data.json` (2.9 MB)
- `simulation_results/simulation_lookup.json` (22 KB)

---

## Verification Steps

### 1. Check if data files exist
```bash
ls -lh simulation_results/
```

Expected output:
```
simulation_data.json    (2.9M)
simulation_lookup.json  (22K)
```

### 2. Check if server is running
```bash
lsof -i:8000
```

Should show Python HTTP server process.

### 3. Test data access
```bash
curl http://localhost:8000/simulation_results/simulation_data.json | head -20
```

Should return JSON data (not an error).

### 4. Check browser console
Open the dashboard, press F12 (or Cmd+Option+I), go to Console tab:

**Good:**
```
Loaded 125 simulations
```

**Bad:**
```
Error loading data: Failed to fetch
```

---

## Advanced: Alternative Server Options

### Using PHP (if installed)
```bash
php -S localhost:8000
```

### Using Ruby (if installed)
```bash
ruby -run -ehttpd . -p8000
```

### Using Node.js http-server
```bash
# Install once
npm install -g http-server

# Run
http-server -p 8000
```

---

## Quick Reference

### Start Everything
```bash
./launch_dashboard.sh
```

### Stop Server
Press `Ctrl+C` in the terminal where server is running

Or:
```bash
lsof -ti:8000 | xargs kill -9
```

### Re-run Simulation
```bash
julia run_parameter_sweep.jl
```

### Check Status
```bash
# Data files exist?
ls simulation_results/

# Server running?
lsof -i:8000

# Open dashboard
open http://localhost:8000/interactive_dashboard.html
```

---

## Still Having Issues?

1. **Verify Julia simulation completed successfully**
   - Check for `simulation_results/` directory
   - Files should be ~2.9MB and ~22KB

2. **Try different browser**
   - Chrome, Firefox, Safari all work
   - Disable ad-blockers or privacy extensions

3. **Check file permissions**
   ```bash
   chmod 644 simulation_results/*.json
   ```

4. **Clear browser cache**
   - Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows/Linux)

5. **Restart everything**
   ```bash
   # Kill server
   lsof -ti:8000 | xargs kill -9
   
   # Restart
   ./launch_dashboard.sh
   ```

---

## Success Checklist

- [ ] Simulation data exists (2.9 MB JSON file)
- [ ] Local server is running on port 8000
- [ ] Dashboard opens at http://localhost:8000/interactive_dashboard.html
- [ ] Browser console shows "Loaded 125 simulations"
- [ ] Sliders move smoothly
- [ ] Charts update when sliders change
- [ ] Can see AI shock marker (red dashed line at period 25)

---

## Contact

If you're still experiencing issues, check:
- Browser console (F12) for detailed error messages
- Terminal output for server errors
- File permissions and paths

The dashboard requires:
- Python 3 (for local server)
- Modern browser (Chrome, Firefox, Safari, Edge)
- Simulation data from `run_parameter_sweep.jl`
