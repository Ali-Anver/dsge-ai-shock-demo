# Simple Parameter Sweep Using Calibrated Values
# For DSGE AI Shock Analysis
# By Ali Anver

using Printf
using JSON
using Random
using Dates

println("="^70)
println("Simple DSGE Parameter Sweep - Calibrated Model")
println("="^70)
println()

# Create output directory
output_dir = "simulation_results"
if !isdir(output_dir)
    mkdir(output_dir)
end

##############
# Model Setup (Simple RBC Style)
##############

# Baseline parameters (calibrated values)
struct Parameters
    α::Float64      # Capital share
    β::Float64      # Discount factor
    δ::Float64      # Depreciation rate
    ρ_z::Float64    # Technology persistence
    σ_z::Float64    # Technology volatility
end

# Production function
function production(K, L, A, α)
    return A * K^α * L^(1-α)
end

# Technology shock evolution
function tech_shock(A_prev, ρ_z, σ_z, ε)
    return exp(ρ_z * log(A_prev) + σ_z * ε)
end

function simulate_economy(params::Parameters, n_periods::Int=100)
    """Simulate simple RBC economy"""
    
    # Initialize arrays
    A = ones(n_periods)      # Technology
    K = zeros(n_periods)     # Capital
    Y = zeros(n_periods)     # Output
    C = zeros(n_periods)     # Consumption
    I = zeros(n_periods)     # Investment
    L = ones(n_periods)      # Labor (normalized)
    W = zeros(n_periods)     # Wages
    R = zeros(n_periods)     # Capital return
    
    # Steady state capital
    K[1] = ((params.α * params.β) / (1 - params.β * (1 - params.δ)))^(1/(1-params.α))
    
    # Generate shocks
    Random.seed!(42)
    shocks = randn(n_periods)
    
    # Add large AI shock at period 25
    if n_periods >= 25
        shocks[25] = 3.0  # Large positive shock
    end
    
    # Simulation
    for t in 2:n_periods
        # Technology evolution
        A[t] = tech_shock(A[t-1], params.ρ_z, params.σ_z, shocks[t])
        
        # Production
        Y[t-1] = production(K[t-1], L[t-1], A[t-1], params.α)
        
        # Factor prices
        W[t-1] = (1 - params.α) * Y[t-1] / L[t-1]
        R[t-1] = params.α * Y[t-1] / K[t-1]
        
        # Investment (simple rule: 25% of output)
        I[t-1] = 0.25 * Y[t-1]
        
        # Consumption (residual)
        C[t-1] = Y[t-1] - I[t-1]
        
        # Capital accumulation
        K[t] = (1 - params.δ) * K[t-1] + I[t-1]
    end
    
    # Final period
    Y[n_periods] = production(K[n_periods], L[n_periods], A[n_periods], params.α)
    W[n_periods] = (1 - params.α) * Y[n_periods] / L[n_periods]
    R[n_periods] = params.α * Y[n_periods] / K[n_periods]
    I[n_periods] = 0.25 * Y[n_periods]
    C[n_periods] = Y[n_periods] - I[n_periods]
    
    return Dict(
        "periods" => collect(1:n_periods),
        "technology" => A,
        "capital" => K,
        "output" => Y,
        "consumption" => C,
        "investment" => I,
        "labor" => L,
        "wages" => W,
        "capital_return" => R
    )
end

##############
# Parameter Grids
##############

println("Setting up parameter grids...")
println()

# Technology shock parameters
ρ_z_values = [0.90, 0.93, 0.95, 0.97, 0.98]  # Persistence
σ_z_values = [0.005, 0.007, 0.010, 0.015, 0.020]  # Volatility

# Capital share
α_values = [0.30, 0.33, 0.36, 0.40, 0.45]

# Fixed parameters
β_fixed = 0.96   # Discount factor
δ_fixed = 0.025  # Depreciation

println("Parameter ranges:")
println("  ρ_z (tech persistence): $ρ_z_values")
println("  σ_z (tech volatility):  $σ_z_values")  
println("  α (capital share):      $α_values")
println()

total_sims = length(ρ_z_values) * length(σ_z_values) * length(α_values)
println("Total simulations: $total_sims")
println()

##############
# Run Simulations
##############

println("Running simulations...")
println("="^70)

all_results = []
sim_count = 0

for α in α_values
    for ρ_z in ρ_z_values
        for σ_z in σ_z_values
            global sim_count += 1
            
            if sim_count % 10 == 0
                println("Progress: $sim_count/$total_sims")
            end
            
            # Create parameters
            params = Parameters(α, β_fixed, δ_fixed, ρ_z, σ_z)
            
            # Run simulation
            results = simulate_economy(params, 100)
            
            # Add parameters and metadata
            sim_data = Dict(
                "simulation_id" => sim_count,
                "α" => α,
                "ρ_z" => ρ_z,
                "σ_z" => σ_z,
                "β" => β_fixed,
                "δ" => δ_fixed,
                "data" => results,
                "summary" => Dict(
                    "avg_output" => sum(results["output"]) / length(results["output"]),
                    "max_output" => maximum(results["output"]),
                    "min_output" => minimum(results["output"]),
                    "final_output" => results["output"][end],
                    "avg_wages" => sum(results["wages"]) / length(results["wages"]),
                    "avg_capital_return" => sum(results["capital_return"]) / length(results["capital_return"])
                )
            )
            
            push!(all_results, sim_data)
        end
    end
end

println()
println("✓ All simulations complete!")
println()

##############
# Save Results
##############

println("Saving results...")

# Create comprehensive output
output_data = Dict(
    "metadata" => Dict(
        "date" => string(Dates.now()),
        "total_simulations" => length(all_results),
        "n_periods" => 100,
        "parameters" => Dict(
            "α_values" => α_values,
            "ρ_z_values" => ρ_z_values,
            "σ_z_values" => σ_z_values,
            "β_fixed" => β_fixed,
            "δ_fixed" => δ_fixed
        )
    ),
    "simulations" => all_results
)

# Save as JSON
json_file = joinpath(output_dir, "simulation_data.json")
open(json_file, "w") do f
    JSON.print(f, output_data, 2)
end
println("✓ Saved: simulation_data.json")

# Create lookup table for website
lookup_table = []
for sim in all_results
    push!(lookup_table, Dict(
        "α" => sim["α"],
        "ρ_z" => sim["ρ_z"],
        "σ_z" => sim["σ_z"],
        "simulation_id" => sim["simulation_id"],
        "avg_output" => sim["summary"]["avg_output"],
        "final_output" => sim["summary"]["final_output"]
    ))
end

lookup_file = joinpath(output_dir, "simulation_lookup.json")
open(lookup_file, "w") do f
    JSON.print(f, Dict("simulations" => lookup_table), 2)
end
println("✓ Saved: simulation_lookup.json")

##############
# Summary Stats
##############

println()
println("="^70)
println("Summary Statistics")
println("="^70)
println()

avg_outputs = [s["summary"]["avg_output"] for s in all_results]
println(@sprintf("Overall Average Output: %.4f", sum(avg_outputs) / length(avg_outputs)))
println(@sprintf("  Range: %.4f to %.4f", minimum(avg_outputs), maximum(avg_outputs)))
println()

println("Effect of Capital Share (α):")
for α in α_values
    subset = filter(s -> s["α"] == α, all_results)
    avg = sum([s["summary"]["avg_output"] for s in subset]) / length(subset)
    println(@sprintf("  α = %.2f: Avg Output = %.4f", α, avg))
end
println()

println("Effect of Tech Persistence (ρ_z):")
for ρ_z in ρ_z_values
    subset = filter(s -> s["ρ_z"] == ρ_z, all_results)
    avg = sum([s["summary"]["avg_output"] for s in subset]) / length(subset)
    println(@sprintf("  ρ_z = %.2f: Avg Output = %.4f", ρ_z, avg))
end
println()

println("Effect of Tech Volatility (σ_z):")
for σ_z in σ_z_values
    subset = filter(s -> s["σ_z"] == σ_z, all_results)
    avg = sum([s["summary"]["avg_output"] for s in subset]) / length(subset)
    println(@sprintf("  σ_z = %.3f: Avg Output = %.4f", σ_z, avg))
end

println()
println("="^70)
println("✅ Simulation complete!")
println("Results saved to: $output_dir/")
println("Ready to create interactive website!")
println("="^70)
