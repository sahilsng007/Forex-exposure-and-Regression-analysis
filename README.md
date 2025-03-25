Conducted Comprehensive analysis of RS Group PLC foreign exposure through regression analysis.


Overview

This project analyzes foreign exchange exposure and its impact on RS Group, a UK-based global MRO distributor listed on the FTSE 250. The study utilizes regression analysis to model the relationship between stock returns and currency exchange rate fluctuations.

Project Structure

├── Data_for_research_project.xlsx   # Dataset used for analysis
├── Regression_Project.R             # R script for regression analysis
├── FX_Exposure_and_Regression.pdf   # Detailed project report
├── .gitignore                       # Files to be ignored by Git
├── README.md                        # Project documentation

Data Sources

Stock and market data: Sourced from Bloomberg Terminal.

Foreign exchange rates: Collected over a 10-year period (2013-2024).

Risk-free rate: Bank of England’s annualized rate, converted to a daily rate.

Methodology

Data Transformation:

Daily prices converted to log returns.

Exchange rate fluctuations analyzed for impact on stock performance.

Regression Model:

Dependent Variable: Stock return excess of risk-free rate (RSPEXSS).

Independent Variables: Market portfolio return (FTSE 250) and five currency exchange rate changes (USD, EUR, JPY, ZAR, CNH against GBP).

Statistical Tests & Diagnostics:

CAPM Model applied to analyze stock and market returns.

Multicollinearity Check (VIF & Correlation Matrix).

Heteroscedasticity detected and corrected using White’s test.

Structural Breaks examined using Chow Test.

Normality Testing to identify outliers and residual patterns.

Key Findings

Market index (FTSE 250) has a strong positive impact on RS Group stock returns.

Currency pairs exhibit weak or insignificant relationships with stock performance.

Structural break detected in May 2018, possibly due to Brexit or other geopolitical events.

Model stability concerns: Additional variables may be required to improve predictive power.

Setup & Installation

Prerequisites

Ensure you have R and required packages installed:

install.packages(c("lmtest", "car", "tseries"))

Running the Analysis

Clone this repository:

git clone https://github.com/yourusername/FX_Exposure_Regression.git

Navigate to the project folder:

cd FX_Exposure_Regression


source("Regression_Project.R")

Results Interpretation

p-values & significance levels indicate the relevance of each variable.

R-squared value explains the proportion of variance captured by the model.

Residual analysis helps in detecting model fit issues.



