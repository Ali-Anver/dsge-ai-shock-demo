# Complete Guide: Parameter Sweep & Interactive Dashboard

## 🎯 Project Overview

This project allows you to:
1. **Run parameter sweeps** on a calibrated DSGE model
2. **Generate simulation data** for different economic scenarios  
3. **Create an interactive website** where users can explore results with sliders

## 📊 What Gets Simulated

### Parameters You Can Vary:

1. **Technology Shock Persistence (ρ_z)**
   - Range: 0.90 to 0.98
   - **Meaning**: How long productivity gains last
   - **AI Context**: Higher values = more permanent AI improvements

2. **Technology Shock Volatility (σ_z)**
   - Range: 0.005 to 0.020
   - **Meaning**: Size of productivity shocks
   - **AI Context**: Larger values = bigger AI productivity boosts

3. **Capital Share (α)**
   - Range: 0.30 to 0.45
   - **Meaning**: Capital's share of output vs labor
   - **AI Context**: Higher values = more capital-intensive economy

### What Gets Calculated:

For each combination of parameters, the model simulates 100 periods and tracks:
- **Output (GDP)**
- **Consumption**
- **Investment**
- **Labor hours**
- **Wages**
- **Capital returns**
- **Technology level**

**Special Feature**: A large AI productivity shock hits at period 25!

## 🚀 Step-by-Step Instructions

### Step 1: Run the Simulation (5-10 minutes)

```bash
cd ~/Desktop/Other\ Research/DGSE-AI-Shock-Demo
julia run_parameter_sweep.jl
```

**What this does:**
- Runs 125 simulations (5 × 5 × 5 parameter combinations)
- Creates `simulation_results/` directory
- Saves all data as JSON files
- Prints summary statistics

**Output files created:**
- `simulation_data.json` - Full simulation results
- `simulation_lookup.json` - Quick lookup table

### Step 2: Open the Interactive Dashboard

```bash
# Option 1: Double-click the file
open interactive_dashboard.html

# Option 2: Start a local server (better for loading data)
python3 -m http.server 8000
# Then open: http://localhost:8000/interactive_dashboard.html
```

**What you'll see:**
- 🎛️ Three sliders to adjust parameters
- 📊 Four interactive charts showing economic variables
- 📈 Real-time statistics updating as you move sliders

### Step 3: Explore Different Scenarios

Try these scenarios:

#### Baseline Economy
- ρ_z = 0.95 (middle slider position)
- σ_z = 0.007 (middle position)
- α = 0.36 (middle position)

#### Moderate AI Shock
- ρ_z = 0.97 (more persistent)
- σ_z = 0.015 (larger shocks)
- α = 0.36 (baseline)

#### Transformative AI
- ρ_z = 0.98 (very persistent)
- σ_z = 0.020 (very large shocks)
- α = 0.40 (more capital-intensive)

#### Labor-Intensive Economy
- ρ_z = 0.95 (baseline)
- σ_z = 0.010 (moderate)
- α = 0.30 (low capital share)

## 📈 Understanding the Charts

### Chart 1: Output (GDP) Over Time
- Shows total economic output
- Red dashed line = AI shock at period 25
- Watch how GDP responds to the shock and recovers

### Chart 2: Consumption & Investment
- Green line = Household consumption
- Orange line = Business investment
- See how resources are allocated

### Chart 3: Wages & Capital Returns
- Blue line = Worker wages
- Purple line = Return to capital
- Shows income distribution between labor and capital

### Chart 4: Technology Level
- Shows total factor productivity (TFP)
- Direct result of technology shocks
- Higher = more productive economy

## 💡 Key Insights to Look For

### Effect of Technology Persistence (ρ_z):
- **Higher ρ_z** → Productivity gains last longer
- **Lower ρ_z** → Productivity shocks fade quickly
- **AI Implication**: If AI creates persistent gains, use high ρ_z

### Effect of Technology Volatility (σ_z):
- **Higher σ_z** → Larger productivity fluctuations
- **Lower σ_z** → More stable productivity
- **AI Implication**: Transformative AI = large σ_z

### Effect of Capital Share (α):
- **Higher α** → Capital gets larger share of output
- **Lower α** → Labor gets larger share
- **AI Implication**: If AI increases capital intensity, α rises

### Combined Effects:
- High ρ_z + High σ_z = **Permanent transformative AI**
- High α + High productivity = **Capital benefits more**
- Low α + High productivity = **Labor benefits more**

## 🔧 Customization Options

### Modify Parameter Ranges

Edit `run_parameter_sweep.jl`:

```julia
# Change these lines (around line 56-63)
ρ_z_values = [0.85, 0.90, 0.95, 0.97, 0.99]  # Your custom range
σ_z_values = [0.003, 0.007, 0.012, 0.020, 0.030]  # Your custom range
α_values = [0.25, 0.30, 0.36, 0.42, 0.50]  # Your custom range
```

Then re-run the simulation and the website will automatically use new data!

### Add More Variables

To track additional economic variables, edit the `simulate_economy` function:

```julia
# Add to return Dict (around line 125)
return Dict(
    # ... existing variables ...
    "your_new_variable" => your_calculation,
)
```

### Change Simulation Length

```julia
# In run_parameter_sweep.jl, around line 93
results = simulate_economy(params, 200)  # Change from 100 to 200 periods
```

### Modify AI Shock Timing/Size

```julia
# In run_parameter_sweep.jl, around line 57
if n_periods >= 25
    shocks[25] = 5.0  # Make shock even larger (was 3.0)
end

# Or change timing
if n_periods >= 40
    shocks[40] = 3.0  # Shock at period 40 instead
end
```

## 📁 File Structure

```
DGSE-AI-Shock-Demo/
├── run_parameter_sweep.jl         # Run this to generate data
├── interactive_dashboard.html     # Open this to view results
└── simulation_results/             # Created after running simulation
    ├── simulation_data.json        # Full dataset
    └── simulation_lookup.json      # Quick lookup table
```

## 🐛 Troubleshooting

### Problem: "simulation_results not found"
**Solution**: Run `julia run_parameter_sweep.jl` first to generate data

### Problem: Charts not loading
**Solution**: Use a local web server instead of opening file directly:
```bash
python3 -m http.server 8000
```

### Problem: Simulation takes too long
**Solution**: Reduce number of parameter values:
```julia
# Use fewer values (3×3×3 = 27 simulations instead of 5×5×5 = 125)
ρ_z_values = [0.90, 0.95, 0.98]
σ_z_values = [0.007, 0.012, 0.020]
α_values = [0.30, 0.36, 0.45]
```

### Problem: Want even finer control
**Solution**: Add more parameter values:
```julia
# 10×10×10 = 1000 simulations (takes ~30 minutes)
ρ_z_values = range(0.90, 0.98, length=10)
σ_z_values = range(0.005, 0.020, length=10)
α_values = range(0.30, 0.45, length=10)
```

## 📊 Exporting Results

### Get Summary Statistics

After running simulation, check `simulation_results/simulation_lookup.json`:
```json
{
  "simulations": [
    {
      "α": 0.36,
      "ρ_z": 0.95,
      "σ_z": 0.007,
      "avg_output": 10.2345,
      "final_output": 10.5678
    },
    ...
  ]
}
```

### Extract Specific Scenarios

Use Julia to query results:
```julia
using JSON

data = JSON.parsefile("simulation_results/simulation_data.json")

# Find specific scenario
for sim in data["simulations"]
    if sim["α"] == 0.36 && sim["ρ_z"] == 0.98 && sim["σ_z"] == 0.020
        println("Found transformative AI scenario!")
        println("Average output: ", sim["summary"]["avg_output"])
        # Access full time series: sim["data"]["output"]
    end
end
```

### Create Custom Visualizations

The JSON data can be loaded in Python, R, or any other tool:

**Python example:**
```python
import json
import matplotlib.pyplot as plt

with open('simulation_results/simulation_data.json') as f:
    data = json.load(f)

# Plot a specific simulation
sim = data['simulations'][0]
plt.plot(sim['data']['periods'], sim['data']['output'])
plt.title(f"α={sim['α']}, ρ_z={sim['ρ_z']}, σ_z={sim['σ_z']}")
plt.show()
```

## 🎓 For Your Research

### Recommended Analysis Workflow:

1. **Run baseline** (middle values for all parameters)
2. **Vary one parameter at a time** to see individual effects
3. **Try extreme combinations** (high/high, low/low, high/low, etc.)
4. **Compare scenarios**:
   - No AI (baseline tech params)
   - Moderate AI (slightly higher params)
   - Transformative AI (much higher params)

### Questions to Answer:

1. **How much do AI shocks affect GDP?**
   - Compare average output across σ_z values

2. **How persistent are AI effects?**
   - Compare final vs average output for different ρ_z

3. **Who benefits from AI?**
   - Compare wages vs capital returns for different α values

4. **What's the best-case scenario?**
   - Which parameter combination maximizes output/wages?

5. **What's the distribution of gains?**
   - How does α affect wage vs capital return growth?

## 🌐 Sharing Your Dashboard

### Option 1: GitHub Pages (Free!)

```bash
# Create a GitHub repository
git init
git add interactive_dashboard.html simulation_results/
git commit -m "Add DSGE dashboard"
git branch -M main
git remote add origin https://github.com/yourusername/dsge-dashboard.git
git push -u origin main

# Enable GitHub Pages in repository settings
# Your dashboard will be at: https://yourusername.github.io/dsge-dashboard/interactive_dashboard.html
```

### Option 2: Local Network

```bash
# Share on your local network
python3 -m http.server 8000
# Others can access at: http://YOUR_IP:8000/interactive_dashboard.html
```

### Option 3: Export as Standalone

The HTML file is self-contained! Just:
1. Copy `interactive_dashboard.html`
2. Copy `simulation_results/` folder
3. Keep them together
4. Anyone can open the HTML file locally

## ✅ Success Checklist

- [ ] Ran `julia run_parameter_sweep.jl`
- [ ] Saw "✅ Simulation complete!" message
- [ ] Found `simulation_results/` folder with JSON files
- [ ] Opened `interactive_dashboard.html` in browser
- [ ] Tested all three sliders
- [ ] Saw charts update in real-time
- [ ] Explored different scenarios
- [ ] Understood the economic insights

## 🎉 You're Done!

You now have:
- ✅ A working parameter sweep simulation
- ✅ An interactive web dashboard
- ✅ Tools to explore AI economic impacts
- ✅ Data you can analyze further

**Next**: Present your findings, write up your research, or extend the model!

---

**Questions?** Check the other documentation files or experiment with the code!
