# AI Productivity Shock: Economic Model Dashboards

Interactive economic dashboards analyzing the impact of AI-driven productivity shocks on macroeconomic variables.

## 🌐 Live Dashboards

- **DSGE Model**: [mightbeuseless.com](https://mightbeuseless.com)
- **FRB/US Model**: [mightbeuseless.com/frbus_dashboard.html](https://mightbeuseless.com/frbus_dashboard.html)

## 📊 Models

### 1. DSGE (Dynamic Stochastic General Equilibrium)
- **File**: `index.html`
- **Simulations**: 125 scenarios
- **Parameters**: Technology persistence, volatility, capital share
- **Data**: Julia-based simulations tracking GDP, consumption, investment, wages, returns

### 2. FRB/US (Federal Reserve Board US Model)
- **File**: `frbus_dashboard.html`
- **Simulations**: 125 scenarios
- **Parameters**: Productivity shock (1-8%), persistence (0.90-0.98), monetary response (0.5-2.5)
- **Data**: Python-based simulations tracking GDP, inflation, unemployment, interest rates

## 🎯 Features

- **Interactive Controls**: Real-time parameter adjustment via sliders
- **Professional Design**: Clean, minimalist interface
- **Comprehensive Data**: 40 quarters (10 years) of economic projections
- **AI Shock Analysis**: Models significant AI-driven productivity improvements

## 🚀 Quick Start

### View Online
Visit [mightbeuseless.com](https://mightbeuseless.com) to interact with the dashboards immediately.

### Run Locally
```bash
# Clone repository
git clone https://github.com/Hamza-Anver/mightbeuseless-ali.git
cd mightbeuseless-ali

# Start local server
python3 -m http.server 8000

# Open in browser
open http://localhost:8000
```

## 📁 Repository Structure

```
├── index.html                      # DSGE dashboard
├── frbus_dashboard.html            # FRB/US dashboard
├── simulation_results/             # DSGE simulation data (2.9 MB)
│   ├── simulation_data.json
│   └── simulation_lookup.json
├── frbus_simulations/              # FRB/US simulation data (1.4 MB)
│   ├── frbus_simulation_data.json
│   └── frbus_simulation_lookup.json
├── run_frbus_simplified.py         # FRB/US simulation script
└── CUSTOM_DOMAIN_SETUP.md          # Deployment guide
```

## 🔬 Model Details

### DSGE Model
- **Technology Shock**: 25% productivity boost at period 25
- **Persistence Range**: ρ ∈ [0.90, 0.98]
- **Volatility Range**: σ ∈ [0.005, 0.020]
- **Capital Share**: α ∈ [0.30, 0.45]

### FRB/US Model
- **Shock Timing**: Q3 2026 (period 6)
- **Shock Size**: 1%, 2%, 3%, 5%, 8%
- **Persistence**: ρ ∈ [0.90, 0.98]
- **Monetary Policy**: Response coefficient ∈ [0.5, 2.5]

## 📈 Key Results

### DSGE Model
- Technology shocks create persistent GDP increases
- Investment responds more strongly than consumption
- Higher capital share amplifies shock effects

### FRB/US Model
- **Average GDP Impact**: 2.28% across all scenarios
- **Range**: 0.36% to 6.78% depending on parameters
- **Persistence Effect**: Higher persistence → larger long-term gains
- **8% Shock**: Results in ~4.80% average GDP increase

## 🛠️ Technologies

- **Frontend**: HTML5, CSS3, JavaScript
- **Visualization**: Plotly.js
- **Simulation**: Julia (DSGE), Python (FRB/US)
- **Hosting**: GitHub Pages
- **Domain**: Custom domain via CNAME

## 📝 License

This project is open source and available for educational and research purposes.

## 🔗 Links

- **Live Site**: [mightbeuseless.com](https://mightbeuseless.com)
- **Repository**: [github.com/Hamza-Anver/mightbeuseless-ali](https://github.com/Hamza-Anver/mightbeuseless-ali)
- **Original Repo**: [github.com/Ali-Anver/dsge-ai-shock-demo](https://github.com/Ali-Anver/dsge-ai-shock-demo)

## 👤 Author

**Ali Anver**

---

*Interactive economic modeling for understanding AI's macroeconomic impact*
