# DSGE AI Shock Analysis - Interactive Dashboard

🌐 **Live Demo:** [mightbeuseless.com](https://mightbeuseless.com)

An interactive web-based tool for exploring how AI productivity shocks propagate through economies with different structural characteristics.

## 🎯 What This Does

Visualize **125 economic scenarios** showing how different parameters affect an economy's response to a 25% AI productivity shock:

- **α (Capital Share)**: 0.30 to 0.45 - How capital-intensive is the economy?
- **ρ_z (Tech Persistence)**: 0.90 to 0.98 - How long do technology effects last?
- **σ_z (Tech Volatility)**: 0.005 to 0.020 - How unpredictable are technology shocks?

## 🚀 Try It Online

**Visit: [mightbeuseless.com](https://mightbeuseless.com)**

Use the interactive sliders to:
- Adjust economic parameters in real-time
- See instant chart updates
- Explore how AI shocks affect GDP, investment, wages, and returns
- Compare different economic structures

## 📊 Features

- **Real-Time Visualization**: Four interactive Plotly charts
- **125 Pre-Computed Scenarios**: Instant parameter switching
- **Economic Insights**: Summary statistics for each scenario
- **AI Shock Analysis**: Red marker shows the 25% technology boost at period 25

## 🎮 How to Use

1. Visit the website
2. Move the three parameter sliders
3. Watch the charts update instantly
4. Observe how the AI shock (red line) affects different economies

## 🔬 The Model

Based on Real Business Cycle (RBC) framework:
- **Production Function**: Y = A × K^α × L^(1-α)
- **Technology Evolution**: A_t = exp(ρ_z × log(A_{t-1}) + σ_z × ε_t)
- **Simulation**: 100 time periods with AI shock at period 25
- **Calibration**: Inspired by NY Federal Reserve DSGE methodology

## 📈 Key Findings

- **Capital share (α)** has the strongest impact: ~140% output increase from α=0.30 to α=0.45
- **Technology persistence (ρ_z)** creates long-lasting effects: Higher persistence = sustained growth
- **Volatility (σ_z)** has minimal average impact but increases fluctuations

## 🛠 Technology Stack

- **Simulation**: Julia 1.6.7 with RBC economic model
- **Visualization**: Plotly.js for interactive charts
- **Hosting**: GitHub Pages
- **Domain**: Custom domain via GitHub Pages

## 📁 Project Structure

```
├── index.html                  # Main dashboard (interactive_dashboard.html)
├── simulation_results/
│   ├── simulation_data.json   # All 125 scenarios (2.9 MB)
│   └── simulation_lookup.json # Quick lookup table
└── docs/                       # Documentation
```

## 🔬 For Researchers

### Running Locally

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/dsge-ai-shock-demo.git
cd dsge-ai-shock-demo
```

2. Start a local server:
```bash
python3 -m http.server 8000
```

3. Open: http://localhost:8000

### Re-running Simulations

Requirements: Julia 1.6+

```bash
julia run_parameter_sweep.jl
```

This regenerates all 125 scenarios with your own parameter choices.

## 📚 Documentation

- **DASHBOARD_GUIDE.md** - Complete usage guide
- **SIMULATION_COMPLETE.md** - Detailed findings
- **TROUBLESHOOTING.md** - Common issues and solutions
- **SETUP_GUIDE.md** - Local development setup

## 🎓 Background

This project explores AI productivity shock scenarios using Dynamic Stochastic General Equilibrium (DSGE) modeling:

- **Technology Shocks**: How do economies respond to sudden productivity increases?
- **Capital Accumulation**: Does investment drive long-run growth?
- **Factor Prices**: How do wages and returns adjust?
- **Policy Implications**: Should economies prepare differently for AI shocks?

Inspired by the [NY Federal Reserve DSGE Model](https://github.com/FRBNY-DSGE/DSGE.jl).

## 🤝 Contributing

Contributions welcome! Ideas for enhancements:

- Add more economic parameters (labor supply elasticity, depreciation rate)
- Implement different shock types (government spending, monetary policy)
- Add scenario comparison mode
- Export functionality for charts and data
- More sophisticated DSGE specifications

## 📝 License

MIT License - Feel free to use and modify for research or educational purposes.

## 🌟 Credits

- **Economic Model**: Inspired by NY Fed DSGE methodology
- **Visualization**: Plotly.js
- **Simulation**: Julia programming language
- **Created by**: Ali Anver

## 🔗 Links

- **Live Dashboard**: [mightbeuseless.com](https://mightbeuseless.com)
- **GitHub Repository**: [github.com/YOUR_USERNAME/dsge-ai-shock-demo](https://github.com/YOUR_USERNAME/dsge-ai-shock-demo)
- **NY Fed DSGE Model**: [FRBNY-DSGE/DSGE.jl](https://github.com/FRBNY-DSGE/DSGE.jl)

---

**Built for economic research and education. Explore how AI shapes economic outcomes! 🚀**
