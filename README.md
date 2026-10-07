# Consumer Loan Portfolio Analysis & Credit Risk Modelling

## Overview

This project presents an end-to-end analysis of a consumer loan portfolio, combining **SQL-based portfolio analytics, exploratory data analysis, credit risk segmentation, and predictive modelling** to examine loan performance and default risk.

The analysis moves from portfolio-level questions such as exposure, concentration, loan characteristics, and realised performance to borrower-level default analysis and machine-learning-based credit-risk prediction.

The objective is not only to describe the portfolio, but to identify meaningful risk patterns and evaluate whether borrower and loan characteristics can be used to distinguish between resolved loans that were fully paid and those that were charged off.

---

## Project Objectives

The analysis addresses four main objectives:

1. **Understand the composition and structure of the loan portfolio**
2. **Identify portfolio concentration and credit-risk patterns**
3. **Examine factors associated with observed loan default**
4. **Develop and evaluate predictive models for default risk**

---

## Analytical Workflow

```text
Raw Loan Data
      ↓
Data Cleaning & Preparation
      ↓
Exploratory Data Analysis
      ↓
SQL Portfolio Analytics
      ↓
Default Risk Analysis & Segmentation
      ↓
Model Dataset Preparation
      ↓
Random Forest & XGBoost Modelling
      ↓
Model Evaluation & Interpretation
      ↓
Credit Risk Insights
```

---

## Portfolio Overview

The cleaned portfolio contains **38,576 loans** with approximately **$435.8 million in total loan exposure**.

Key portfolio metrics include:

| Metric              |        Value |
| ------------------- | -----------: |
| Total Loans         |       38,576 |
| Total Loan Exposure | $435,757,075 |
| Average Loan Amount |   $11,296.07 |
| Fully Paid          |        83.3% |
| Charged Off         |        13.8% |
| Current             |         2.8% |

The portfolio is concentrated across several major segments:

* **Debt consolidation** represents the largest loan-purpose exposure at approximately **$232.5 million**, or **53.35% of total exposure**.
* **California** represents approximately **18.01% of portfolio exposure**, followed by New York (**9.66%**), Texas (**7.17%**), and Florida (**6.90%**).
* **Renters account for 47.80% of loan volume**, while borrowers with mortgages represent approximately **50.33% of total exposure**.
* The portfolio is also concentrated around **36-month loans and stronger credit grades**, providing important context for subsequent risk analysis.

---

## SQL Portfolio Analytics

SQL was used as a separate business-analytics layer to investigate portfolio performance and concentration independently of the Python analysis.

The SQL analysis is organised into five analytical modules:

### 1. Portfolio Overview

Examines the overall portfolio structure, including loan volumes, exposure, average loan characteristics, loan status, and major portfolio segments.

### 2. Credit Risk Analysis

Examines realised loan outcomes and credit-risk characteristics, including default and charge-off patterns.

### 3. Loan Segmentation

Breaks the portfolio into meaningful borrower and loan segments to identify differences in portfolio composition and observed risk.

### 4. Portfolio Concentration

Analyses exposure concentration across dimensions such as loan purpose and geographic location, highlighting segments that represent a significant share of portfolio exposure.

### 5. Portfolio Performance

Evaluates realised loan performance and portfolio outcomes from a business and risk perspective.

The SQL workflow uses a SQLite database containing the cleaned loan data and is designed to complement, rather than duplicate, the Python-based exploratory analysis.

---

## Exploratory Data Analysis

The EDA examines portfolio structure and observed default behaviour across borrower, loan, credit, geographic, and origination characteristics.

### Resolved Loan Outcomes

For default analysis and predictive modelling, only loans with resolved outcomes are considered.

* **Fully Paid** loans are coded as non-default (`0`)
* **Charged Off** loans are coded as default (`1`)
* **Current** loans are excluded because their eventual repayment outcome has not yet been observed

This produces a modelling population of **37,478 resolved loans**, including:

* **32,145 non-defaulted loans**
* **5,333 defaulted loans**
* **14.23% observed default rate**

The target is therefore moderately imbalanced, making metrics such as **Average Precision, Recall, and ROC-AUC** more informative than accuracy alone.

---

## Key Credit Risk Findings

### Credit Grade

Credit grade shows one of the clearest relationships with observed default risk.

Default rates increase consistently from:

* **Grade A:** 5.72%
* **Grade G:** 33.11%

The results indicate strong differentiation in observed default risk across credit grades.

The more granular `sub_grade` variable was also examined. Because of its higher dimensionality and sparsity across some categories, **`grade` was retained as the more stable and interpretable credit-risk indicator**.

### Interest Rate

Default rates increase substantially across interest-rate bands:

| Interest Rate | Observed Default Rate |
| ------------- | --------------------: |
| 5%–10%        |                 6.39% |
| 10%–15%       |                14.37% |
| 15%–20%       |                24.45% |
| 20%–25%       |                38.13% |

This shows a strong positive association between interest rate and observed default risk within the portfolio.

### Loan Term

Loan term also shows a substantial difference in observed risk:

* **36-month loans:** 10.71% default rate
* **60-month loans:** 25.00% default rate

This represents a difference of approximately **14.29 percentage points**.

### Debt-to-Income Ratio

DTI shows a more moderate relationship with observed default risk. Default rates generally increase from **12.05%** among borrowers with DTI between 0%–5% to **16.51%** among borrowers in the 20%–25% range.

The relationship is less consistent than those observed for credit grade, interest rate, and loan term.

### Loan Purpose

Default rates vary meaningfully by loan purpose.

**Small business loans** recorded the highest observed default rate at **26.72%**, while debt consolidation, the largest purpose segment by exposure, recorded a default rate of approximately **15.02%**.

Smaller categories such as renewable energy should be interpreted cautiously because relatively low observation counts can produce less stable estimates.

### Employment Length & Home Ownership

Employment length shows relatively limited standalone differentiation, with default rates remaining close to the overall portfolio default rate.

Home ownership also shows relatively modest differences across the major borrower groups, suggesting weaker standalone risk differentiation than credit grade, interest rate, and loan term.

---

## Predictive Modelling

The modelling stage evaluates whether borrower and loan characteristics can be used to predict whether a resolved loan will be charged off.

### Modelling Dataset

The final modelling dataset contains:

* **37,478 observations**
* **14 predictor variables**
* **1 binary target variable**

The predictors cover:

**Borrower characteristics**

* Employment length
* Annual income
* Debt-to-income ratio
* Home ownership
* Verification status
* Total accounts

**Loan characteristics**

* Loan amount
* Loan term
* Installment
* Interest rate
* Loan purpose

**Credit risk**

* Credit grade

**Geography**

* Address state

**Origination timing**

* Issue month

Variables reflecting post-origination performance, such as loan status, payment information, and later credit activity, were excluded to reduce the risk of data leakage and preserve an origination-time prediction framework.

---

## Modelling Approach

Two ensemble classification algorithms were evaluated:

### Random Forest

Random Forest was used as the initial ensemble benchmark.

The model incorporated `class_weight="balanced"` to account for the minority default class.

Both the initial and tuned Random Forest configurations were evaluated using **5-fold stratified cross-validation**.

### XGBoost

XGBoost was evaluated as a second ensemble approach capable of modelling non-linear relationships and interactions between borrower and loan characteristics.

Class imbalance was addressed using `scale_pos_weight`, calculated from the training data.

A focused hyperparameter search was performed using **5-fold Stratified K-Fold cross-validation**.

---

## Model Selection

Because default is the minority outcome, **Average Precision** was used as the primary model-selection metric.

The four model configurations produced the following cross-validation results:

| Model                 | Accuracy | Precision |   Recall |       F1 |  ROC-AUC | Avg. Precision |
| --------------------- | -------: | --------: | -------: | -------: | -------: | -------------: |
| Initial Random Forest |     0.86 |      0.45 |     0.01 |     0.02 |     0.68 |           0.26 |
| Tuned Random Forest   |     0.78 |      0.29 |     0.38 |     0.33 |     0.70 |           0.28 |
| Initial XGBoost       |     0.73 |      0.24 |     0.42 |     0.31 |     0.66 |           0.25 |
| **Tuned XGBoost**     | **0.66** |  **0.24** | **0.63** | **0.34** | **0.70** |       **0.29** |

The **tuned XGBoost model** was selected because it achieved the highest Average Precision during cross-validation while providing substantially stronger default-class recall than the initial models.

The selected configuration uses:

* 200 trees
* Maximum depth of 3
* Learning rate of 0.05
* Row subsampling of 0.80
* Feature subsampling of 0.80
* `scale_pos_weight` of 6.03

---

## Final Model Performance

The final XGBoost model was evaluated once on the previously untouched test dataset.

| Metric            | Test Result |
| ----------------- | ----------: |
| Accuracy          |      64.91% |
| Precision         |      23.54% |
| Recall            |      65.14% |
| F1-score          |        0.35 |
| ROC-AUC           |        0.71 |
| Average Precision |        0.28 |

The model achieved a **ROC-AUC of 0.71**, indicating meaningful separation between defaulted and non-defaulted loans.

Its **65% recall** means that approximately two-thirds of observed defaults in the test set were identified by the model.

However, the **24% precision** also shows that the model generates a substantial number of false-positive default classifications. This trade-off is important in a credit-risk setting, where the relative cost of missed defaults and unnecessary risk flags can differ depending on the business objective.

The confusion matrix showed:

* **695** correctly identified defaults
* **372** missed defaults
* **2,258** false-positive default classifications

---

## Threshold Analysis

The model's classification threshold affects the balance between precision and recall.

| Threshold |  Precision |     Recall |       F1 |
| --------: | ---------: | ---------: | -------: |
|      0.20 |     15.47% |     98.69% |     0.27 |
|      0.30 |     16.90% |     93.35% |     0.29 |
|      0.40 |     19.32% |     82.47% |     0.31 |
|  **0.50** | **23.54%** | **65.14%** | **0.35** |
|      0.60 |     29.45% |     42.92% |     0.35 |
|      0.70 |     35.47% |     21.27% |     0.27 |

The analysis demonstrates the expected trade-off: lowering the threshold captures more defaults but produces more false positives, while increasing the threshold improves precision at the cost of missing more defaults.

---

## Model Interpretation

Two complementary approaches were used to interpret the final XGBoost model:

### Built-in Feature Importance

Aggregated XGBoost feature importance highlighted:

1. `address_state`
2. `term_months`
3. `grade`
4. `purpose`
5. `issue_month`
6. `emp_length`
7. `int_rate`

### Permutation Importance

Permutation importance provided a performance-based view of the original modelling variables.

The variables with the clearest marginal contribution to predictive performance were:

1. **Interest rate**
2. **Loan term**
3. **Annual income**
4. **Loan purpose**

The difference between the two approaches is important. Built-in tree-based importance can rank variables differently from permutation importance, particularly when categorical variables are represented through multiple encoded features.

These results describe how the model uses the available information and **should not be interpreted as causal effects**.

---

## Key Portfolio & Risk Insights

The analysis highlights several important findings:

* The portfolio has approximately **$435.8 million in loan exposure** across **38,576 loans**.
* **Debt consolidation** represents more than half of total portfolio exposure.
* Geographic exposure is concentrated, with California representing approximately **18%** of total exposure.
* The resolved portfolio has a **14.23% observed default rate**.
* Credit grade provides strong differentiation in observed default risk.
* Higher interest-rate bands are associated with substantially higher observed default rates.
* 60-month loans show considerably higher observed default rates than 36-month loans.
* Small business loans represent a higher-risk purpose segment based on observed default rates.
* Default prediction is possible from the available borrower and loan characteristics, but the final model still produces a substantial number of false-positive classifications.
* Model interpretation indicates that **interest rate, loan term, annual income, and loan purpose** provide the clearest marginal predictive contribution under permutation analysis.

---

## Project Structure

```text
Consumer Loan Portfolio Analysis & Credit Risk Modelling/
│
├── data/
│   ├── loan_data.csv
│   ├── loan_data_cleaned.csv
│   ├── loan_portfolio.db
│   └── model_df.csv
│
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_eda.ipynb
│   └── 03_model.ipynb
│
├── sql/
│   ├── 01_portfolio_overview.sql
│   ├── 02_credit_risk_analysis.sql
│   ├── 03_loan_segmentation.sql
│   ├── 04_portfolio_concentration.sql
│   └── 05_portfolio_performance.sql
│
├── .gitignore
├── requirements.txt
├── README.md
└── LICENSE
```

---

## Tools & Technologies

**Languages & Analysis**

* Python
* SQL

**Python Libraries**

* Pandas
* NumPy
* Matplotlib
* Seaborn
* Scikit-learn
* XGBoost

**Database**

* SQLite

**Development Environment**

* Jupyter Notebook
* VS Code
* Git & GitHub

---

## Methodological Considerations

Several safeguards were incorporated into the modelling workflow:

* `Current` loans were excluded because their final outcomes were not yet observed.
* The test dataset was kept untouched during model development and hyperparameter tuning.
* Stratified 5-fold cross-validation was used because of class imbalance.
* Average Precision was prioritised for model selection rather than accuracy alone.
* Class imbalance was explicitly addressed in both ensemble modelling approaches.
* Preprocessing was integrated into the modelling pipeline.
* Post-origination variables were excluded from the predictor set to reduce data leakage.
* Feature importance was interpreted as descriptive rather than causal.
* Threshold analysis was used to demonstrate the precision-recall trade-off rather than to retrospectively optimise the test-set result.

---

## Limitations

This project is based on a historical loan dataset and should be interpreted as an analytical and educational credit-risk exercise rather than a production lending model.

Key limitations include:

* The modelling population contains only loans with resolved outcomes.
* The dataset does not capture every borrower, credit-history, economic, or macroeconomic factor that may influence repayment.
* Some categorical segments contain relatively few observations, which can make their observed default rates less stable.
* Geographic and other categorical variables may contain sparse groups.
* Origination timing is represented at the monthly level rather than using the full date.
* Model performance is specific to this dataset and evaluation framework and should not be assumed to generalise unchanged to other lending populations or time periods.
* The predictive model identifies statistical patterns in historical data and does not establish causal relationships.

---

## Future Improvements

Several extensions could strengthen the analysis further:

* **Out-of-time validation:** Evaluate the final model on a later loan vintage to test whether predictive performance remains stable when applied to a different lending period.
* **Portfolio risk scoring:** Convert predicted default probabilities into risk bands and quantify the number of loans and total exposure falling into each risk category.
* **Probability calibration:** Assess whether predicted default probabilities correspond reasonably to observed default frequencies across risk bands.
* **Model monitoring:** Compare model performance and portfolio composition across different origination periods to identify potential changes in model behaviour or portfolio risk.

These extensions would move the project from historical predictive analysis toward a more realistic **portfolio risk-monitoring framework**, while retaining the original modelling architecture.

---

## Conclusion

This project demonstrates a complete analytical workflow from **data preparation and portfolio analytics to SQL business analysis, credit-risk segmentation, predictive modelling, and model interpretation**.

The analysis identifies clear differences in observed default risk across credit grade, interest rate, loan term, and loan purpose. The modelling stage further demonstrates that these and other borrower and loan characteristics can provide useful predictive signal for distinguishing resolved defaulted loans from non-defaulted loans.

The final tuned XGBoost model achieved a **ROC-AUC of 0.71** and **Average Precision of 0.28** on the held-out test dataset, with **65% recall** at the default classification threshold.

The results also highlight an important practical consideration in credit-risk modelling: stronger default detection can come with a significant increase in false-positive classifications. This makes model evaluation, threshold selection, and business context critical when translating predictive outputs into risk-management decisions.

> **Note:** This project is an educational analysis based on historical data. The results demonstrate the analytical and modelling approach rather than representing a production-ready credit-risk system.
