# DSGE.jl Setup Guide for Beginners

## Overview
You've successfully cloned the NY Federal Reserve's DSGE.jl repository - a professional-grade Dynamic Stochastic General Equilibrium modeling framework used for economic forecasting and analysis.

## Current Status ✅
- ✅ Julia 1.12.2 is installed
- ✅ DSGE.jl repository cloned from GitHub
- ⚠️ Package has compatibility issues with Julia 1.12.2

## The Challenge
The DSGE.jl package was built for Julia v1.x (around v1.1-1.6) and has compatibility issues with the latest Julia 1.12.2. This is common with research codebases that aren't updated frequently.

## Solutions

### Option 1: Use an Older Julia Version (Recommended)
The DSGE.jl documentation states it's compatible with Julia v1.x. You should install Julia 1.6 (LTS - Long Term Support version) which is more likely to work with this codebase.

**Steps:**
1. Install Julia 1.6 using juliaup (your Julia version manager):
   ```bash
   juliaup add 1.6
   juliaup default 1.6
   ```

2. Then navigate to the DSGE.jl folder and activate the environment:
   ```bash
   cd "~/Desktop/Other Research/DGSE-AI-Shock-Demo/DSGE.jl"
   julia
   ```

3. In the Julia REPL, activate and instantiate the project:
   ```julia
   using Pkg
   Pkg.activate(".")
   Pkg.instantiate()
   ```

### Option 2: Start with a Simple Custom Model (For Learning)
If you want to learn DSGE modeling concepts first before diving into the complex Fed model, you can:

1. Use the simple `NY-FED.jl` file I created for you (which works!)
2. Build up your understanding gradually
3. Then tackle the full NY Fed model once you're comfortable

### Option 3: Update the Package Dependencies (Advanced)
Try to update the package to work with Julia 1.12, but this requires:
- Understanding Julia package management
- Updating compatibility bounds in Project.toml
- Potentially fixing breaking changes in the code

## What the DSGE.jl Package Does

The package includes:
- **Model1002**: The NY Fed's baseline DSGE model (Version 1002)
- **Estimation tools**: Bayesian estimation using MCMC methods
- **Forecasting**: Generate economic forecasts with uncertainty bands
- **Data handling**: Automatically loads economic data from FRED (Federal Reserve Economic Data)
- **Shock analysis**: Simulate how shocks (like technology/AI shocks) affect the economy

## Example Scripts Available

In the `examples/` folder:
- `run_default.jl` - Run the baseline model estimation and forecast
- `regime_switching.jl` - Models with regime changes
- `test_smc.jl` - Sequential Monte Carlo estimation
- And more...

## Next Steps

1. **Decision**: Choose which option above works best for you
2. **FRED API Key**: If you want to load real economic data, sign up for a free FRED API key at https://fred.stlouisfed.org/docs/api/api_key.html
3. **Learn**: Read the documentation at https://frbny-dsge.github.io/DSGE.jl/stable/
4. **Run**: Start with simple examples and build up

## Resources

- **Documentation**: https://frbny-dsge.github.io/DSGE.jl/stable/
- **Model Documentation PDF**: `docs/DSGE_Model_Documentation_1002.pdf` in the repo
- **GitHub Issues**: Check existing issues for solutions to common problems
- **Your simple model**: `NY-FED.jl` - already working!

## Getting Help

As a beginner, I recommend:
1. Start with the simple `NY-FED.jl` model I created to understand DSGE basics
2. Read through the example scripts to see how the NY Fed code works
3. Consider joining Julia communities (Discourse, Slack) for help
4. Be patient - this is complex economic modeling software used by the Federal Reserve!

---

**Created**: November 30, 2025
**For**: Ali Anver - DGSE AI Shock Demo Project
