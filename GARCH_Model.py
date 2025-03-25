import numpy as np
import matplotlib.pyplot as plt
from arch import arch_model

# Generate synthetic return data (1000 random values)
np.random.seed(42)
returns = np.random.normal(0, 1, 1000)  # Simulated returns

# Define GARCH(1,1) model with the generated returns
garch_model = arch_model(returns, mean="Zero", vol="Garch", p=1, q=1)

# Fit the model
garch_results = garch_model.fit(disp="off")

# Print summary
print(garch_results.summary())

# Extract volatility and residuals
sigma_t = np.sqrt(garch_results.conditional_volatility)
epsilon_t = garch_results.resid

# Plot results
plt.figure(figsize=(12, 5))

# Plot GARCH noise
plt.subplot(2, 1, 1)
plt.plot(epsilon_t, label="GARCH Noise (ε_t)", color="red")
plt.axhline(0, color="black", linewidth=0.8, linestyle="dashed")
plt.title("GARCH Noise (Shocks)")
plt.legend()

# Plot conditional volatility
plt.subplot(2, 1, 2)
plt.plot(sigma_t, label="Conditional Volatility (σ_t)", color="blue")
plt.title("GARCH Conditional Volatility")
plt.legend()

plt.tight_layout()
plt.show()
