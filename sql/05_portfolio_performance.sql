-- ====================================================================================================================================================================================
-- 05 PORTFOLIO PERFORMANCE
-- ====================================================================================================================================================================================


-- ========================================================================================================================
-- QUESTION 1:HOW DOES REALIZED PAYMENT COMPARE WITH ORIGINAL LOAN EXPOSURE ACROSS PORTFOLIO LOAN STATUSES?
-- ========================================================================================================================

-- Purpose:
-- Compare the original amount lent with total paymentsreceived across different loan-status categories.
-- The payment realization ratio shows how much has been received for every $1 of original loan exposure.


SELECT
    loan_status,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS original_loan_exposure,
    SUM(total_payment) AS realized_payment,
    ROUND(
        SUM(total_payment) * 100.0 /
        SUM(loan_amount),
        2
    ) AS payment_realization_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(total_payment), 2) AS average_realized_payment
FROM loans
GROUP BY loan_status
ORDER BY original_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Fully Paid loans: 32,145 loans with $351,358,350 in original exposure generated $411,586,256 in realized payments, representing a payment realization rate of 117.14%. The average loan amount was $10,930.42, while  the average realized payment was $12,804.05.
--
-- Charged Off loans: 5,333 loans with $65,532,225 in original exposure generated $37,284,763 in realized payments, representing a payment realization rate of 56.90%. The average loan amount was $12,288.06, while the average realized payment was $6,991.33.
--
-- Current loans: 1,098 loans with $18,866,500 in original exposure generated $24,199,914 in realized payments to date, representing a payment realization rate of 128.27%. The average loan amount was $17,182.60, while the averagerealized payment was $22,039.99.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Payment realization varies substantially across loan statuses. Fully Paid loans generated payments equivalent to 117.14% of their original exposure, while Charged Off loans realized only 56.90%.
--
-- The Charged Off segment therefore shows a significant gap between the amount originally lent and the amount realized. This is particularly important given that the segment represents $65.53 million in original loan exposure.
--
-- Current loans have the highest payment realization rate at 128.27%. However, these loans are still active, so this represents payments realized to date rather than a final performance outcome.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Portfolio performance should be monitored by both loan status and original exposure, rather than by loan counts alone.
--
-- The 56.90% payment realization rate for Charged Off loans highlights a substantial recovery gap and indicates that this segment warrants closer monitoring from a portfolio recovery and collections perspective.
--
-- Fully Paid loans demonstrate stronger payment realization, while Current loans should continue to be monitored because their payment realization is not yet a final outcome.





-- ========================================================================================================================
-- QUESTION 2: HOW DOES PAYMENT REALIZATION VARY ACROSS CREDIT-GRADE SEGMENTS?
-- ========================================================================================================================

-- Purpose:
-- Compare original loan exposure with realized payments across credit grades to assess differences in payment realization.


SELECT
    grade,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS original_loan_exposure,
    SUM(total_payment) AS realized_payment,
    ROUND(
        SUM(total_payment) * 100.0 /
        SUM(loan_amount),
        2
    ) AS payment_realization_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(total_payment), 2) AS average_realized_payment
FROM loans
GROUP BY grade
ORDER BY
    CASE grade
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
        WHEN 'D' THEN 4
        WHEN 'E' THEN 5
        WHEN 'F' THEN 6
        WHEN 'G' THEN 7
    END;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Grade A: 9,689 loans with $84,252,225 in original exposure generated $88,051,563 in realized payments, representing a 104.51% payment realization rate.
--
-- Grade B: 11,674 loans with $130,703,975 in original exposure generated $140,775,015 in realized payments, representing a 107.71% payment realization rate.
--
-- Grade C: 7,904 loans with $87,456,450 in original exposure generated $95,973,518 in realized payments, representing a 109.74% payment realization rate.
--
-- Grade D: 5,182 loans with $63,920,800 in original exposure generated $70,823,891 in realized payments, representing a 110.80% payment realization rate.
--
-- Grade E: 2,786 loans with $44,165,100 in original exposure generated $49,164,151 in realized payments, representing a 111.32% payment realization rate.
--
-- Grade F: 1,028 loans with $18,910,450 in original exposure generated $21,016,738 in realized payments, representing a 111.14% payment realization rate.
--
-- Grade G: 313 loans with $6,348,075 in original exposure generated $7,266,057 in realized payments, representing the highest payment realization rate at 114.46%.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================
-- Payment realization generally increases across the credit grades, rising from 104.51% for Grade A to 114.46% for Grade G.
--
-- However, the higher realization rates in lower grades do not necessarily indicate better overall credit performance. Payment realization measures payments received relative to original loan exposure and does not by itself account for
-- factors such as payment timing, loan maturity, or credit losses.
--
-- Grades A-C represent a substantially larger share of portfolio exposure than Grades E-G. Their combined original exposure is approximately $302.41 million, compared with approximately $69.42 million for Grades E-G.


-- ========================================================================================================================
-- Business Implication:
-- ========================================================================================================================

-- Payment realization should be assessed alongside credit grade, exposure size, loan status, and other portfolio performance measures rather than used as a standalone indicator of credit quality.
--
-- The large exposure concentrated in Grades B and C makes these segments particularly important for portfolio monitoring, even though their payment realization rates are not the highest.
--
-- Differences in payment realization across grades can also be investigated alongside loan terms, interest rates, and other portfolio characteristics to better understand the drivers of realized payments.





-- ========================================================================================================================
-- QUESTION 3: HOW DOES PAYMENT REALIZATION VARY ACROSS LOAN TERMS?
-- ========================================================================================================================

-- Purpose:
-- Compare original loan exposure with realized payments across different loan terms to assess differences in payment realization.


SELECT
    term_months,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS original_loan_exposure,
    SUM(total_payment) AS realized_payment,
    ROUND(
        SUM(total_payment) * 100.0 /
        SUM(loan_amount),
        2
    ) AS payment_realization_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(total_payment), 2) AS average_realized_payment
FROM loans
GROUP BY term_months
ORDER BY term_months;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- 36-month loans: 28,237 loans with $273,041,225 in original exposure generated $294,709,458 in realized payments, representing a payment realization rate of 107.94%. The average loan amount was $9,669.63, while the average realized payment was $10,437.00.
--
-- 60-month loans: 10,339 loans with $162,715,850 in original exposure generated $178,361,475 in realized payments, representing a payment realization rate of 109.62%. The average loan amount was $15,738.06, while the average realized payment was $17,251.33.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- 36-month loans account for the majority of lending activity, with 28,237 loans and $273.04 million in original exposure. Their payment realization rate is 107.94%.
--
-- 60-month loans have a slightly higher payment realization rate of 109.62%, despite representing a smaller number of loans. They also have substantially larger average loan amounts, at $15,738.06 compared with $9,669.63 for 36-month loans.
--
-- The results therefore show that longer-term loans generate higher realized payments relative to original exposure in this portfolio, while also carrying substantially larger average loan amounts.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Loan term should be considered when evaluating portfolio performance because longer-term loans carry larger average exposures and show a different payment realization profile.
--
-- The 60-month segment warrants particular monitoring because its average loan amount is approximately 63% higher than that of 36-month loans, creating greater exposure per loan.
--
-- Payment realization should nevertheless be assessed alongside loan status and other performance measures, since realized payment alone does not capture the complete risk or profitability profile of a loan.





-- ========================================================================================================================
-- QUESTION 4: WHICH LOAN PURPOSES GENERATE THE GREATEST REALIZED PAYMENT AMOUNT RELATIVE TO THEIR ORIGINAL EXPOSURE?
-- ========================================================================================================================

-- Purpose:
-- Compare original loan exposure with realized payments across loan purposes to assess differences in payment realization.


SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS original_loan_exposure,
    SUM(total_payment) AS realized_payment,
    ROUND(
        SUM(total_payment) * 100.0 /
        SUM(loan_amount),
        2
    ) AS payment_realization_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(total_payment), 2) AS average_realized_payment
FROM loans
GROUP BY purpose
ORDER BY payment_realization_pct DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================
-- Wedding loans recorded the highest payment realization rate at 111.28%, with 928 loans generating $10,266,856 in realized payments from $9,225,800 in original exposure.
--
-- Car loans followed at 110.77%, with 1,497 loans generating $11,324,914 from $10,223,575 in original exposure.
--
-- Credit card loans recorded 110.75% realization, generating $65,214,084 from $58,885,175 in original exposure across 4,998 loans.
--
-- Debt consolidation, the largest lending purpose by exposure, recorded a 109.18% payment realization rate. Its 18,214 loans generated $253,801,871 in realized payments from $232,459,675 in original exposure.
--
-- Small business loans recorded the lowest payment realization rate at 98.72%, with $23,814,817 in realized payments against $24,123,100 in original exposure.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================
-- Payment realization varies across loan purposes, ranging from 98.72% for small business loans to 111.28% for wedding loans.
--
-- Most loan purposes recorded realized payments above their original exposure, while small business was the only purpose with a realization rate below 100%.
--
-- Debt consolidation is particularly significant because, despite not having the highest realization rate, it represents the largest lending purpose and generated $253.80 million in realized payments from $232.46 million in original exposure.
--
-- The results therefore show that payment realization should be considered alongside the size of the underlying exposure, rather than focusing only on the highest realization rates.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Portfolio performance monitoring should consider both payment realization and the scale of exposure associated with each loan purpose.
--
-- The relatively low 98.72% realization rate for small business loans warrants further investigation because realized payments remain below the original exposure.
--
-- Debt consolidation also deserves close monitoring because of its substantial portfolio exposure, even though its payment realization rate is relatively strong.
--
-- Comparing payment realization across purposes can help identify segments that may require deeper analysis of loan terms, borrower characteristics, and repayment performance.





-- ========================================================================================================================
-- QUESTION 5: HOW DOES SCHEDULED MONTHLY PAYMENT BURDEN VARY ACROSS BORROWER RISK SEGMENTS?
-- ========================================================================================================================

-- Purpose:
-- Compare scheduled monthly installments with borrower income across credit grades to assess differences in payment burden.


SELECT
    grade,
    COUNT(*) AS total_loans,
    ROUND(AVG(installment), 2) AS average_monthly_installment,
    ROUND(AVG(annual_income), 2) AS average_annual_income,
    ROUND(
        AVG(
            installment / (annual_income / 12.0)
        ) * 100,
        2
    ) AS average_payment_burden_pct,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY grade
ORDER BY
    CASE grade
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
        WHEN 'D' THEN 4
        WHEN 'E' THEN 5
        WHEN 'F' THEN 6
        WHEN 'G' THEN 7
    END;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================
-- Grade A: 9,689 loans with an average monthly installment of $258.85 and average annual income of $67,533.99. The average payment burden was 5.51%, with an average loan amount of $8,695.66.
--
-- Grade B: 11,674 loans with an average monthly installment of $323.51 and average annual income of $68,320.58. The average payment burden was 6.61%, with an average loan amount of $11,196.16.
--
-- Grade C: 7,904 loans with an average monthly installment of $321.53 and average annual income of $68,482.66. The average payment burden was 6.68%, with an average loan amount of $11,064.83.
--
-- Grade D: 5,182 loans with an average monthly installment of $365.61 and average annual income of $69,092.81. The average payment burden was 7.23%, with an average loan amount of $12,335.16.
--
-- Grade E: 2,786 loans with an average monthly installment of $428.80 and average annual income of $78,328.38. The average payment burden was 7.57%, with an average loan amount of $15,852.51.
--
-- Grade F: 1,028 loans with an average monthly installment of $499.37 and average annual income of $85,115.68. The average payment burden was 8.00%, with an average loan amount of $18,395.38.
--
-- Grade G: 313 loans with an average monthly installment of $576.42 and average annual income of $94,724.94. The average payment burden was 8.61%, with an average loan amount of $20,281.39.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================
-- Average payment burden generally increases as credit grade moves from A to G, rising from 5.51% for Grade A to 8.61% for Grade G.
--
-- Average monthly installments also increase from $258.85 in Grade A to $576.42 in Grade G, while average loan amounts increase from $8,695.66 to $20,281.39.
--
-- Although average annual income also increases across the higher grades, the increase in scheduled payment obligations is greater relative to income, resulting in a higher average payment burden.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Scheduled payment burden provides an additional dimension for monitoring borrower affordability across credit segments.
--
-- The higher payment burden observed in Grades E-G, combined with substantially larger average loan amounts, suggests that these segments may warrant closer monitoring of borrower payment capacity.
--
-- Payment burden should be considered alongside other credit and portfolio characteristics rather than treated as a standalone measure of borrower risk.





-- ========================================================================================================================
-- QUESTION 6: HOW DOES BORROWER CREDIT-HISTORY DEPTH RELATE TO THE AMOUNT OF LOAN EXPOSURE?
-- ========================================================================================================================

-- Purpose:
-- To examine whether borrowers with deeper credit histories tend to receive larger loans and account for greater portfolio exposure.


SELECT
    CASE
        WHEN total_acc BETWEEN 0 AND 5 THEN '0-5'
        WHEN total_acc BETWEEN 6 AND 10 THEN '6-10'
        WHEN total_acc BETWEEN 11 AND 20 THEN '11-20'
        WHEN total_acc BETWEEN 21 AND 30 THEN '21-30'
        WHEN total_acc BETWEEN 31 AND 40 THEN '31-40'
        ELSE '41+'
    END AS credit_history_band,

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

    ROUND(AVG(loan_amount), 2) AS average_loan_amount,

    ROUND(AVG(total_acc), 2) AS average_total_accounts

FROM loans

GROUP BY credit_history_band

ORDER BY
    CASE credit_history_band
        WHEN '0-5' THEN 1
        WHEN '6-10' THEN 2
        WHEN '11-20' THEN 3
        WHEN '21-30' THEN 4
        WHEN '31-40' THEN 5
        WHEN '41+' THEN 6
    END;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- 0-5 accounts: 1,108 loans with an average loan amount of $6,098.56 and an average of 4.32 total accounts. This segment represented 2.87% of loan volume and $6.76 million in exposure, representing 1.55% of total portfolio exposure.
--
--6-10 accounts: 4,610 loans with an average loan amount of $8,058.70 and an average of 8.26 total accounts. This segment represented 11.95% of loan volume and $37.15 million in exposure, representing 8.53% of total portfolio exposure.
--
-- 11-20 accounts: 13,610 loans with an average loan amount of $10,451.05 and an average of 15.57 total accounts. This segment represented 35.28% of loan volume and $142.24 million in exposure, representing 32.64% of total portfolio exposure.
--
-- 21-30 accounts: 10,997 loans with an average loan amount of $12,316.30 and an average of 25.08 total accounts. This segment represented 28.51% of loan volume and $135.44 million in exposure, representing 31.08% of total portfolio exposure.
--
-- 31-40 accounts: 5,538 loans with an average loan amount of $13,720.87 and an average of 34.77 total accounts. This segment represented 14.36% of loan volume and $75.99 million in exposure, representing 17.44% of total portfolio exposure.
--
-- 41+ accounts: 2,713 loans with an average loan amount of $14,073.72 and an average of 48.12 total accounts. This segment represented 7.03% of loan volume and $38.18 million in exposure, representing 8.76% of total portfolio exposure.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Average loan size generally increases as credit-history depth increases, rising from $6,098.56 for borrowers with 0-5 accounts to $14,073.72 for borrowers with 41+ accounts.
--
-- Borrowers with 11-20 accounts represent the largest segment, accounting for 35.28% of loan volume and 32.64% of total exposure.
-- 
-- The 21-30 account segment is the second largest, representing 28.51% of loan volume and 31.08% of total exposure.
--
--Borrowers with 21+ accounts account for 19,248 loans, or 49.90% of total loan volume, but represent approximately 57.28% of total portfolio exposure, indicating that deeper credit-history segments carry disproportionately larger loan exposures.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- Credit-history depth provides an additional dimension for portfolio segmentation and exposure monitoring.
--
-- Borrowers with deeper credit histories tend to receive larger loans, resulting in higher average exposure within these segments The 21+ account segments therefore warrant attention when assessing portfolio exposure and lending concentration.
--
-- Credit-history depth should be considered alongside other borrower and loan characteristics rather than treated as a standalone indicator of credit quality or risk.

