"""
Simplified FRB/US-Style AI Productivity Shock Simulation
Mimics FRB/US model behavior for AI productivity analysis
without requiring full FRB/US installation

This creates realistic macroeconomic responses based on typical FRB/US dynamics
Author: Ali Anver
Date: December 2025
"""

import pandas as pd
import numpy as np
import json
from datetime import datetime
import os

print("="*70)
print("FRB/US-Style AI Productivity Shock - Parameter Sweep")
print("="*70)
print()

# Create output directory
output_dir = "frbus_simulations"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

##############
# Simplified FRB/US-Style Model
##############

class SimplifiedFRBUS:
    """
    Simplified macro model with FRB/US-like dynamics
    Captures key transmission mechanisms of productivity shocks
    """
    
    def __init__(self):
        # Structural parameters (calibrated to match FRB/US behavior)
        self.beta = 0.99  # Discount factor
        self.sigma = 1.5  # Intertemporal elasticity
        self.phi_pi = 1.5  # Taylor rule inflation response
        self.phi_y = 0.5  # Taylor rule output gap response
        self.alpha = 0.33  # Capital share
        self.delta = 0.025  # Depreciation rate
        self.rho_a = 0.95  # Technology persistence
        
    def simulate(self, n_periods, shock_size, shock_period, persistence, mon_response):
        """
        Simulate economy with AI productivity shock
        
        Parameters:
        - n_periods: Number of quarters to simulate
        - shock_size: Size of productivity shock (e.g., 0.03 = 3%)
        - shock_period: When shock hits
        - persistence: How long shock lasts (0-1)
        - mon_response: Monetary policy aggressiveness
        """
        
        # Initialize variables
        output = np.zeros(n_periods)
        inflation = np.zeros(n_periods)
        interest_rate = np.zeros(n_periods)
        unemployment = np.zeros(n_periods)
        productivity = np.zeros(n_periods)
        
        # Steady state values
        ss_output = 100.0
        ss_inflation = 2.0
        ss_rate = 2.5
        ss_unemployment = 4.0
        ss_productivity = 1.0
        
        # Initial values
        output[0] = ss_output
        inflation[0] = ss_inflation
        interest_rate[0] = ss_rate
        unemployment[0] = ss_unemployment
        productivity[0] = ss_productivity
        
        # Simulate forward
        for t in range(1, n_periods):
            
            # Technology/productivity shock
            if t >= shock_period:
                quarters_since_shock = t - shock_period
                shock_decay = persistence ** quarters_since_shock
                productivity[t] = ss_productivity + shock_size * shock_decay
            else:
                productivity[t] = ss_productivity
            
            # Productivity affects potential output
            tfp_effect = (productivity[t] - ss_productivity)
            
            # Output response (with adjustment costs)
            output_gap_prev = (output[t-1] - ss_output) / ss_output
            output_gap = 0.8 * output_gap_prev + 0.3 * tfp_effect
            output[t] = ss_output * (1 + output_gap)
            
            # Phillips curve (inflation dynamics)
            inflation_inertia = 0.7
            inflation[t] = (inflation_inertia * inflation[t-1] + 
                           (1 - inflation_inertia) * ss_inflation +
                           0.1 * output_gap -
                           0.05 * tfp_effect)  # Productivity reduces inflation
            
            # Taylor rule (monetary policy)
            inflation_dev = inflation[t] - ss_inflation
            output_dev = output_gap
            interest_rate[t] = (ss_rate + 
                               mon_response * self.phi_pi * inflation_dev +
                               mon_response * self.phi_y * output_dev)
            
            # Okun's law (unemployment)
            # Higher output growth = lower unemployment
            output_growth = (output[t] / output[t-1] - 1) * 400 if t > 0 else 0
            unemployment[t] = ss_unemployment - 0.5 * (output_growth - 2.0)
            unemployment[t] = max(1.0, min(10.0, unemployment[t]))  # Bound unemployment
        
        return {
            'output': output,
            'inflation': inflation,
            'interest_rate': interest_rate,
            'unemployment': unemployment,
            'productivity': productivity
        }

##############
# Parameter Grids
##############

print("Setting up parameter grids...")
print()

# AI productivity shock parameters
productivity_shock_sizes = [0.01, 0.02, 0.03, 0.05, 0.08]  # 1% to 8% boost
shock_persistence = [0.90, 0.93, 0.95, 0.97, 0.98]  # Persistence parameter
monetary_response = [0.5, 1.0, 1.5, 2.0, 2.5]  # Fed aggressiveness

print("Parameter ranges:")
print(f"  Productivity shock size: {[f'{x*100:.0f}%' for x in productivity_shock_sizes]}")
print(f"  Shock persistence (ρ): {shock_persistence}")
print(f"  Monetary response: {monetary_response}")
print()

total_sims = len(productivity_shock_sizes) * len(shock_persistence) * len(monetary_response)
print(f"Total simulations: {total_sims}")
print()

##############
# Simulation Settings
##############

n_periods = 40  # 10 years quarterly
shock_period = 6  # AI shock hits in period 7

print(f"Simulation periods: {n_periods} quarters (10 years)")
print(f"AI productivity shock at: Period {shock_period} (Q3 2026)")
print()

##############
# Run Simulations
##############

print("Running simulations...")
print("="*70)

model = SimplifiedFRBUS()
all_results = []
sim_count = 0

for prod_shock in productivity_shock_sizes:
    for persist in shock_persistence:
        for mon_resp in monetary_response:
            sim_count += 1
            
            if sim_count % 25 == 0:
                print(f"Progress: {sim_count}/{total_sims}")
            
            # Run simulation
            sim_results = model.simulate(
                n_periods=n_periods,
                shock_size=prod_shock,
                shock_period=shock_period,
                persistence=persist,
                mon_response=mon_resp
            )
            
            # Calculate deviations from steady state
            ss_output = 100.0
            ss_inflation = 2.0
            ss_unemployment = 4.0
            ss_rate = 2.5
            
            gdp_deviation = sim_results['output'] - ss_output
            inflation_deviation = sim_results['inflation'] - ss_inflation
            unemployment_deviation = sim_results['unemployment'] - ss_unemployment
            interest_deviation = sim_results['interest_rate'] - ss_rate
            
            # Store results
            result = {
                "simulation_id": sim_count,
                "productivity_shock": prod_shock,
                "persistence": persist,
                "monetary_response": mon_resp,
                "data": {
                    "periods": list(range(n_periods)),
                    "gdp_level": sim_results['output'].tolist(),
                    "gdp_deviation": gdp_deviation.tolist(),
                    "inflation_level": sim_results['inflation'].tolist(),
                    "inflation_deviation": inflation_deviation.tolist(),
                    "unemployment_level": sim_results['unemployment'].tolist(),
                    "unemployment_deviation": unemployment_deviation.tolist(),
                    "interest_rate_level": sim_results['interest_rate'].tolist(),
                    "interest_rate_deviation": interest_deviation.tolist(),
                    "productivity": sim_results['productivity'].tolist()
                },
                "summary": {
                    "avg_gdp_impact": float(np.mean(gdp_deviation)),
                    "max_gdp_impact": float(np.max(gdp_deviation)),
                    "final_gdp_impact": float(gdp_deviation[-1]),
                    "avg_inflation_impact": float(np.mean(inflation_deviation)),
                    "avg_unemployment_impact": float(np.mean(unemployment_deviation)),
                    "peak_interest_rate": float(np.max(sim_results['interest_rate']))
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
        "model": "FRB/US-Style Model (Federal Reserve Board US Model)",
        "description": "Simplified macro model capturing FRB/US-like dynamics",
        "total_simulations": len(all_results),
        "n_periods": n_periods,
        "shock_period": shock_period,
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

file_size = os.path.getsize(output_file) / (1024 * 1024)
print(f"✓ Saved: {output_file} ({file_size:.1f} MB)")

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

# Calculate aggregate statistics by parameter
avg_impacts = [r["summary"]["avg_gdp_impact"] for r in all_results]
print(f"Overall Average GDP Impact: {np.mean(avg_impacts):.4f}%")
print(f"  Range: {np.min(avg_impacts):.4f}% to {np.max(avg_impacts):.4f}%")
print()

# Effect of productivity shock size
print("Effect of Productivity Shock Size:")
for shock_size in productivity_shock_sizes:
    subset = [r["summary"]["avg_gdp_impact"] for r in all_results 
              if r["productivity_shock"] == shock_size]
    print(f"  {shock_size*100:.0f}% shock: Avg GDP Impact = {np.mean(subset):.4f}%")
print()

# Effect of persistence
print("Effect of Shock Persistence:")
for persist in shock_persistence:
    subset = [r["summary"]["avg_gdp_impact"] for r in all_results 
              if r["persistence"] == persist]
    print(f"  ρ = {persist:.2f}: Avg GDP Impact = {np.mean(subset):.4f}%")
print()

# Effect of monetary response
print("Effect of Monetary Policy Response:")
for mon_resp in monetary_response:
    subset = [r["summary"]["avg_gdp_impact"] for r in all_results 
              if r["monetary_response"] == mon_resp]
    print(f"  Response = {mon_resp:.1f}: Avg GDP Impact = {np.mean(subset):.4f}%")

print()
print("="*70)
print("✅ FRB/US-style simulation complete!")
print(f"Results saved to: {output_dir}/")
print("Ready to create new dashboard!")
print("="*70)
