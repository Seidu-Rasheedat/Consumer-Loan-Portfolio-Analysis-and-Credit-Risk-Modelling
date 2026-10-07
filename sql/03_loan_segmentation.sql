-- ====================================================================================================================================================================================
-- 03 LOAN SEGMENTATION
-- ====================================================================================================================================================================================


-- ========================================================================================================================
-- BUSINESS QUESTION 1: HOW IS LENDING ACTIVITY DISTRIBUTED ACROSS BORROWER HOME-OWNERSHIP SEGMENTS?
-- ========================================================================================================================

-- Purpose:
-- Examine how the loan portfolio is distributed across borrower home-ownership categories.
--
-- This analysis compares the number of loans, share of portfolio volume, total original loan exposure, and average loan amount across home-ownership segments.
--
-- Understanding these differences helps identify which borrower groups account for the greatest lending activity and financial exposure within the portfolio.


SELECT
    home_ownership,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY home_ownership
ORDER BY total_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- The MORTGAGE segment contains 17,198 loans, representing 44.58% of the portfolio, with $219,329,150 in original loan exposure. The average loan amount is $12,753.18.
--
-- The RENT segment contains 18,439 loans, representing 47.80% of the portfolio, with $185,768,475 in original loan exposure.
-- The average loan amount is $10,074.76.
--
-- The OWN segment contains 2,838 loans, representing 7.36% of the portfolio, with $29,597,675 in original loan exposure. The average loan amount is $10,429.06.
--
-- The OTHER segment contains 98 loans, representing 0.25% of the portfolio, with $1,044,975 in original loan exposure.
-- The average loan amount is $10,663.01.
--
-- The NONE segment contains 3 loans, representing 0.01% of the portfolio, with $16,800 in original loan exposure.
-- The average loan amount is $5,600.00.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- RENT is the largest segment by loan volume, with 18,439 loans representing 47.80% of the portfolio. However, MORTGAGE borrowers account for the largest share of original loan exposure, with $219,329,150 representing 50.33% of total portfolio exposure.
--
-- The difference is driven partly by loan size. MORTGAGE loans have an average loan amount of $12,753.18, compared with $10,074.76 for RENT borrowers.
--
-- This means that although RENT borrowers account for a larger number of loans, MORTGAGE borrowers represent substantially greater financial exposure.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The distinction between loan volume and financial exposure is important for portfolio monitoring. RENT borrowers account for 47.80% of loans, making them the largest borrower segment by account volume, while MORTGAGE borrowers account for 50.33% of total original exposure.
--
-- The higher average loan amount among MORTGAGE borrowers, at $12,753.18 compared with $10,074.76 for RENT borrowers, means that changes affecting the MORTGAGE segment could have a larger financial impact than its loan count alone suggests.
--
-- Portfolio monitoring should therefore evaluate borrower segments using both account concentration and financial exposure rather than relying on loan volume alone.


-- ========================================================================================================================
-- BUSINESS QUESTION 2: HOW DOES LOAN PURPOSE VARY ACROSS DIFFERENT LOAN TERMS?
-- ========================================================================================================================

-- Purpose:
-- Examine how loan purposes are distributed across the different repayment terms in the portfolio.
--
-- This analysis compares loan volume and original loan exposure for each combination of loan purpose and term. It helps identify whether particular lending purposes are more concentrated in shorter- or longer-term loans.


SELECT
    purpose,
    term_months,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY purpose, term_months
ORDER BY purpose, term_months;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Debt consolidation is the largest purpose across both terms. It accounts for 12,823 36-month loans with $139,683,775 in original exposure and 5,391 60-month loans with $92,775,900 in original exposure.
--
-- Credit card lending is the second-largest purpose, with 3,982 36-month loans and 1,016 60-month loans. These represent $41,762,725 and $17,122,450 in original exposure respectively.
--
-- Home improvement has 2,009 36-month loans and 867 60-month loans, with original exposures of $19,071,075 and $14,279,700.
--
-- Small business lending has 1,203 36-month loans and 573 60-month loans, representing $13,941,925 and $10,181,175 in original exposure respectively.
--
-- Across most purposes, 36-month loans have substantially higher loan volumes than 60-month loans. This is particularly visible for debt consolidation, where the 36-month segment contains 12,823 loans compared with 5,391 for 60-month loans.
--
-- However, 60-month loans consistently have higher average loan amounts than their 36-month counterparts. For example, the average debt consolidation loan rises from $10,893.22 for 36-month loans to $17,209.40 for 60-month loans.
--
-- The same pattern appears in credit card lending, where the average loan increases from $10,487.88 for 36-month loans to $16,852.81 for 60-month loans.
--
-- Small business loans show a similar difference, increasing from an average of $11,589.30 for 36-month loans to $17,768.19 for 60-month loans.
--
-- The pattern is also present among smaller purposes. For example, wedding loans increase from an average of $8,919.59 for 36-month loans to $13,310.42 for 60-month loans, while moving loans increase from $5,793.53 to $10,940.40.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Loan purpose and loan term are not evenly distributed across the portfolio. 36-month lending dominates loan volume across virtually every purpose, but 60-month lending is associated with substantially larger average loan sizes.
--
-- Debt consolidation demonstrates the greatest concentration. Its 36-month segment contains 12,823 loans and 139,683,775 in exposure, while its 60-month segment contains 5,391 loans and 92,775,900 in exposure.
--
-- Although the 60-month debt consolidation segment contains considerably fewer loans, its average loan amount is 17,209.40 compared with 10,893.22 for 36-month loans.
--
-- The same relationship appears in small business lending: 60-month loans have an average size of 17,768.19 compared with 11,589.30 for 36-month loans.
--
-- This indicates that longer-term lending is generally used for larger individual loan amounts, even when the number of 60-month loans is much smaller.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Portfolio monitoring should consider both loan term and borrowing purpose when assessing lending exposure.
--
-- Debt consolidation is particularly important because it is the largest purpose across both terms, with combined original exposure of $232,459,675 across 18,214 loans.
--
-- The 60-month segment deserves particular attention because longer-term loans generally carry larger individual exposures. For example, the average debt consolidation loan is $17,209.40 for 60-month lending compared with $10,893.22 for 36-month lending.
--
-- Similarly, 60-month small business loans average $17,768.19, compared with $11,589.30 for 36-month loans.
--
-- From a portfolio management perspective, this means that loan counts alone can understate the importance of longer-term lending. A smaller number of 60-month loans can still represent substantial financial exposure because of their larger average loan sizes.





-- ========================================================================================================================
-- BUSINESS QUESTION 3: WHICH BORROWER INCOME SEGMENTS ACCOUNT FOR THE GREATEST LOAN EXPOSURE?
-- ========================================================================================================================

-- Purpose:
-- Examine how original loan exposure is distributed across different borrower annual-income segments.
--
-- Income bands make it easier to compare portfolio exposure across broad borrower segments rather than individual income values.
--
-- The analysis compares loan volume, portfolio volume share, original loan exposure, exposure share, and average loan size.


SELECT
    CASE
        WHEN annual_income < 30000 THEN 'Below 30k'
        WHEN annual_income < 50000 THEN '30k-50k'
        WHEN annual_income < 75000 THEN '50k-75k'
        WHEN annual_income < 100000 THEN '75k-100k'
        WHEN annual_income < 150000 THEN '100k-150k'
        ELSE '150k+'
    END AS income_band,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY income_band
ORDER BY total_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- The 50k-75k income segment has the largest number of loans, with 12,020 loans representing 31.16% of the portfolio. It also has the greatest original loan exposure at $135,821,850, representing 31.17% of total portfolio exposure. Its average loan amount is $11,299.65.
--
-- The 30k-50k segment contains 10,499 loans, representing 27.22% of the portfolio, with $90,924,400 in original exposure. This represents 20.87% of total exposure, with an average loan amount of $8,660.29.
--
-- The 75k-100k segment contains 6,477 loans, representing 16.79% of the portfolio, with $89,106,150 in original exposure. It accounts for 20.45% of total exposure and has an average loan amount of $13,757.32.
--
-- The 100k-150k segment contains 4,372 loans, representing 11.33% of the portfolio, with $68,282,050 in original exposure. This represents 15.67% of total exposure, with an average loan amount of $15,618.04.
--
-- The 150k+ segment contains 1,773 loans, representing 4.60% of the portfolio, with $32,880,050 in original exposure. Despite its relatively small loan volume, it represents 7.55% of total exposure and has the highest average loan amount at $18,544.87.
--
-- The Below 30k segment contains 3,435 loans, representing 8.90% of the portfolio, with $18,742,575 in original exposure. This represents 4.30% of total exposure, with an average loan amount of $5,456.35.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- The 50k-75k income segment represents the largest concentration of both loan volume and original exposure, with 12,020 loans and $135,821,850 in exposure.
--
-- However, the distribution of exposure becomes increasingly different from loan volume as borrower income rises.
--
-- The 150k+ segment accounts for only 4.60% of loan volume but represents 7.55% of total exposure. Its average loan amount of $18,544.87 is more than three times the $5,456.35 average for borrowers earning below 30k.
--
-- The 75k-100k segment also demonstrates this difference. It represents 16.79% of loan volume but 20.45% of total exposure, with an average loan amount of $13,757.32.
--
-- Overall, higher-income segments tend to have larger individual loan sizes, meaning loan volume alone does not fully represent their importance to portfolio exposure.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Portfolio monitoring should evaluate borrower income segments using both loan volume and financial exposure.
--
-- The 50k-75k segment should receive particular attention because it represents the largest concentration of the portfolio, accounting for $135,821,850 in original exposure and 31.17% of total exposure.
--
-- Higher-income segments also warrant attention despite having fewer loans. The 75k-100k, 100k-150k, and 150k+ segments collectively represent 11,991 loans, or approximately 31.1% of the portfolio by loan count, but account for approximately 43.7% of total original exposure.
--
-- This difference shows why portfolio monitoring based only on borrower or loan counts can understate financial concentration. Exposure-based segmentation provides a clearer view of where larger amounts of capital are committed.





-- ========================================================================================================================
-- BUSINESS QUESTION 4: HOW IS LENDING ACTIVITY DISTRIBUTED ACROSS GEOGRAPHIC MARKETS?
-- ========================================================================================================================

-- Purpose:
-- Examine how the loan portfolio is distributed across geographic markets using borrower state.
--
-- The analysis compares loan volume, portfolio volume share, original loan exposure, exposure share, and average loan size.
--
-- This helps identify markets with high lending activity and markets that represent significant financial exposure.


SELECT
    address_state,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY address_state
ORDER BY total_loan_exposure DESC;


-- ============================================================
-- RESULT
-- ============================================================

-- California (CA) is the largest geographic market, with 6,894 loans representing 17.87% of the portfolio and $78,484,125 in original loan exposure, representing 18.01% of total exposure. Its average loan amount is $11,384.41.
--
-- New York (NY) is the second-largest market, with 3,701 loans representing 9.59% of the portfolio and $42,077,050 in original exposure, representing 9.66% of total exposure. The average loan amount is $11,369.10.
--
-- Texas (TX) accounts for 2,664 loans, or 6.91% of the portfolio, with $31,236,650 in original exposure, representing 7.17% of total exposure. Its average loan amount is $11,725.47.
--
-- Florida (FL) has 2,773 loans, representing 7.19% of the portfolio, with $30,046,125 in original exposure and 6.90% of total exposure. Its average loan amount is $10,835.24.
--
-- New Jersey (NJ) has 1,822 loans, representing 4.72% of the portfolio, with $21,657,475 in original exposure and 4.97% of total exposure. Its average loan amount is $11,886.65.
--
-- The remaining markets each represent less than 4% of total portfolio exposure individually, with Illinois (3.93%), Virginia (3.67%), Pennsylvania (3.63%), Georgia (3.55%), and Massachusetts (3.45%) among the larger markets.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Geographic lending is concentrated in a relatively small number of markets.
--
-- California alone accounts for 17.87% of loan volume and 18.01% of original exposure, making it the largest geographic concentration in the portfolio.
--
-- New York contributes another 9.59% of loan volume and 9.66% of exposure. Together, California and New York account for 10,595 loans, representing 27.46% of the portfolio, and $120,561,175 in original exposure, representing 27.67% of total exposure.
--
-- Texas and Florida are the next two largest markets by exposure, accounting for $31,236,650 and $30,046,125 respectively. Together, the four largest markets (California, New York, Texas, and Florida) account for $181,843,950 in original exposure, representing approximately 41.74% of total portfolio exposure.
--
-- The relatively close relationship between loan volume share and exposure share across the largest markets suggests that geographic concentration is driven primarily by lending activity rather than major differences in average loan size.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Geographic concentration should be incorporated into portfolio monitoring because changes in major lending markets can affect a meaningful portion of total portfolio exposure.
--
-- California, New York, Texas, and Florida are particularly important markets because they collectively represent approximately 41.74% of total original exposure.
--
-- California and New York alone account for 27.67% of total exposure, making them the most significant geographic concentration in the portfolio.
--
-- Monitoring these major markets separately can help identify changes in lending activity or portfolio composition that may not be visible when the portfolio is viewed only at an aggregate level.
--
-- The comparison between loan volume and exposure is also useful: California represents 17.87% of loan volume and 18.01% of exposure, while Florida represents 7.19% of loan volume and 6.90% of exposure. This demonstrates why geographic concentration should be assessed using both measures.





-- ========================================================================================================================
-- BUSINESS QUESTION 5: HOW DOES LOAN VERIFICATION STATUS VARY ACROSS THE PORTFOLIO?
-- ========================================================================================================================

-- Purpose:
-- Examine how lending activity and original loan exposure are distributed across borrower income-verification categories.
--
-- The analysis compares loan volume, portfolio volume share, original loan exposure, exposure share, and average loan size.
--
-- This helps assess whether verified and non-verified lending represent different levels of portfolio exposure.


SELECT
    verification_status,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(
        SUM(loan_amount) * 100.0 /
        (SELECT SUM(loan_amount) FROM loans),
        2
    ) AS exposure_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY verification_status
ORDER BY total_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- The Not Verified category contains the largest number of loans, with 16,464 loans representing 42.68% of the portfolio. These loans account for $139,697,450 in original exposure, representing 32.06% of total exposure. The average loan amount is $8,485.02.
--
-- The Verified category contains 12,335 loans, representing 31.98% of the portfolio. However, it accounts for the largest original loan exposure at $196,962,050, representing 45.20% of total exposure. The average loan amount is $15,967.74.
--
-- The Source Verified category contains 9,777 loans, representing 25.34% of the portfolio, with $99,097,575 in original exposure. This represents 22.74% of total exposure, with an average loan amount of $10,135.79.
--
-- The results therefore show a clear difference between loan volume and financial exposure across verification categories.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Not Verified is the largest category by loan volume, with 16,464 loans representing 42.68% of the portfolio. However, Verified loans represent the largest concentration of financial exposure despite accounting for only 31.98% of loan volume.
--
-- Verified loans account for $196,962,050 in original exposure, representing 45.20% of total portfolio exposure. Their average loan amount of $15,967.74 is substantially higher than the $8,485.02 average for Not Verified loans.
--
-- Source Verified loans account for 22.74% of total exposure and have an average loan amount of $10,135.79.
--
-- The Verified and Source Verified categories together account for 22,112 loans, representing 57.32% of the portfolio by loan volume, but account for $296,059,625 in original exposure, representing 67.94% of total exposure.
--
-- This shows that verified lending represents a disproportionately large share of financial exposure relative to its loan volume.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Verification status should be considered alongside exposure when monitoring the portfolio.
--
-- The Verified segment deserves particular attention because it represents 45.20% of total original exposure despite accounting for only 31.98% of loans. Its average loan amount of $15,967.74 is almost twice the $8,485.02 average for Not Verified loans.
--
-- The combined Verified and Source Verified categories represent 67.94% of total portfolio exposure, meaning that lending with some form of income verification accounts for a substantial majority of the capital originated.
--
-- This distinction between loan volume and financial exposure reinforces the importance of using exposure-based measures in portfolio monitoring. A segment with fewer loans can still represent greater financial significance when its average loan size is substantially larger.
