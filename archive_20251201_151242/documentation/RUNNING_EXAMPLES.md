# Running DSGE Examples with Your FRED API Key

## ✅ Your FRED API Key is Set Up!

Your API key: `3218a203525a91d2a4478ca92f3f9851`

I've configured it in: `~/.julia/config/startup.jl`

This means every time Julia starts, your FRED API key will be automatically loaded!

## Quick Test - Does Your API Key Work?

Run this in your terminal:

```bash
cd ~/Desktop/Other\ Research/DGSE-AI-Shock-Demo/DSGE.jl
julia --project=.
```

Then in the Julia REPL:

```julia
# Test the FRED API key
using FredData

# This should work if your API key is valid
f = Fred()
println("✓ FRED API connection successful!")

# Try downloading some data
gdp = get_data(f, "GDP")
println("Downloaded GDP data: $(size(gdp, 1)) observations")
```

If this works, you're all set! ✅

## Running the Example Scripts

### Option 1: Quick Demo (5-10 minutes)

This runs a simplified version that's fast:

```bash
cd ~/Desktop/Other\ Research/DGSE-AI-Shock-Demo
julia --project=DSGE.jl quick_demo_with_data.jl
```

What it does:
- Loads real economic data from FRED
- Creates the NY Fed Model 1002
- Estimates parameters (quick version)
- Shows you the key results

### Option 2: Full Default Example (2-3 hours)

This runs the complete estimation with Bayesian MCMC sampling:

```bash
cd ~/Desktop/Other\ Research/DGSE-AI-Shock-Demo/DSGE.jl
julia --project=. examples/run_default.jl
```

What it does:
- Full parameter estimation with 100 MCMC draws
- Generates modal forecasts
- Generates full-distribution forecasts
- Creates LaTeX tables of results

⚠️ **Warning**: This takes 2-3 hours to run!

### Option 3: Interactive Exploration

Start Julia and explore step-by-step:

```bash
cd ~/Desktop/Other\ Research/DGSE-AI-Shock-Demo/DSGE.jl
julia --project=.
```

Then follow along:

```julia
using DSGE, ModelConstructors, Dates

# 1. Create the model
m = Model1002("ss10")
m <= Setting(:data_vintage, "181115")
m <= Setting(:date_forecast_start, quartertodate("2018-Q4"))
m <= Setting(:use_population_forecast, false)

# 2. Load data
df = load_data(m, try_disk=false, check_empty_columns=false, 
               summary_statistics=:none)
println("Loaded data: ", size(df))

# 3. Check the data
println(first(df, 5))  # First 5 rows
println(names(df))     # Column names

# 4. Convert to matrix for estimation
data = df_to_matrix(m, df)

# 5. Look at model parameters
println("Technology shock persistence (ρ_z): ", m[:ρ_z].value)
println("Technology shock volatility (σ_z): ", m[:σ_z].value)

# 6. For quick optimization only (no MCMC):
# estimate(m, data; verbose=:high)

# 7. Modify parameters for AI shock scenario
m[:ρ_z] = 0.98  # More persistent
m[:σ_z] = 0.02  # Larger shocks
println("Modified for AI shock scenario!")
```

## Understanding the Output

When you run the examples, you'll see:

### 1. Model Loading
```
Initializing model object...
Setting default parameters...
Computing steady-state...
```

### 2. Data Loading
```
Downloading data from FRED...
Processing observables...
Transforming to model units...
```

### 3. Estimation
```
Optimizing posterior...
Computing Hessian...
Running Metropolis-Hastings...
```

### 4. Results
- Parameter estimates with standard errors
- Log-likelihood values
- Acceptance rates (for MCMC)
- Forecast outputs

## Analyzing AI Productivity Shocks

Once you understand the basic model, here's how to study AI shocks:

### Step 1: Understand Baseline Technology Shocks

Technology in the model follows:
```
log(A_t) = ρ_z * log(A_{t-1}) + σ_z * ε_t
```

Where:
- `ρ_z` ≈ 0.95 (high persistence - shocks last a long time)
- `σ_z` ≈ 0.007 (small typical shocks)

### Step 2: Create an AI Shock Scenario

Modify these parameters to represent AI:

```julia
# AI causes larger, more persistent productivity gains
m[:ρ_z] = 0.98   # AI effects are very persistent
m[:σ_z] = 0.02   # AI shock is ~3x larger than typical shock

# Or create a one-time large shock
# This would require modifying the shock process directly
```

### Step 3: Run Impulse Response Functions

```julia
# After estimation, generate IRFs
using Plots

# This shows how economy responds to a 1-std-dev technology shock
irf_output = impulse_responses(m, :productivity)

# Plot the responses
plot(irf_output[:output], label="GDP", title="Response to Tech Shock")
```

### Step 4: Compare Scenarios

Run two versions:
1. Baseline (normal ρ_z and σ_z)
2. AI Scenario (increased ρ_z and σ_z)

Compare forecasts to see AI impact!

## Troubleshooting

### "Invalid API Key" Error
```julia
# Check your key is set:
println(ENV["FRED_API_KEY"])

# If empty, set it:
ENV["FRED_API_KEY"] = "3218a203525a91d2a4478ca92f3f9851"
```

### "Data Vintage Not Found"
Try a different vintage:
```julia
m <= Setting(:data_vintage, "200511")  # Older data
```

### "Estimation is Slow"
Reduce MCMC draws:
```julia
m <= Setting(:n_mh_simulations, 50)  # Much faster for testing
```

### "Out of Memory"
Reduce block size:
```julia
m <= Setting(:forecast_block_size, 5)
```

## Files Created During Estimation

The model will create files in `DSGE.jl/save/`:

- `output_data/m1002/ss10/estimate/raw/*.h5` - Parameter draws
- `output_data/m1002/ss10/forecast/raw/*.jld2` - Forecasts
- `output_data/m1002/ss10/tables/` - LaTeX tables

## Next Steps After Running Examples

1. **Understand the estimates**: Look at which parameters changed
2. **Generate forecasts**: See predictions for GDP, inflation, etc.
3. **Create scenarios**: Modify parameters for AI shock analysis
4. **Visualize results**: Use the plotting functions
5. **Write up findings**: Document the AI shock impacts

## Additional Resources

- **Full Example Code**: `DSGE.jl/examples/run_default.jl`
- **Model Docs**: `DSGE.jl/docs/DSGE_Model_Documentation_1002.pdf`
- **Online Docs**: https://frbny-dsge.github.io/DSGE.jl/stable/
- **FRED Website**: https://fred.stlouisfed.org/

## Your API Key is Secure

The API key is stored in your local `~/.julia/config/startup.jl` file.
This file is on your computer only and not shared anywhere.

---

**Ready to run examples?** Start with Option 1 (Quick Demo) above! 🚀
