-- ====================================================================================================================================================================================
-- 01 PORTFOLIO OVERVIEW
-- ====================================================================================================================================================================================


-- ========================================================================================================================
-- BUSINESS QUESTION 1: HOW LARGE IS THE LOAN PORTFOLIO?
-- ========================================================================================================================

-- Purpose:
-- Establish the overall scale of the portfolio by measuring the number of loans, total original loan exposure, and average loan amount.


SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_exposure,
    AVG(loan_amount) AS average_loan_amount
FROM loans;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Total loans: 38,576
-- Total original loan exposure: $435,757,075
-- Average loan amount: $11,296.07


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- The portfolio contains 38,576 loans with total original loan exposure of $435.76 million and an average loan amount of $11,296.07.
-- 
-- The $435.76 million in total exposure is distributed across 38,576 individual loans, indicating that portfolio exposure is generated across a broad lending base rather than being represented only by a small number of individual loans.
 

-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The portfolio's $435.76 million in original exposure means that understanding where this exposure is concentrated is important for portfolio management.
--
-- Subsequent analysis should therefore examine both the number of loans and total loan exposure across purposes, grades, borrower segments, and geographic markets. A segment with a large number of loans may not necessarily represent the largest financial exposure, while a smaller segment with larger loans may account for a substantial share of the portfolio's value.
--
-- Using both measures will allow portfolio segments to be evaluated based on their actual contribution to lending activity and financial exposure, rather than relying on loan counts alone.





-- ========================================================================================================================
-- BUSINESS QUESTION 2: HOW IS LENDING ACTIVITY DISTRIBUTED ACROSS LOAN PURPOSES?
-- ========================================================================================================================

-- Purpose:
-- Examine how loan volume and original loan exposure are distributed across different borrowing purposes.
--
-- This analysis compares the number of loans, percentage of total loans, total original exposure, and average loan amount for each loan purpose.


SELECT
    purpose,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY purpose
ORDER BY total_loan_exposure DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- The portfolio contains 14 distinct loan purposes.
--
-- Debt consolidation is the largest purpose by both loan volume and original loan exposure, with 18,214 loans, representing 47.22% of all loans and $232,459,675 in original exposure.
--
-- Credit card is the second-largest purpose by loan volume, with 4,998 loans (12.96%) and $58,885,175 in exposure.
--
-- Home improvement accounts for 2,876 loans (7.46%) and $33,350,775 in exposure.
--
-- The "other" category contains 3,824 loans (9.91%) but accounts for $31,155,750 in exposure.
--
-- Small business represents 1,776 loans (4.60%) but contributes $24,123,100 in exposure.
--
-- The remaining purposes each account for less than 6% of total loan volume individually.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Debt consolidation is the dominant segment of the portfolio,accounting for 18,214 loans, or 47.22% of total loan volume. Its $232,459,675 in original exposure represents approximately 53.35% of the portfolio's total $435,757,075 exposure.
--
-- This means debt consolidation contributes a larger share of financial exposure than its share of loan volume, indicating that its average loan size is relatively high at $12,762.69.
--
-- The difference between loan volume and exposure is also visible in smaller segments. Small business accounts for only 4.60% of loan volume but contributes $24,123,100 in exposure, with an average loan amount of $13,582.83. Similarly, the house purpose represents just 0.95% of loans but has an average loan amount of $13,182.86.
--
-- In contrast, the "other" category represents 9.91% of loan volume but only about 7.15% of total exposure, reflecting its comparatively lower average loan amount of $8,147.42.
--
-- Overall, the results show that loan volume alone does not fully describe portfolio exposure. The purpose segments with the largest number of loans are not always those with the highest average loan sizes.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The concentration of 53.35% of total original exposure in debt consolidation makes this the most financially significant lending purpose in the portfolio. Changes in the composition, performance, or lending strategy associated with this segment could therefore have a material effect on the overall portfolio.
--
-- The results also show why portfolio monitoring should consider both loan count and monetary exposure. Small business represents only 4.60% of loan volume but contributes $24,123,100 in exposure, while house loans account for just 0.95% of volume but have an average loan amount of $13,182.86.
--
-- This suggests that portfolio decisions based only on the number of loans could underestimate the financial importance of smaller segments with larger average loan sizes. Monitoring should therefore combine activity volume, total exposure, and average loan size when assessing the significance of each lending purpose.





-- ========================================================================================================================
-- BUSINESS QUESTION 3: HOW IS THE PORTFOLIO DISTRIBUTED ACROSS LOAN TERMS?
-- ========================================================================================================================

-- Purpose:
-- Examine how lending activity and original loan exposure are distributed across the different repayment terms in the portfolio.
--
-- This analysis compares the number of loans, percentage of total loans, total original exposure, and average loan amount for each loan term.


SELECT
    term_months,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY term_months
ORDER BY term_months;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- 36-month loans account for 28,237 loans, representing 73.20% of the portfolio by loan volume. They contribute $273,041,225 in original loan exposure, with an average loan amount of $9,669.63.
--
-- 60-month loans account for 10,339 loans, representing 26.80% of the portfolio by loan volume. Despite having fewer loans, they contribute $162,715,850 in original loan exposure, with an average loan amount of $15,738.06.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- The portfolio is predominantly composed of 36-month loans, which account for 73.20% of all loans. However, their share of total original exposure is approximately 62.66%, meaning their exposure share is lower than their share of loan volume.
--
-- In contrast, 60-month loans represent only 26.80% of loan volume but account for approximately 37.34% of total original exposure.
--
-- The difference is explained by the substantially larger average loan size for 60-month loans. At $15,738.06, the average 60-month loan is approximately 62.8% larger than the average 36-month loan of $9,669.63.
--
-- Therefore, while 36-month loans dominate the portfolio by number of loans, 60-month loans represent a disproportionately large share of financial exposure relative to their volume.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The 60-month segment deserves particular attention from a portfolio management perspective because 26.80% of loans account for 37.34% of total original exposure.
--
-- This means that changes affecting the 60-month segment could have a larger financial impact than its loan volume alone would suggest.
--
-- The difference in average loan size also shows why monitoring portfolio composition using loan counts alone can be misleading. Although 36-month loans are the dominant product by volume, the larger average size of 60-month loans results in a much greater concentration of exposure within that smaller segment.
--
-- Portfolio monitoring should therefore track both loan volume and financial exposure when assessing the significance of different repayment terms.





-- ========================================================================================================================
-- BUSINESS QUESTION 4: WHAT IS THE COMPOSITION OF THE PORTFOLIO BY LOAN STATUS?
-- ========================================================================================================================

-- Purpose:
-- Examine how the portfolio is distributed across its different loan status categories.
--
-- This analysis compares the number of loans and percentage of total portfolio volume represented by each loan status. It also measures the original loan exposure associated with each status.


SELECT
    loan_status,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY loan_status
ORDER BY total_loans DESC;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Fully Paid loans account for 32,145 loans, representing 83.33% of the portfolio by loan volume. They contribute $351,358,350 in original loan exposure, with an average loan amount of $10,930.42.
--
-- Charged Off loans account for 5,333 loans, representing 13.82% of the portfolio by loan volume. They contribute $65,532,225 in original loan exposure, with an average loan amount of $12,288.06.
--
-- Current loans account for 1,098 loans, representing 2.85% of the portfolio by loan volume. They contribute $18,866,500 in original loan exposure and have the highest average loan amount at $17,182.60.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Fully Paid loans dominate the portfolio, representing 83.33% of all loans and approximately 80.63% of total original loan exposure.
--
-- Charged Off loans represent 13.82% of loan volume but approximately 15.04% of total original exposure. Their average loan amount of $12,288.06 is approximately 12.4% higher than the $10,930.42 average for Fully Paid loans.
--
-- Current loans are a much smaller segment by volume at 2.85%, but they account for approximately 4.33% of total original exposure. Their average loan amount of $17,182.60 is the highest across all three status categories and is
-- approximately 57.2% higher than the portfolio average of $11,296.07.
--
-- Overall, the results show that loan status categories differ not only in their share of portfolio volume but also in the size of the loans they contain. In particular, Current loans represent a relatively small number of loans but a larger proportion of exposure relative to their volume.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The concentration of $351.36 million in original exposure within Fully Paid loans reflects that the majority of the portfolio's lending activity has reached a completed outcome.
--
-- The Charged Off segment is financially more significant than its 13.82% share of loan volume alone suggests, accounting for approximately 15.04% of original exposure. This difference is consistent with its higher average loan amount of $12,288.06.
--
-- Current loans require particular attention from a portfolio monitoring perspective because only 2.85% of loans are in this category, yet they represent 4.33% of original exposure and have the highest average loan amount at $17,182.60.
--
-- This demonstrates why portfolio monitoring should consider both the number of loans and the financial exposure associated with each status category. A segment's importance to the portfolio cannot be determined from loan volume alone.





-- ========================================================================================================================
-- BUSINESS QUESTION 5: HOW HAS LOAN ORIGINATION ACTIVITY
-- CHANGED OVER TIME?
-- ========================================================================================================================

-- Purpose:
-- Examine changes in lending activity across the observed origination period using the number of loans originated, the share of total loan volume, total original exposure, and average loan amount for each month.
--
-- This analysis helps identify periods of relatively higher or lower lending activity and determine whether changes in loan volume were accompanied by changes in financial exposure.


SELECT
    strftime('%Y-%m', issue_date) AS origination_month,
    COUNT(*) AS total_loans,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loans),
        2
    ) AS loan_volume_pct,
    SUM(loan_amount) AS total_loan_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY strftime('%Y-%m', issue_date)
ORDER BY origination_month;


-- ========================================================================================================================
-- RESULT
-- ========================================================================================================================

-- Loan origination increased from 2,332 loans in January 2021 to 4,314 loans in December 2021. This represents an increase of approximately 85.0% in monthly loan volume.
--
-- Monthly original loan exposure increased from $25,031,650 in January to $53,981,425 in December, representing an increase of approximately 115.6%.
--
-- The share of annual portfolio loan volume increased from 6.05% in January to 11.18% in December.
--
-- Average loan size also increased from $10,733.98 in January to $12,513.08 in December, an increase of approximately 16.6%.
--
-- December recorded the highest loan volume, highest original exposure, and highest average loan amount in the observed period, while January recorded the lowest values for all three measures.
--
-- Apart from a small decline from January to February, monthly loan volume increased consistently through the remainder of the year, rising from 2,279 loans in February to 4,314 loans in December.


-- ========================================================================================================================
-- PORTFOLIO INSIGHT
-- ========================================================================================================================

-- Lending activity expanded substantially throughout 2021. Monthly loan volume increased by approximately 85.0% between January and December, while monthly original exposure more than doubled, increasing by approximately 115.6%.
--
-- The fact that exposure grew faster than loan volume indicates that the increase in lending activity was not driven solely by a greater number of loans. Average loan size also increase by approximately 16.6%, from $10,733.98 in January to $12,513.08 in December.
--
-- The strongest expansion occurred toward the end of the year. November recorded 4,035 loans and $47,754,825 in original exposure, while December increased to 4,314 loans and $53,981,425 in exposure.
--
-- December therefore represented 11.18% of the portfolio's total loan volume and approximately 12.39% of its total original exposure, despite representing only one month of the observed period.
--
-- Overall, the results show that lending activity increased in both volume and financial scale over the course of 2021, with the growth in exposure outpacing the growth in the number of loans.


-- ========================================================================================================================
-- BUSINESS IMPLICATION
-- ========================================================================================================================

-- The increase from $25.03 million in monthly original exposure in January to $53.98 million in December indicates that the portfolio was originating substantially more credit toward the end of the observed period.
--
-- Because exposure grew by approximately 115.6% while loan volume grew by approximately 85.0%, monitoring only the number of loans would understate the scale of the expansion in lending activity.
--
-- The 16.6% increase in average loan size provides an additional explanation for this difference. More loans were being originated while the typical amount extended per loan was also increasing.
--
-- From a portfolio management perspective, this means that changes in origination volume should be evaluated together with changes in average loan size and total exposure. This provides a more complete view of how the financial scale of the portfolio is changing over time.