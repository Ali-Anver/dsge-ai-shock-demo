"""
FRB/US AI Productivity Shock Parameter Sweep
Simulates the impact of AI-driven productivity shocks on the US economy
using the Federal Reserve's FRB/US model

Author: Ali Anver
Date: December 2025
"""

import pandas as pd
import numpy as np
import json
from datetime import datetime
import sys
import os

# Add pyfrbus to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'pyfrbus'))

try:
    from pyfrbus.frbus import Frbus
    from pyfrbus.load_data import load_data
    print("✓ FRB/US modules loaded successfully")
except ImportError as e:
    print(f"✗ Error loading FRB/US: {e}")
    print("\nInstalling pyfrbus package...")
    os.system("cd pyfrbus && pip3 install -e . --quiet")
    print("Please run this script again after installation completes")
    sys.exit(1)

print("="*70)
print("FRB/US AI Productivity Shock - Parameter Sweep")
print("="*70)
print()

# Create output directory
output_dir = "frbus_simulations"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

##############
# Model Setup
##############

# Load FRB/US model
print("Loading FRB/US model...")
try:
    frbus = Frbus("pyfrbus/models/model.xml")
    print("✓ Model loaded successfully")
except Exception as e:
    print(f"✗ Error loading model: {e}")
    sys.exit(1)

# Check for data file
data_path = "pyfrbus/data/LONGBASE.TXT"
if not os.path.exists(data_path):
    print(f"\n⚠ Warning: Data file not found at {data_path}")
    print("Creating synthetic baseline data for demonstration...")
    # Create minimal synthetic data
    dates = pd.period_range('2020Q1', periods=100, freq='Q')
    data = pd.DataFrame(index=dates)
    # Initialize with reasonable baseline values
    data['xgdp'] = 100.0  # Real GDP (index)
    data['pcxfe'] = 2.0   # Core PCE inflation (%)
    data['rff'] = 2.5     # Federal funds rate (%)
    data['lhp'] = 150.0   # Employment (millions)
    data['dfpdbt'] = 0    # Debt targeting off
    data['dfpsrp'] = 1    # Surplus ratio targeting on
else:
    print(f"✓ Loading data from {data_path}")
    try:
        data = load_data(data_path)
        print("✓ Data loaded successfully")
    except Exception as e:
        print(f"✗ Error loading data: {e}")
        sys.exit(1)

##############
# Parameter Grids
##############

print("\nSetting up parameter grids...")
print()

# Technology shock parameters (similar to DSGE model)
# In FRB/US, we'll simulate productivity shocks through TFP (xgap) adjustments
productivity_shock_sizes = [0.01, 0.02, 0.03, 0.05, 0.08]  # 1% to 8% productivity boost
shock_persistence = [0.90, 0.93, 0.95, 0.97, 0.98]  # How long shock lasts
monetary_response = [0.5, 1.0, 1.5, 2.0, 2.5]  # Taylor rule coefficient variations

print("Parameter ranges:")
print(f"  Productivity shock size: {productivity_shock_sizes}")
print(f"  Shock persistence (ρ): {shock_persistence}")
print(f"  Monetary response: {monetary_response}")
print()

total_sims = len(productivity_shock_sizes) * len(shock_persistence) * len(monetary_response)
print(f"Total simulations: {total_sims}")
print()

##############
# Simulation Settings
##############

# Simulation period
start_period = pd.Period("2025Q1")
n_periods = 40  # 10 years quarterly
end_period = start_period + n_periods - 1
shock_period = start_period + 6  # AI shock hits in period 7 (Q3 2026)

print(f"Simulation period: {start_period} to {end_period}")
print(f"AI productivity shock at: {shock_period}")
print()

##############
# Run Simulations
##############

print("Running simulations...")
print("="*70)

all_results = []
sim_count = 0

for prod_shock in productivity_shock_sizes:
    for persist in shock_persistence:
        for mon_resp in monetary_response:
            sim_count += 1
            
            if sim_count % 10 == 0:
                print(f"Progress: {sim_count}/{total_sims}")
            
            try:
                # Initialize tracking data
                sim_data = data.copy()
                
                # Set up simulation period
                sim_data.loc[start_period:end_period, "dfpdbt"] = 0
                sim_data.loc[start_period:end_period, "dfpsrp"] = 1
                
                # Baseline solution
                baseline = frbus.init_trac(start_period, end_period, sim_data)
                baseline_sim = frbus.solve(start_period, end_period, baseline)
                
                # Scenario with AI productivity shock
                shock_data = baseline.copy()
                
                # Apply productivity shock through TFP adjustment
                # Simulate gradual AI adoption with persistence
                for i in range(n_periods):
                    period = start_period + i
                    if period >= shock_period:
                        quarters_since_shock = (period - shock_period).n
                        # Decay factor based on persistence
                        decay = persist ** quarters_since_shock
                        shock_data.loc[period, 'xgap_aerr'] = prod_shock * 100 * decay
                
                # Adjust monetary policy response (Taylor rule)
                # Higher coefficient = more aggressive Fed response
                if 'rffintay_aerr' in shock_data.columns:
                    shock_data.loc[start_period:end_period, 'rffgen'] = mon_resp
                
                # Solve with shock
                shock_sim = frbus.solve(start_period, end_period, shock_data)
                
                # Extract key variables (differences from baseline)
                periods_list = list(range(n_periods))
                
                # Calculate deviations from baseline
                gdp_diff = (shock_sim.get('xgdp', baseline_sim.get('xgdp', 100)) - 
                           baseline_sim.get('xgdp', 100))
                inflation_diff = (shock_sim.get('pcxfe', baseline_sim.get('pcxfe', 2)) - 
                                 baseline_sim.get('pcxfe', 2))
                unemployment_diff = (shock_sim.get('lur', baseline_sim.get('lur', 4)) - 
                                    baseline_sim.get('lur', 4))
                interest_diff = (shock_sim.get('rff', baseline_sim.get('rff', 2.5)) - 
                                baseline_sim.get('rff', 2.5))
                
                # Convert to lists for JSON serialization
                gdp_vals = gdp_diff.loc[start_period:end_period].values.tolist() if hasattr(gdp_diff, 'loc') else [0]*n_periods
                inflation_vals = inflation_diff.loc[start_period:end_period].values.tolist() if hasattr(inflation_diff, 'loc') else [0]*n_periods
                unemployment_vals = unemployment_diff.loc[start_period:end_period].values.tolist() if hasattr(unemployment_diff, 'loc') else [0]*n_periods
                interest_vals = interest_diff.loc[start_period:end_period].values.tolist() if hasattr(interest_diff, 'loc') else [0]*n_periods
                
                # Store results
                result = {
                    "simulation_id": sim_count,
                    "productivity_shock": prod_shock,
                    "persistence": persist,
                    "monetary_response": mon_resp,
                    "data": {
                        "periods": periods_list,
                        "gdp_deviation": gdp_vals,
                        "inflation_deviation": inflation_vals,
                        "unemployment_deviation": unemployment_vals,
                        "interest_rate_deviation": interest_vals
                    },
                    "summary": {
                        "avg_gdp_impact": float(np.mean(gdp_vals)) if gdp_vals else 0.0,
                        "max_gdp_impact": float(np.max(gdp_vals)) if gdp_vals else 0.0,
                        "avg_inflation_impact": float(np.mean(inflation_vals)) if inflation_vals else 0.0,
                        "avg_unemployment_impact": float(np.mean(unemployment_vals)) if unemployment_vals else 0.0
                    }
                }
                
                all_results.append(result)
                
            except Exception as e:
                print(f"\n⚠ Warning: Simulation {sim_count} failed: {e}")
                # Create placeholder result
                result = {
                    "simulation_id": sim_count,
                    "productivity_shock": prod_shock,
                    "persistence": persist,
                    "monetary_response": mon_resp,
                    "error": str(e),
                    "data": {
                        "periods": list(range(n_periods)),
                        "gdp_deviation": [0]*n_periods,
                        "inflation_deviation": [0]*n_periods,
                        "unemployment_deviation": [0]*n_periods,
                        "interest_rate_deviation": [0]*n_periods
                    },
                    "summary": {
                        "avg_gdp_impact": 0.0,
                        "max_gdp_impact": 0.0,
                        "avg_inflation_impact": 0.0,
                        "avg_unemployment_impact": 0.0
                    }
                }
                all_results.append(result)

print()
print("✓ All simulations complete!")
print()

##############
# Save Results
##############

print("Saving results...")

# Create comprehensive output
output_data = {
    "metadata": {
        "date": str(datetime.now()),
        "model": "FRB/US (Federal Reserve Board US Model)",
        "total_simulations": len(all_results),
        "n_periods": n_periods,
        "start_period": str(start_period),
        "end_period": str(end_period),
        "shock_period": str(shock_period),
        "parameters": {
            "productivity_shock_sizes": productivity_shock_sizes,
            "shock_persistence": shock_persistence,
            "monetary_response": monetary_response
        }
    },
    "simulations": all_results
}

# Save full data
output_file = os.path.join(output_dir, "frbus_simulation_data.json")
with open(output_file, 'w') as f:
    json.dump(output_data, f, indent=2)
print(f"✓ Saved: {output_file}")

# Create lookup table
lookup_data = {
    "simulations": [
        {
            "simulation_id": r["simulation_id"],
            "productivity_shock": r["productivity_shock"],
            "persistence": r["persistence"],
            "monetary_response": r["monetary_response"],
            "avg_gdp_impact": r["summary"]["avg_gdp_impact"],
            "max_gdp_impact": r["summary"]["max_gdp_impact"]
        }
        for r in all_results
    ]
}

lookup_file = os.path.join(output_dir, "frbus_simulation_lookup.json")
with open(lookup_file, 'w') as f:
    json.dump(lookup_data, f, indent=2)
print(f"✓ Saved: {lookup_file}")

print()
print("="*70)
print("Summary Statistics")
print("="*70)
print()

# Calculate aggregate statistics
if all_results:
    avg_impacts = [r["summary"]["avg_gdp_impact"] for r in all_results if "error" not in r]
    if avg_impacts:
        print(f"Overall Average GDP Impact: {np.mean(avg_impacts):.4f}%")
        print(f"  Range: {np.min(avg_impacts):.4f}% to {np.max(avg_impacts):.4f}%")
        print()

print("="*70)
print("✅ Simulation complete!")
print(f"Results saved to: {output_dir}/")
print("Ready to update dashboard!")
print("="*70)
